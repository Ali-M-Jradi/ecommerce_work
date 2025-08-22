import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/simple_products_service.dart';

class ApiProductProvider extends ChangeNotifier {
  bool _loading = false;
  String? _error;
  final List<Product> _products = [];

  bool get isLoading => _loading;
  String? get error => _error;
  List<Product> get products => List.unmodifiable(_products);

  ApiProductProvider() {
    fetch();
  }

  Future<void> fetch() async {
    print('🚀 DEBUG: ApiProductProvider.fetch() called');
    _loading = true;
    _error = null;
    notifyListeners();
    
    try {
      print('🔄 DEBUG: Calling SimpleProductsService.fetchProducts()');
      final products = await SimpleProductsService.fetchProducts();
      print('📦 DEBUG: Received ${products.length} Product objects from service');
      
      _products.clear();
      _products.addAll(products);
      
      print('� DEBUG: Successfully loaded ${_products.length} enhanced products');
      for (var product in _products.take(3)) { // Log first 3 products
        print('✨ DEBUG: Product: ${product.name} - Price: \$${product.price} - Has discount: ${product.hasDiscount} - Stock: ${product.stock}');
      }
      
    } catch (e) {
      print('💥 DEBUG: Error in fetch(): $e');
      _error = e.toString();
      // Fallback to demo data if API fails
      print('🔄 DEBUG: Loading demo data as fallback');
      _loadDemoData();
    } finally {
      _loading = false;
      notifyListeners();
      print('🏁 DEBUG: fetch() completed, loading: $_loading, error: $_error, products: ${_products.length}');
    }
  }

  void _loadDemoData() {
    _products.addAll([
      Product(
        id: '1',
        name: 'Demo Premium Product 1',
        price: 29.99,
        originalPrice: 39.99,
        image: SimpleProductsService.getProductImageUrl('1'),
        images: [SimpleProductsService.getProductImageUrl('1')],
        brand: 'Demo Brand',
        category: 'face_care',
        description: 'Premium demo product with enhanced features',
        size: '50ml',
        rating: 4.5,
        reviewCount: 25,
        soldOut: false,
        stock: 15,
        features: ['Premium Quality', 'Dermatologically Tested', 'Natural Ingredients'],
        specifications: {
          'Brand': 'Demo Brand',
          'Size': '50ml',
          'Type': 'Face Care',
          'Origin': 'Premium'
        },
        colors: ['Natural', 'Light'],
        sizes: ['50ml', '100ml'],
        sku: 'DEMO-001',
        isNew: true,
        isFeatured: true,
      ),
      Product(
        id: '2',
        name: 'Demo Body Care Product',
        price: 39.99,
        image: SimpleProductsService.getProductImageUrl('2'),
        images: [SimpleProductsService.getProductImageUrl('2')],
        brand: 'Demo Brand',
        category: 'body_care',
        description: 'Luxurious body care product for daily use',
        size: '100ml',
        rating: 4.2,
        reviewCount: 18,
        soldOut: false,
        stock: 8,
        features: ['Moisturizing', 'Long Lasting', 'Gentle Formula'],
        specifications: {
          'Brand': 'Demo Brand',
          'Size': '100ml',
          'Type': 'Body Care',
          'Scent': 'Fresh'
        },
        colors: ['Original'],
        sizes: ['100ml', '200ml'],
        sku: 'DEMO-002',
        isBestSeller: true,
      ),
    ]);
  }

  List<Product> getFilteredSortedProducts({String searchQuery = '', String sortBy = 'A to Z'}) {
    List<Product> filtered = _products;
    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((p) => p.name.toLowerCase().contains(searchQuery.toLowerCase())).toList();
    }
    switch (sortBy) {
      case 'A to Z':
        filtered.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'Z to A':
        filtered.sort((a, b) => b.name.compareTo(a.name));
        break;
      case 'Price Low':
        filtered.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Price High':
        filtered.sort((a, b) => b.price.compareTo(a.price));
        break;
    }
    return filtered;
  }
}
