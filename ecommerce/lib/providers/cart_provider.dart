import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../pages/products_page/products_page_widgets/products_data_provider.dart';
import '../database_helper.dart';
import '../services/parameter_service.dart';

class CartProvider extends ChangeNotifier {
  // Debug DB-clear utilities were removed to prevent accidental wipes.

  final List<CartItem> _items = [];
  final DatabaseHelper _dbHelper = DatabaseHelper();
  String? _currentUserId; // Track current user

  // Load cart items from SQLite on initialization
  CartProvider() {
    _loadCartFromDb();
  }

  /// Set the current user and reload cart
  void setCurrentUser(String? userId) {
    if (_currentUserId != userId) {
      _currentUserId = userId;
      print('CartProvider: Setting user to $userId');
      _loadCartFromDb();
    }
  }

  /// Get current user ID
  String? get currentUserId => _currentUserId;

  Future<void> _loadCartFromDb() async {
    final items = await _dbHelper.getCartItems(userId: _currentUserId);
    _items.clear();
    // Ensure each loaded item has its id set from the database and is for current user
    _items.addAll(items
        .where((item) => _currentUserId == null || item.userId == _currentUserId)
        .map((item) => item.copyWith(id: item.id.toString())));
    print('CartProvider: Loaded ${_items.length} items for user $_currentUserId');
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

  // Add item to cart with parameter validation
  Future<void> addItem(Map<String, dynamic> product, {int quantity = 1, BuildContext? context}) async {
    final productId = product['id']?.toString() ?? '';
    // Require context for localization
    if (context == null) {
      throw ArgumentError('BuildContext is required for localized name');
    }

    // Check cart size limit from parameters
    final newTotalItems = itemCount + quantity;
    if (!ParameterService.isCartSizeValid(context, newTotalItems)) {
      throw Exception(ParameterService.getCartSizeErrorMessage(context));
    }

    final name = ProductsDataProvider.getLocalizedName(product, context);
    final brand = product['brand']?.toString() ?? '';
    var price = product['price'] is num ? (product['price'] as num).toDouble() : double.tryParse(product['price']?.toString() ?? '') ?? 0.0;
    
    // Apply global discount from parameters
    price = ParameterService.applyGlobalDiscount(context, price);
    
    final image = product['image']?.toString() ?? '';
    final size = product['size']?.toString();
    final category = product['category']?.toString();
    final description = product['description']?.toString();
    final existingItemIndex = _items.indexWhere((item) => item.productId == productId);
    if (existingItemIndex >= 0) {
      // Check cart size limit for quantity increase
      final newQuantity = _items[existingItemIndex].quantity + quantity;
      if (!ParameterService.isCartSizeValid(context, (itemCount - _items[existingItemIndex].quantity) + newQuantity)) {
        throw Exception(ParameterService.getCartSizeErrorMessage(context));
      }
      
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
        userId: _currentUserId, // Associate with current user
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

  // Get cart summary with parameter-driven calculations
  Map<String, dynamic> getCartSummary([BuildContext? context]) {
    final subtotal = totalAmount;
    final shipping = context != null ? ParameterService.calculateShipping(context, subtotal) : 0.0;
    final total = subtotal + shipping;
    final isOrderValid = context != null ? ParameterService.isOrderValueValid(context, subtotal) : true;
    
    return {
      'itemCount': itemCount,
      'subtotal': subtotal,
      'shipping': shipping,
      'totalAmount': total,
      'formattedSubtotal': '\$${subtotal.toStringAsFixed(2)}',
      'formattedShipping': shipping == 0.0 ? 'Free' : '\$${shipping.toStringAsFixed(2)}',
      'formattedTotal': '\$${total.toStringAsFixed(2)}',
      'isEmpty': isEmpty,
      'isOrderValid': isOrderValid,
      'minOrderError': context != null && !isOrderValid ? ParameterService.getMinOrderErrorMessage(context) : null,
      'freeShippingThreshold': context != null ? ParameterService.getFreeShippingThreshold(context) : 0.0,
    };
  }

  // Get shipping cost using parameters
  double getShippingCost([BuildContext? context]) {
    if (context == null) return 0.0;
    return ParameterService.calculateShipping(context, totalAmount);
  }

  // Get total with shipping
  double getTotalWithShipping([BuildContext? context]) {
    return totalAmount + getShippingCost(context);
  }

  // Check if free shipping threshold is met
  bool isFreeShippingEligible([BuildContext? context]) {
    if (context == null) return false;
    return totalAmount >= ParameterService.getFreeShippingThreshold(context);
  }

  // Get amount needed for free shipping
  double getAmountNeededForFreeShipping([BuildContext? context]) {
    if (context == null) return 0.0;
    final threshold = ParameterService.getFreeShippingThreshold(context);
    final needed = threshold - totalAmount;
    return needed > 0 ? needed : 0.0;
  }

  // Validate cart against parameters
  bool isCartValid([BuildContext? context]) {
    if (context == null) return true;
    return ParameterService.isCartSizeValid(context, itemCount) && 
           ParameterService.isOrderValueValid(context, totalAmount);
  }

  // Get cart validation errors
  List<String> getCartValidationErrors([BuildContext? context]) {
    final errors = <String>[];
    if (context == null) return errors;
    
    if (!ParameterService.isCartSizeValid(context, itemCount)) {
      errors.add(ParameterService.getCartSizeErrorMessage(context));
    }
    
    if (!ParameterService.isOrderValueValid(context, totalAmount)) {
      errors.add(ParameterService.getMinOrderErrorMessage(context));
    }
    
    return errors;
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
