import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import 'category_classifier.dart';

/// Simple service to fetch products from the API
class SimpleProductsService {
  static String baseUrl = 'https://localhost:7184'; // Will be updated when connection succeeds
  
  // Use HTTP port 5000 for mobile dev (preferred) and HTTPS 7184 as fallback
  static const List<String> fallbackUrls = [
    'http://192.168.137.1:5000',   // Windows hotspot IP - HTTP (preferred for mobile)
    'http://192.168.100.54:5000',  // Ethernet IP - HTTP (preferred for mobile)
    'https://192.168.137.1:7184', // Windows hotspot IP - HTTPS fallback
    'https://192.168.100.54:7184', // Ethernet IP - HTTPS fallback
    'http://localhost:5000',       // HTTP localhost
    'https://localhost:7184',      // HTTPS localhost fallback
    'http://10.0.2.2:5000',        // Android emulator host - HTTP
    'http://127.0.0.1:5000',       // Localhost IP - HTTP
  ];
  
  /// Fetch products from /api/items with fallback URLs and return Product objects
  static Future<List<Product>> fetchProducts() async {
    Exception? lastError;
    
    print('🔍 DEBUG: Starting fetchProducts() - trying ${fallbackUrls.length} URLs');
    
    for (int i = 0; i < fallbackUrls.length; i++) {
      final url = fallbackUrls[i];
      try {
        print('🌐 DEBUG: [$i] Trying to fetch products from: $url/api/items');
        final response = await http.get(
          Uri.parse('$url/api/items'),
          headers: {'Content-Type': 'application/json'},
        ).timeout(const Duration(seconds: 8));
        
        print('📡 DEBUG: [$i] Response status: ${response.statusCode} from $url');
        
        if (response.statusCode == 200) {
          print('✅ DEBUG: [$i] Products API success from: $url');
          print('📦 DEBUG: Full API response:');
          print(response.body);
          
          // Update the base URL for image URLs
          baseUrl = url;
          final data = jsonDecode(response.body);
          if (data is List) {
            print('🎯 DEBUG: Successfully parsed ${data.length} raw products');
            
            // Debug: Show first product structure
            if (data.isNotEmpty) {
              print('🔍 DEBUG: First product structure: ${data[0]}');
            }
            
            // Convert raw API data to Product objects with enhanced mapping
            List<Product> products = data.map<Product>((item) => _mapApiItemToProduct(item)).toList();
            
            print('✨ DEBUG: Mapped ${products.length} products to Product objects');
            return products;
          }
          print('⚠️  DEBUG: Response is not a list, returning empty');
          return [];
        } else {
          print('❌ DEBUG: [$i] Products API failed from $url: ${response.statusCode}');
          lastError = Exception('Failed to load products from $url: ${response.statusCode}');
        }
      } catch (e) {
        print('❌ DEBUG: [$i] Connection error to $url: $e');
        lastError = Exception('Error fetching products from $url: $e');
      }
    }
    
    print('💥 DEBUG: All URLs failed, throwing error');
    throw lastError ?? Exception('All URLs failed');
  }
  
