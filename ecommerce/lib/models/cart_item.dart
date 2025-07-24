import 'package:flutter/material.dart';
import '../pages/products_page/products_page_widgets/products_data_provider.dart';

class CartItem {
  final String id;
  final String productId;
  final String name;
  final String brand;
  final double price;
  final String image;
  final String? size;
  final String? category;
  int quantity;
  final String? description;
  final Map<String, dynamic>? originalProduct; // Store original product data for localization

  CartItem({
    required this.id,
    required this.productId,
    required this.name,
    required this.brand,
    required this.price,
    required this.image,
    this.size,
    this.category,
    this.quantity = 1,
    this.description,
    this.originalProduct,
  });

  // Calculate total price for this cart item
  double get totalPrice => price * quantity;

  // Get localized name (uses original product data if available)
  String getLocalizedName(BuildContext context) {
    if (originalProduct != null) {
      return ProductsDataProvider.getLocalizedName(originalProduct!, context);
    }
    return name; // Fallback to stored name
  }

  // Get localized description (uses original product data if available)
  String getLocalizedDescription(BuildContext context) {
    if (originalProduct != null) {
      return ProductsDataProvider.getLocalizedDescription(originalProduct!, context);
    }
    return description ?? ''; // Fallback to stored description
  }

  // Create CartItem from product data
  factory CartItem.fromProduct(Map<String, dynamic> product, {int quantity = 1, BuildContext? context}) {
    // Handle price conversion from string or number
    double parsePrice(dynamic priceValue) {
      if (priceValue == null) return 0.0;
      if (priceValue is double) return priceValue;
      if (priceValue is int) return priceValue.toDouble();
      if (priceValue is String) {
        return double.tryParse(priceValue) ?? 0.0;
      }
      return 0.0;
    }

    // Get localized name and description if context is available
    String productName = '';
    String? productDescription;
    
    if (context != null) {
      productName = ProductsDataProvider.getLocalizedName(product, context);
      productDescription = ProductsDataProvider.getLocalizedDescription(product, context);
      if (productDescription.isEmpty) productDescription = null;
    } else {
      // Fallback: use English version if context not available
      if (product['name'] is Map) {
        productName = product['name']['en'] ?? 'Unknown Product';
      } else {
        productName = product['name'] ?? 'Unknown Product';
      }
      
      if (product['description'] is Map) {
        productDescription = product['description']['en'];
      } else {
        productDescription = product['description'];
      }
    }

    return CartItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      productId: product['id']?.toString() ?? (
        product['name'] is Map 
          ? product['name']['en'] ?? 'unknown'
          : product['name']?.toString() ?? 'unknown'
      ),
      name: productName,
      brand: product['brand'] ?? 'Unknown Brand',
      price: parsePrice(product['price']),
      image: product['image'] ?? '',
      size: product['size'],
      category: product['category'],
      quantity: quantity,
      description: productDescription,
      originalProduct: product, // Store original product data for localization
    );
  }

  // Convert to Map for storage/serialization
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productId': productId,
      'name': name,
      'brand': brand,
      'price': price,
      'image': image,
      'size': size,
      'category': category,
      'quantity': quantity,
      'description': description,
      'originalProduct': originalProduct,
    };
  }

  // Create CartItem from Map
  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['id']?.toString() ?? '',
      productId: map['productId'] ?? '',
      name: map['name'] ?? 'Unknown Product',
      brand: map['brand'] ?? 'Unknown Brand',
      price: (map['price'] ?? 0).toDouble(),
      image: map['image'] ?? '',
      size: map['size'],
      category: map['category'],
      quantity: map['quantity'] ?? 1,
      description: map['description'],
      originalProduct: map['originalProduct'],
    );
  }

  // Create a copy of CartItem with updated values
  CartItem copyWith({
    String? id,
    String? productId,
    String? name,
    String? brand,
    double? price,
    String? image,
    String? size,
    String? category,
    int? quantity,
    String? description,
    Map<String, dynamic>? originalProduct,
  }) {
    return CartItem(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      price: price ?? this.price,
      image: image ?? this.image,
      size: size ?? this.size,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      description: description ?? this.description,
      originalProduct: originalProduct ?? this.originalProduct,
    );
  }

  @override
  String toString() {
    return 'CartItem(id: $id, name: $name, quantity: $quantity, price: $price)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is CartItem &&
        other.id == id &&
        other.productId == productId;
  }

  @override
  int get hashCode {
    return id.hashCode ^ productId.hashCode;
  }
}
