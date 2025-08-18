import 'dart:convert';
import 'package:http/http.dart' as http;

class SiteImagesApiService {
  static const String baseUrl = 'http://localhost:89';
  static const String imagesEndpoint = '/api/site-images';
  
  /// Fetches site images from the API
  static Future<List<Map<String, dynamic>>> fetchSiteImages() async {
    try {
      final uri = Uri.parse('$baseUrl$imagesEndpoint');
      print('🌐 Fetching images from: $uri');
      
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      print('📡 API Response Status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final dynamic jsonData = json.decode(response.body);
        print('📄 Raw API Response: $jsonData');
        
        if (jsonData is List) {
          // If response is directly a list of images
          return List<Map<String, dynamic>>.from(jsonData);
        } else if (jsonData is Map && jsonData.containsKey('data')) {
          // If response has a 'data' wrapper
          final List<dynamic> imagesList = jsonData['data'];
          return List<Map<String, dynamic>>.from(imagesList);
        } else if (jsonData is Map && jsonData.containsKey('images')) {
          // If response has an 'images' wrapper
          final List<dynamic> imagesList = jsonData['images'];
          return List<Map<String, dynamic>>.from(imagesList);
        } else {
          // Try to extract any array from the response
          final Map<String, dynamic> dataMap = jsonData;
          for (final value in dataMap.values) {
            if (value is List) {
              return List<Map<String, dynamic>>.from(value);
            }
          }
          
          // If it's a single object, wrap it in a list
          return [Map<String, dynamic>.from(jsonData)];
        }
      } else {
        throw Exception('Failed to load images. Status: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e) {
      print('❌ API Error: $e');
      throw Exception('Network error: $e');
    }
  }
  
  /// Extracts image URL from API response item
  static String getImageUrlFromItem(Map<String, dynamic> item) {
    // Try different possible field names for image URLs
    final possibleFields = [
      'imageUrl', 'image_url', 'url', 'src', 'path', 
      'imagePath', 'image_path', 'photo', 'picture',
      'file', 'filename', 'name'
    ];
    
    for (final field in possibleFields) {
      if (item.containsKey(field) && item[field] != null) {
        String imageUrl = item[field].toString();
        
        // If it's a relative URL, make it absolute
        if (imageUrl.startsWith('/')) {
          return '$baseUrl$imageUrl';
        } else if (!imageUrl.startsWith('http')) {
          return '$baseUrl/$imageUrl';
        }
        
        return imageUrl;
      }
    }
    
    // Fallback: return the first string value found
    for (final value in item.values) {
      if (value is String && value.isNotEmpty) {
        if (value.startsWith('/')) {
          return '$baseUrl$value';
        } else if (!value.startsWith('http')) {
          return '$baseUrl/$value';
        }
        return value;
      }
    }
    
    return '';
  }
  
  /// Gets a formatted list of carousel images from API
  static Future<List<String>> getCarouselImages() async {
    try {
      final apiImages = await fetchSiteImages();
      print('🖼️ Found ${apiImages.length} images from API');
      
      final carouselImages = apiImages.map((item) {
        final imageUrl = getImageUrlFromItem(item);
        print('🔗 Image URL: $imageUrl');
        return imageUrl;
      }).where((url) => url.isNotEmpty).toList();
      
      print('✅ Processed ${carouselImages.length} valid image URLs');
      return carouselImages;
    } catch (e) {
      print('❌ Error getting carousel images: $e');
      return [];
    }
  }
}
