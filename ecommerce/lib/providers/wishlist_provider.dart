import 'package:flutter/material.dart';
import '../models/product.dart';
import '../database_helper.dart';

class WishlistProvider extends ChangeNotifier {
  final List<Product> _wishlist = [];
  final DatabaseHelper _db = DatabaseHelper();
  // persisted ids loaded from the database; used to keep favorite state
  // until Product instances are resolved in memory.
  final Set<String> _wishlistIds = {};

  // NOTE: consumer of this provider is responsible for providing a way to
  // resolve productId -> Product when loading (simple approach: load all products
  // and match by id). For now we'll try to load product IDs and keep them until
  // the app's product list is available.
  WishlistProvider() {
    _loadFromDb();
  }

  List<Product> get wishlist => List.unmodifiable(_wishlist);

  // Internal: populate wishlist from DB stored ids if the product objects are
  // available in memory. This implementation assumes Product instances will be
  // provided elsewhere; if products aren't available this keeps IDs only.
  Future<void> _loadFromDb() async {
    try {
      final ids = await _db.getWishlistProductIds();
      _wishlistIds
        ..clear()
        ..addAll(ids);
      // Try to resolve persisted ids to Product objects from local DB
      // If products were persisted in the products table, load them and match by id.
      try {
        final products = await _db.getProducts();
        final resolved = products.where((p) => _wishlistIds.contains(p.id)).toList();
        if (resolved.isNotEmpty) {
          _wishlist
            ..clear()
            ..addAll(resolved);
        }
      } catch (e) {
        // ignore errors resolving products from local DB
      }
      // Note: if products are loaded from network (ProductProvider), call
      // resolveSavedIds(...) from that provider once data is available.
    } catch (e) {
      // ignore DB errors silently for now
    }
  }

  /// Resolve previously saved wishlist IDs against an in-memory product list.
  /// Call this from ProductProvider after products are loaded so the UI shows
  /// the full Product objects for persisted wishlist entries.
  void resolveSavedIds(List<Product> products) {
    final resolved = products.where((p) => _wishlistIds.contains(p.id)).toList();
    if (resolved.isNotEmpty) {
      // Preserve any in-memory wishlist entries and append resolved ones that
      // are not already present.
      for (final p in resolved) {
        if (!_wishlist.any((w) => w.id == p.id)) {
          _wishlist.add(p);
        }
      }
      notifyListeners();
    }
  }

  bool isInWishlist(Product product) {
    return _wishlist.any((p) => p.id == product.id) || _wishlistIds.contains(product.id);
  }

  void addToWishlist(Product product) {
    if (!isInWishlist(product)) {
      _wishlist.add(product);
      _wishlistIds.add(product.id);
      // persist (fire-and-forget)
      _db.addProductToWishlist(product.id);
      notifyListeners();
    }
  }

  void removeFromWishlist(Product product) {
    _wishlist.removeWhere((p) => p.id == product.id);
    _wishlistIds.remove(product.id);
    // persist (fire-and-forget)
    _db.removeProductFromWishlist(product.id);
    notifyListeners();
  }

  void toggleWishlist(Product product) {
    if (isInWishlist(product)) {
      removeFromWishlist(product);
    } else {
      addToWishlist(product);
    }
  }
}
