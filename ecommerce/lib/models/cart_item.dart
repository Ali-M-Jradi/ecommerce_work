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
  });

  // Calculate total price for this cart item
  double get totalPrice => price * quantity;

  // Create CartItem from product data
  factory CartItem.fromProduct(Map<String, dynamic> product, {int quantity = 1}) {
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

    return CartItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      productId: product['id']?.toString() ?? product['name'] ?? '',
      name: product['name'] ?? 'Unknown Product',
      brand: product['brand'] ?? 'Unknown Brand',
      price: parsePrice(product['price']),
      image: product['image'] ?? '',
      size: product['size'],
      category: product['category'],
      quantity: quantity,
      description: product['description'],
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
    };
  }

  // Create CartItem from Map
  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['id'] ?? '',
      productId: map['productId'] ?? '',
      name: map['name'] ?? 'Unknown Product',
      brand: map['brand'] ?? 'Unknown Brand',
      price: (map['price'] ?? 0).toDouble(),
      image: map['image'] ?? '',
      size: map['size'],
      category: map['category'],
      quantity: map['quantity'] ?? 1,
      description: map['description'],
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
