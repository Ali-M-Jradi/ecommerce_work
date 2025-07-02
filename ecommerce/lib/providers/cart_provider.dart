import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

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
  void addItem(Map<String, dynamic> product, {int quantity = 1}) {
    final productId = product['id']?.toString() ?? product['name'] ?? '';
    
    // Check if item already exists in cart
    final existingItemIndex = _items.indexWhere((item) => item.productId == productId);
    
    if (existingItemIndex >= 0) {
      // Update quantity of existing item
      _items[existingItemIndex].quantity += quantity;
    } else {
      // Add new item to cart
      _items.add(CartItem.fromProduct(product, quantity: quantity));
    }
    
    notifyListeners();
  }

  // Remove item from cart completely
  void removeItem(String cartItemId) {
    _items.removeWhere((item) => item.id == cartItemId);
    notifyListeners();
  }

  // Remove item by product ID
  void removeItemByProductId(String productId) {
    _items.removeWhere((item) => item.productId == productId);
    notifyListeners();
  }

  // Update item quantity
  void updateItemQuantity(String cartItemId, int newQuantity) {
    if (newQuantity <= 0) {
      removeItem(cartItemId);
      return;
    }
    
    final itemIndex = _items.indexWhere((item) => item.id == cartItemId);
    if (itemIndex >= 0) {
      _items[itemIndex].quantity = newQuantity;
      notifyListeners();
    }
  }

  // Increase item quantity by 1
  void increaseQuantity(String cartItemId) {
    final itemIndex = _items.indexWhere((item) => item.id == cartItemId);
    if (itemIndex >= 0) {
      _items[itemIndex].quantity++;
      notifyListeners();
    }
  }

  // Decrease item quantity by 1
  void decreaseQuantity(String cartItemId) {
    final itemIndex = _items.indexWhere((item) => item.id == cartItemId);
    if (itemIndex >= 0) {
      if (_items[itemIndex].quantity > 1) {
        _items[itemIndex].quantity--;
      } else {
        removeItem(cartItemId);
      }
      notifyListeners();
    }
  }

  // Clear all items from cart
  void clearCart() {
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
