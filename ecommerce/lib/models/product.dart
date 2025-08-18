class Product {
  final String id;
  final String name;
  final double price;
  final String image;
  final String brand;
  final String category;
  final String description;
  final String size;
  final double rating;
  final bool soldOut;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.brand,
    required this.category,
    required this.description,
    required this.size,
    required this.rating,
    required this.soldOut,
  });

  // Convert a Product into a Map. The keys must correspond to the names of the columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'image': image,
      'brand': brand,
      'category': category,
      'description': description,
      'size': size,
      'rating': rating,
      'soldOut': soldOut,
    };
  }

  // Extract a Product object from a Map.
  factory Product.fromMap(Map<String, dynamic> map) {
    // Helper function to extract localized string
    String getLocalizedString(dynamic value, [String defaultLang = 'en']) {
      if (value is String) {
        return value;
      } else if (value is Map) {
        // Try to get English first, then Arabic, then any available language
        return value[defaultLang] ?? 
               value['ar'] ?? 
               value.values.first?.toString() ?? 
               '';
      }
      return value?.toString() ?? '';
    }

    return Product(
      id: map['id']?.toString() ?? '',
      name: getLocalizedString(map['name']),
      price: map['price'] is int ? (map['price'] as int).toDouble() : 
             double.tryParse(map['price']?.toString() ?? '0') ?? 0.0,
      image: map['image']?.toString() ?? '',
      brand: map['brand']?.toString() ?? '',
      category: map['category']?.toString() ?? '',
      description: getLocalizedString(map['description']),
      size: map['size']?.toString() ?? '',
      rating: map['rating'] is int ? (map['rating'] as int).toDouble() : 
              double.tryParse(map['rating']?.toString() ?? '0') ?? 0.0,
      soldOut: map['soldOut'] ?? false,
    );
  }
}
