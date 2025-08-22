class Product {
  final String id;
  final String name;
  final double price;
  final double? originalPrice; // For showing discounts
  final String image;
  final List<String> images; // Multiple product images
  final String brand;
  final String category;
  final String description;
  final String size;
  final double rating;
  final int reviewCount; // Number of reviews
  final bool soldOut;
  final int stock; // Available quantity
  final List<String> features; // Product features/highlights
  final Map<String, String> specifications; // Technical specs
  final List<String> colors; // Available colors
  final List<String> sizes; // Available sizes
  final String sku; // Product SKU
  final DateTime? dateAdded;
  final bool isNew;
  final bool isFeatured;
  final bool isBestSeller;

  Product({
    required this.id,
    required this.name,
    required this.price,
    this.originalPrice,
    required this.image,
    this.images = const [],
    required this.brand,
    required this.category,
    required this.description,
    required this.size,
    required this.rating,
    this.reviewCount = 0,
    required this.soldOut,
    this.stock = 0,
    this.features = const [],
    this.specifications = const {},
    this.colors = const [],
    this.sizes = const [],
    this.sku = '',
    this.dateAdded,
    this.isNew = false,
    this.isFeatured = false,
    this.isBestSeller = false,
  });

  // Calculate discount percentage
  double get discountPercentage {
    if (originalPrice != null && originalPrice! > price) {
      return ((originalPrice! - price) / originalPrice!) * 100;
    }
    return 0.0;
  }

  // Check if product has discount
  bool get hasDiscount => discountPercentage > 0;

  // Get stock status
  String get stockStatus {
    if (soldOut) return 'Out of Stock';
    if (stock <= 0) return 'Unavailable';
    if (stock < 5) return 'Low Stock';
    return 'In Stock';
  }

  // Convert a Product into a Map. The keys must correspond to the names of the columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'originalPrice': originalPrice,
      'image': image,
      'images': images,
      'brand': brand,
      'category': category,
      'description': description,
      'size': size,
      'rating': rating,
      'reviewCount': reviewCount,
      'soldOut': soldOut,
      'stock': stock,
      'features': features,
      'specifications': specifications,
      'colors': colors,
      'sizes': sizes,
      'sku': sku,
      'dateAdded': dateAdded?.toIso8601String(),
      'isNew': isNew,
      'isFeatured': isFeatured,
      'isBestSeller': isBestSeller,
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

    // Helper function to extract list of strings
    List<String> getStringList(dynamic value) {
      if (value is List) {
        return value.map((item) => item.toString()).toList();
      } else if (value is String && value.isNotEmpty) {
        return value.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
      }
      return [];
    }

    // Helper function to extract specifications map
    Map<String, String> getSpecifications(dynamic value) {
      if (value is Map) {
        return value.map((key, val) => MapEntry(key.toString(), val.toString()));
      }
      return {};
    }

    return Product(
      id: map['id']?.toString() ?? '',
      name: getLocalizedString(map['name']),
      price: map['price'] is int ? (map['price'] as int).toDouble() : 
             double.tryParse(map['price']?.toString() ?? '0') ?? 0.0,
      originalPrice: map['originalPrice'] != null ? 
                     (map['originalPrice'] is int ? (map['originalPrice'] as int).toDouble() : 
                      double.tryParse(map['originalPrice'].toString())) : null,
      image: map['image']?.toString() ?? '',
      images: getStringList(map['images']),
      brand: map['brand']?.toString() ?? '',
      category: map['category']?.toString() ?? '',
      description: getLocalizedString(map['description']),
      size: map['size']?.toString() ?? '',
      rating: map['rating'] is int ? (map['rating'] as int).toDouble() : 
              double.tryParse(map['rating']?.toString() ?? '0') ?? 0.0,
      reviewCount: map['reviewCount'] is int ? map['reviewCount'] : 
                   int.tryParse(map['reviewCount']?.toString() ?? '0') ?? 0,
      soldOut: map['soldOut'] == true || map['soldOut'] == 'true',
      stock: map['stock'] is int ? map['stock'] : 
             int.tryParse(map['stock']?.toString() ?? '0') ?? 0,
      features: getStringList(map['features']),
      specifications: getSpecifications(map['specifications']),
      colors: getStringList(map['colors']),
      sizes: getStringList(map['sizes']),
      sku: map['sku']?.toString() ?? '',
      dateAdded: map['dateAdded'] != null ? DateTime.tryParse(map['dateAdded'].toString()) : null,
      isNew: map['isNew'] == true || map['isNew'] == 'true',
      isFeatured: map['isFeatured'] == true || map['isFeatured'] == 'true',
      isBestSeller: map['isBestSeller'] == true || map['isBestSeller'] == 'true',
    );
  }
}
