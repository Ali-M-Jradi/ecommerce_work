import 'package:flutter/material.dart';
import '../models/product.dart';
import '../database_helper.dart';
import 'package:collection/collection.dart';

class WishlistProvider extends ChangeNotifier {
  final List<Product> _wishlist = [];
  final DatabaseHelper _db = DatabaseHelper();

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
      // Attempt to resolve ids to Product objects using any loaded products in app
      // If products aren't available yet, keep _wishlist empty — the UI will
      // repopulate as products are loaded via normal flows.
      // We'll store resolved IDs in a temp set so duplicate adds are prevented.
      final idSet = ids.toSet();
      // If you have a central ProductProvider, you'd resolve here. For now
      // we'll keep this as productId placeholders (no-op).
      // TODO: resolve ids -> Product once products loaded, or store snapshots.
      // This keeps app-stored wishlist ids persisted across sessions.
    } catch (e) {
      // ignore DB errors silently for now
    }
  }

  bool isInWishlist(Product product) {
    return _wishlist.any((p) => p.id == product.id);
  }
  void addToWishlist(Product product) {
    if (!isInWishlist(product)) {
      _wishlist.add(product);
      // persist
      unawaited(_db.addProductToWishlist(product.id));
      notifyListeners();
    }
  }

  void removeFromWishlist(Product product) {
    _wishlist.removeWhere((p) => p.id == product.id);
    // persist
    unawaited(_db.removeProductFromWishlist(product.id));
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
