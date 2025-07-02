// Callback type definitions
typedef ProductTapCallback = void Function(Map<String, dynamic> product);
typedef SortChangedCallback = void Function(String? sortBy);
typedef ViewModeChangedCallback = void Function(bool isGridView);
typedef StateChangedCallback = void Function();

// Product model type (using Map for now, can be replaced with a proper Product class)
typedef ProductMap = Map<String, dynamic>;

// Sort option enum
enum SortOption {
  aToZ('A to Z'),
  zToA('Z to A'),
  priceLowToHigh('Price Low to High'),
  priceHighToLow('Price High to Low');

  const SortOption(this.displayName);
  final String displayName;

  static SortOption fromString(String value) {
    return SortOption.values.firstWhere(
      (option) => option.displayName == value,
      orElse: () => SortOption.aToZ,
    );
  }
}

// View mode enum
enum ViewMode {
  grid,
  list;

  bool get isGrid => this == ViewMode.grid;
  bool get isList => this == ViewMode.list;
}

/// Product model class for better type safety
class Product {
  final String name;
  final String description;
  final double price;
  final String image;
  final String category;
  final double rating;
  final List<String> benefits;
  final String skinType;
  final String usage;

  const Product({
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.category,
    this.rating = 0.0,
    this.benefits = const [],
    this.skinType = '',
    this.usage = '',
  });

  // Convert from Map (for backward compatibility)
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      image: map['image'] ?? '',
      category: map['category'] ?? '',
      rating: (map['rating'] ?? 0.0).toDouble(),
      benefits: List<String>.from(map['benefits'] ?? []),
      skinType: map['skinType'] ?? '',
      usage: map['usage'] ?? '',
    );
  }

  // Convert to Map (for backward compatibility)
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'image': image,
      'category': category,
      'rating': rating,
      'benefits': benefits,
      'skinType': skinType,
      'usage': usage,
    };
  }
}
