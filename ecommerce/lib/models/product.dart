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
    return Product(
      id: map['id'].toString(),
      name: map['name'],
      price: map['price'] is int ? (map['price'] as int).toDouble() : map['price'],
      image: map['image'],
      brand: map['brand'],
      category: map['category'],
      description: map['description'],
      size: map['size'],
      rating: map['rating'] is int ? (map['rating'] as int).toDouble() : map['rating'],
      soldOut: map['soldOut'] ?? false,
    );
  }
}
