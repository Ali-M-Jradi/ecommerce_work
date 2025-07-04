import 'package:flutter/material.dart';
import 'products_data_provider.dart';
import 'products_page_types.dart';

/// Service class for handling Products Page business logic and data operations
class ProductsPageService {
  // Singleton pattern
  static final ProductsPageService _instance = ProductsPageService._internal();
  factory ProductsPageService() => _instance;
  ProductsPageService._internal();

  // Cache for sorted products
  Map<String, List<Map<String, dynamic>>> _sortedProductsCache = {};

  /// Get products sorted by the specified criteria
  List<Map<String, dynamic>> getSortedProducts(String sortBy) {
    // Check cache first
    if (_sortedProductsCache.containsKey(sortBy)) {
      return _sortedProductsCache[sortBy]!;
    }

    // Get products and sort them
    final products = ProductsDataProvider.getSortedProducts(sortBy);
    
    // Cache the result
    _sortedProductsCache[sortBy] = products;
    
    return products;
  }

  /// Clear the cache (useful when data changes)
  void clearCache() {
    _sortedProductsCache.clear();
  }

  /// Search products by name or description
  List<Map<String, dynamic>> searchProducts(String query, String sortBy, [BuildContext? context]) {
    if (query.isEmpty) return getSortedProducts(sortBy);
    
    final allProducts = getSortedProducts(sortBy);
    return allProducts.where((product) {
      // Use localized names and descriptions if context is available
      String name = '';
      String description = '';
      
      if (context != null) {
        name = ProductsDataProvider.getLocalizedName(product, context).toLowerCase();
        description = ProductsDataProvider.getLocalizedDescription(product, context).toLowerCase();
      } else {
        // Fallback: check both English and Arabic names/descriptions
        if (product['name'] is Map) {
          name = '${product['name']['en'] ?? ''} ${product['name']['ar'] ?? ''}'.toLowerCase();
        } else {
          name = product['name']?.toString().toLowerCase() ?? '';
        }
        
        if (product['description'] is Map) {
          description = '${product['description']['en'] ?? ''} ${product['description']['ar'] ?? ''}'.toLowerCase();
        } else {
          description = product['description']?.toString().toLowerCase() ?? '';
        }
      }
      
      final searchQuery = query.toLowerCase();
      return name.contains(searchQuery) || description.contains(searchQuery);
    }).toList();
  }

  /// Filter products by price range
  List<Map<String, dynamic>> filterProductsByPriceRange(
    String sortBy, 
    double minPrice, 
    double maxPrice
  ) {
    final allProducts = getSortedProducts(sortBy);
    return allProducts.where((product) {
      final price = (product['price'] ?? 0.0) as double;
      return price >= minPrice && price <= maxPrice;
    }).toList();
  }

  /// Filter products by category
  List<Map<String, dynamic>> filterProductsByCategory(String sortBy, String category) {
    if (category.isEmpty) return getSortedProducts(sortBy);
    
    final allProducts = getSortedProducts(sortBy);
    return allProducts.where((product) {
      final productCategory = product['category']?.toString() ?? '';
      return productCategory.toLowerCase() == category.toLowerCase();
    }).toList();
  }

  /// Get unique categories from all products
  List<String> getAvailableCategories() {
    final allProducts = ProductsDataProvider.getDemoProducts();
    final categories = <String>{};
    
    for (final product in allProducts) {
      final category = product['category']?.toString();
      if (category != null && category.isNotEmpty) {
        categories.add(category);
      }
    }
    
    return categories.toList()..sort();
  }

  /// Add product to favorites (placeholder for future implementation)
  Future<bool> addToFavorites(Map<String, dynamic> product) async {
    // TODO: Implement actual favorites functionality
    // This could integrate with a local database or API
    await Future.delayed(Duration(milliseconds: 500)); // Simulate network delay
    return true;
  }

  /// Remove product from favorites (placeholder for future implementation)
  Future<bool> removeFromFavorites(Map<String, dynamic> product) async {
    // TODO: Implement actual favorites functionality
    await Future.delayed(Duration(milliseconds: 500)); // Simulate network delay
    return true;
  }

  /// Add product to cart (placeholder for future implementation)
  Future<bool> addToCart(Map<String, dynamic> product, int quantity) async {
    // TODO: Implement actual cart functionality
    await Future.delayed(Duration(milliseconds: 500)); // Simulate network delay
    return true;
  }

  /// Update product rating (placeholder for future implementation)
  Future<bool> updateProductRating(Map<String, dynamic> product, double rating) async {
    // TODO: Implement actual rating functionality
    // This could integrate with a backend API
    await Future.delayed(Duration(milliseconds: 500)); // Simulate network delay
    
    // Update local data for now
    product['rating'] = rating;
    clearCache(); // Clear cache since data changed
    
    return true;
  }

  /// Get recommended products based on current product
  List<Map<String, dynamic>> getRecommendedProducts(
    Map<String, dynamic> currentProduct, 
    {int limit = 4}
  ) {
    final allProducts = ProductsDataProvider.getDemoProducts();
    final currentCategory = currentProduct['category']?.toString() ?? '';
    
    // Filter by same category, excluding current product
    final recommended = allProducts.where((product) {
      final category = product['category']?.toString() ?? '';
      
      // Compare products by ID if available, otherwise by English name
      final productId = product['id']?.toString();
      final currentProductId = currentProduct['id']?.toString();
      
      if (productId != null && currentProductId != null) {
        return category == currentCategory && productId != currentProductId;
      }
      
      // Fallback to name comparison using English names
      final name = product['name'] is Map 
        ? product['name']['en'] ?? '' 
        : product['name']?.toString() ?? '';
      final currentName = currentProduct['name'] is Map 
        ? currentProduct['name']['en'] ?? ''
        : currentProduct['name']?.toString() ?? '';
      
      return category == currentCategory && name != currentName;
    }).toList();
    
    // Take only the specified limit
    return recommended.take(limit).toList();
  }

  /// Validate sort option
  bool isValidSortOption(String sortBy) {
    // Check if the sortBy string matches any of the valid SortOption display names
    return SortOption.values.any((option) => option.displayName == sortBy);
  }

  /// Get sort option enum from string
  SortOption getSortOptionFromString(String sortBy) {
    return SortOption.fromString(sortBy);
  }
}
