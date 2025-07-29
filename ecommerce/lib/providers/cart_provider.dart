import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../pages/products_page/products_page_widgets/products_data_provider.dart';
import '../database_helper.dart';
class CartProvider extends ChangeNotifier {
  // Utility: Clear cart table in database (for schema/data reset)
  Future<void> clearCartTable() async {
    await _dbHelper.clearCartTable();
    _items.clear();
    notifyListeners();
  }
  // Utility: Clear cart table in database (for schema/data reset)
  Future<void> clearCartTableAndReload() async {
    await _dbHelper.clearCartTable();
    await _loadCartFromDb();
  }

  final List<CartItem> _items = [];
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Load cart items from SQLite on initialization
  CartProvider() {
    _loadCartFromDb();
  }

  Future<void> _loadCartFromDb() async {
    final items = await _dbHelper.getCartItems();
    _items.clear();
    // Ensure each loaded item has its id set from the database
    _items.addAll(items.map((item) => item.copyWith(id: item.id.toString())));
    print('[CartProvider] Loaded ${_items.length} items from DB: $_items');
    notifyListeners();
  }

  // Getters
  List<CartItem> get items => List.unmodifiable(_items);
  
  int get itemCount => _items.fold(0, (total, item) => total + item.quantity);
  
  double get totalAmount => _items.fold(0.0, (total, item) => total + item.totalPrice);
  
  bool get isEmpty => _items.isEmpty;
  
  bool get isNotEmpty => _items.isNotEmpty;

  // Check if a product is already in cart
  bool isInCart(String productId) {
    return _items.any((item) => item.productId == productId);
  }

  // Get cart item by product ID
  CartItem? getCartItemByProductId(String productId) {
    try {
      return _items.firstWhere((item) => item.productId == productId);
    } catch (e) {
      return null;
    }
  }

  // Add item to cart
  Future<void> addItem(Map<String, dynamic> product, {int quantity = 1, BuildContext? context}) async {
    final productId = product['id']?.toString() ?? '';
    // Require context for localization
    if (context == null) {
      throw ArgumentError('BuildContext is required for localized name');
    }
    final name = ProductsDataProvider.getLocalizedName(product, context);
    final brand = product['brand']?.toString() ?? '';
    final price = product['price'] is num ? (product['price'] as num).toDouble() : double.tryParse(product['price']?.toString() ?? '') ?? 0.0;
    final image = product['image']?.toString() ?? '';
    final size = product['size']?.toString();
    final category = product['category']?.toString();
    final description = product['description']?.toString();
    final existingItemIndex = _items.indexWhere((item) => item.productId == productId);
    if (existingItemIndex >= 0) {
      _items[existingItemIndex].quantity += quantity;
      await _dbHelper.updateCartItem(_items[existingItemIndex]);
      print('[CartProvider] Updated item in DB: ${_items[existingItemIndex]}');
      notifyListeners(); // Ensure UI updates immediately after quantity change
    } else {
      final newItem = CartItem(
        id: '',
        productId: productId,
        name: name,
        brand: brand,
        price: price,
        image: image,
        size: size,
        category: category,
        quantity: quantity,
        description: description,
        originalProduct: product, // <-- Set originalProduct for localization
      );
      final id = await _dbHelper.insertCartItem(newItem);
      // Use the id returned from SQLite
      final itemWithId = newItem.copyWith(id: id.toString());
      _items.add(itemWithId);
      print('[CartProvider] Inserted new item in DB: $itemWithId');
      notifyListeners(); // Ensure UI updates immediately after adding new item
    }
  }

  // Remove item from cart completely
  Future<void> removeItem(String cartItemId) async {
    final idx = _items.indexWhere((item) => item.id == cartItemId);
    if (idx >= 0) {
      final item = _items[idx];
      await _dbHelper.deleteCartItem(int.tryParse(item.id) ?? 0);
      _items.removeAt(idx);
      notifyListeners();
    }
  }

  // Remove item by product ID
  Future<void> removeItemByProductId(String productId) async {
    final idx = _items.indexWhere((item) => item.productId == productId);
    if (idx >= 0) {
      final item = _items[idx];
      await _dbHelper.deleteCartItem(int.tryParse(item.id) ?? 0);
      _items.removeAt(idx);
      notifyListeners();
    }
  }

  // Update item quantity
  Future<void> updateItemQuantity(String cartItemId, int newQuantity) async {
    if (newQuantity <= 0) {
      await removeItem(cartItemId);
      return;
    }
    final itemIndex = _items.indexWhere((item) => item.id == cartItemId);
    if (itemIndex >= 0) {
      _items[itemIndex].quantity = newQuantity;
      await _dbHelper.updateCartItem(_items[itemIndex]);
      notifyListeners();
    }
  }

  // Increase item quantity by 1
  Future<void> increaseQuantity(String cartItemId) async {
    final itemIndex = _items.indexWhere((item) => item.id == cartItemId);
    if (itemIndex >= 0) {
      _items[itemIndex].quantity++;
      await _dbHelper.updateCartItem(_items[itemIndex]);
      notifyListeners();
    }
  }

  // Decrease item quantity by 1
  Future<void> decreaseQuantity(String cartItemId) async {
    final itemIndex = _items.indexWhere((item) => item.id == cartItemId);
    if (itemIndex >= 0) {
      if (_items[itemIndex].quantity > 1) {
        _items[itemIndex].quantity--;
        await _dbHelper.updateCartItem(_items[itemIndex]);
      } else {
        await removeItem(cartItemId);
      }
      notifyListeners();
    }
  }

  // Clear all items from cart
  Future<void> clearCart() async {
    for (var item in _items) {
      await _dbHelper.deleteCartItem(int.tryParse(item.id) ?? 0);
    }
    _items.clear();
    notifyListeners();
  }

  // Get formatted total amount
  String get formattedTotalAmount {
    return '\$${totalAmount.toStringAsFixed(2)}';
  }

  // Get cart summary
  Map<String, dynamic> getCartSummary() {
    return {
      'itemCount': itemCount,
      'totalAmount': totalAmount,
      'formattedTotal': formattedTotalAmount,
      'isEmpty': isEmpty,
    };
  }

  // Debug: Print cart contents
  void printCartContents() {
    if (kDebugMode) {
      print('=== CART CONTENTS ===');
      print('Total items: $itemCount');
      print('Total amount: $formattedTotalAmount');
      for (var item in _items) {
        print('${item.name} x${item.quantity} = \$${item.totalPrice.toStringAsFixed(2)}');
      }
      print('====================');
    }
  }
}
