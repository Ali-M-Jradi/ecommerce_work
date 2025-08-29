import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'wishlist_provider.dart';
import '../models/product.dart';
import '../pages/products_page/products_page_widgets/products_data_provider.dart';

class ProductProvider extends ChangeNotifier {
  final List<Product> _products = [];

  ProductProvider() {
    // Load demo products at startup
    _products.addAll(
      ProductsDataProvider.getDemoProducts()
        .map((map) => Product.fromMap(map))
        .toList()
    );
  }

  List<Product> get products => List.unmodifiable(_products);

  /// Called by the app after providers are registered so dependent providers
  /// (like WishlistProvider) can resolve saved IDs against loaded products.
  void notifyProductsReady(BuildContext context) {
    try {
      final wishlistProvider = Provider.of<WishlistProvider?>(context, listen: false);
      if (wishlistProvider != null) {
        wishlistProvider.resolveSavedIds(_products);
      }
    } catch (e) {
      // ignore if wishlist provider isn't available
    }
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

  void addProduct(Product product) {
    _products.add(product);
    notifyListeners();
  }

  void updateProduct(Product product) {
    final idx = _products.indexWhere((p) => p.id == product.id);
    if (idx >= 0) {
      _products[idx] = product;
      notifyListeners();
    }
  }

  void deleteProduct(String id) {
    _products.removeWhere((p) => p.id == id);
    notifyListeners();
  }
}