  /// Maps raw API item data to enhanced Product model
  static Product _mapApiItemToProduct(Map<String, dynamic> item) {
    print('🔍 RAW API ITEM: $item');
    
    // Create a new map with the proper field mapping for Product model
    Map<String, dynamic> mappedItem = {};
    
    // Map actual API fields to Product model fields
    // API Structure: {ID, Name, Symbol, Barcode, Notes, SerialNumber, UsedTo, Indication, Warning, Mechanism, SideEffects, Ingredients, Composition, Price}
    String productId = item['ID']?.toString() ?? '';
    
    mappedItem['id'] = productId;
    mappedItem['name'] = item['Name'] ?? '';
    mappedItem['description'] = item['Notes'] ?? '';
    mappedItem['price'] = item['Price'] ?? 0.0;
  // Derive category from textual fields instead of a fixed placeholder
  mappedItem['category'] = classifyCategory(item);
    
    // Use Symbol field as size/format (e.g., "Tube de 50 ml")
    mappedItem['size'] = item['Symbol'] ?? '';
    
  // Map brand if present in the API item
  mappedItem['brand'] = item['Brand'] ?? item['Manufacturer'] ?? '';
    mappedItem['barcode'] = item['Barcode'] ?? '';
    mappedItem['serialNumber'] = item['SerialNumber'] ?? '';
    
    // Create detailed description from medical fields
    List<String> detailParts = [];
    if (item['UsedTo'] != null && item['UsedTo'].toString().isNotEmpty) {
      detailParts.add('Usage: ${item['UsedTo']}');
    }
    if (item['Indication'] != null && item['Indication'].toString().isNotEmpty) {
      detailParts.add('Indication: ${item['Indication']}');
    }
    if (item['Warning'] != null && item['Warning'].toString().isNotEmpty) {
      detailParts.add('Warning: ${item['Warning']}');
    }
    if (item['Mechanism'] != null && item['Mechanism'].toString().isNotEmpty) {
      detailParts.add('Mechanism: ${item['Mechanism']}');
    }
    if (item['SideEffects'] != null && item['SideEffects'].toString().isNotEmpty) {
      detailParts.add('Side Effects: ${item['SideEffects']}');
    }
    if (item['Ingredients'] != null && item['Ingredients'].toString().isNotEmpty) {
      detailParts.add('Ingredients: ${item['Ingredients']}');
    }
    if (item['Composition'] != null && item['Composition'].toString().isNotEmpty) {
      detailParts.add('Composition: ${item['Composition']}');
    }
    
    // Combine original description with medical details
    String fullDescription = mappedItem['description'] ?? '';
    if (detailParts.isNotEmpty) {
      if (fullDescription.isNotEmpty) fullDescription += '\n\n';
      fullDescription += detailParts.join('\n\n');
    }
    mappedItem['description'] = fullDescription;
    
    // Set image URL
    if (productId.isNotEmpty) {
      mappedItem['image'] = getProductImageUrl(productId);
      mappedItem['images'] = [getProductImageUrl(productId)];
    } else {
      mappedItem['image'] = '';
      mappedItem['images'] = [];
    }
    
    // Add default enhanced e-commerce fields
    mappedItem['reviewCount'] = 0;
    mappedItem['rating'] = 4.0; // Default rating
    mappedItem['stock'] = 10;
    mappedItem['sku'] = productId;
    mappedItem['dateAdded'] = DateTime.now().toIso8601String();
    mappedItem['isNew'] = false;
    mappedItem['isFeatured'] = false;
    mappedItem['isBestSeller'] = false;
    
  // Create features from available medical fields (do not tag as pharmaceutical)
    List<String> features = [];
    if (item['UsedTo'] != null && item['UsedTo'].toString().isNotEmpty) {
      features.add('Medical Use: ${item['UsedTo']}');
    }
    if (item['Mechanism'] != null && item['Mechanism'].toString().isNotEmpty) {
      features.add('Active Mechanism');
    }
    if (item['Ingredients'] != null && item['Ingredients'].toString().isNotEmpty) {
      features.add('Active Ingredients Listed');
    }
  // Keep feature list factual based on available fields; avoid adding pharmaceutical labels
    mappedItem['features'] = features;
    
    // Create specifications from medical data
    Map<String, String> specifications = {};
    specifications['Product ID'] = productId;
    specifications['Format'] = item['Symbol'] ?? 'N/A';
  // Use the derived classifier category or fallback
  specifications['Category'] = mappedItem['category']?.toString() ?? 'unknown';
    if (item['Barcode'] != null && item['Barcode'].toString().isNotEmpty) {
      specifications['Barcode'] = item['Barcode'].toString();
    }
    if (item['SerialNumber'] != null && item['SerialNumber'].toString().isNotEmpty) {
      specifications['Serial Number'] = item['SerialNumber'].toString();
    }
    mappedItem['specifications'] = specifications;
    
  // No colors/sizes for this type of product unless specified
    mappedItem['colors'] = [];
    mappedItem['sizes'] = [];
    
    // Handle pricing - if price is 0, set a default
    double price = double.tryParse(mappedItem['price'].toString()) ?? 0;
    if (price <= 0) {
      mappedItem['price'] = 29.99; // Default price for display
    }
    
    print('🔧 MAPPED PRODUCT: ID=$productId, Name=${mappedItem['name']}, Price=${mappedItem['price']}');
    
    try {
      Product product = Product.fromMap(mappedItem);
      print('✅ Successfully created Product: ${product.name}');
      return product;
    } catch (e) {
      print('❌ ERROR creating Product from mapped data: $e');
      print('🔍 Mapped item data: $mappedItem');
      rethrow;
    }
  }
  

  
  /// Get image URL for a product using the successful base URL
  static String getProductImageUrl(String productId) {
    return '$baseUrl/api/item-photo/$productId';
  }
  
  /// Legacy method for backward compatibility - returns raw maps
  static Future<List<Map<String, dynamic>>> fetchProductsRaw() async {
    List<Product> products = await fetchProducts();
    return products.map((product) => product.toMap()).toList();
  }
}
