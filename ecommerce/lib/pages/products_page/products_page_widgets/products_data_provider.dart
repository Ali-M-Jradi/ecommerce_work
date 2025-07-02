class ProductsDataProvider {
  static List<Map<String, dynamic>> getDemoProducts() {
    return [
      {
        'brand': 'Avène',
        'name': 'Thermal Spring Water Face Mist',
        'category': 'face_care',
        'description': 'A soothing and anti-irritating thermal spring water mist that provides instant relief and comfort for sensitive skin. Rich in minerals and silicates for optimal skin health.',
        'size': '150ml',
        'price': '12.99',
        'rating': '4.5',
        'soldOut': false,
        'image':
            'assets/images/cosmetics-beauty-products-skincare-social-media-instagram-post-square-banner-template_611904-184.avif',
      },
      {
        'brand': 'La Roche-Posay',
        'name': 'Toleriane Double Repair Face Moisturizer with SPF 30',
        'category': 'face_care',
        'description': 'A daily moisturizer with broad-spectrum SPF 30 sunscreen that provides all-day hydration while protecting against UV rays. Formulated with ceramides and niacinamide for barrier repair.',
        'size': '75ml',
        'price': '19.99',
        'rating': '4.7',
        'soldOut': true,
        'image':
            'assets/images/cosmetics-beauty-products-skincare-social-media-instagram-post-square-banner-template_611904-184.avif',
      },
      {
        'brand': 'Vichy',
        'name': 'Mineral 89 Hyaluronic Acid Face Serum',
        'category': 'face_care',
        'description': 'A powerful hyaluronic acid serum fortified with 89% Vichy volcanic water and natural origin hyaluronic acid to strengthen and plump skin for 24-hour hydration.',
        'size': '30ml',
        'price': '29.99',
        'rating': '4.3',
        'soldOut': false,
        'image':
            'assets/images/cosmetics-beauty-products-skincare-social-media-instagram-post-square-banner-template_611904-184.avif',
      },
      {
        'brand': 'Eucerin',
        'name': 'Daily Protection Face Lotion SPF 30',
        'category': 'face_care',
        'description': 'A lightweight, non-greasy daily moisturizer with broad-spectrum SPF 30. Provides 24-hour hydration while protecting against harmful UVA/UVB rays and environmental damage.',
        'size': '120ml',
        'price': '14.99',
        'rating': '4.2',
        'soldOut': false,
        'image':
            'assets/images/cosmetics-beauty-products-skincare-social-media-instagram-post-square-banner-template_611904-184.avif',
      },
      {
        'brand': 'Avène',
        'name': 'Gentle Milk Cleanser for Sensitive Skin',
        'category': 'face_care',
        'description': 'A gentle, soap-free cleanser that removes makeup and impurities while respecting the skin\'s natural balance. Enriched with Avène thermal spring water for soothing benefits.',
        'size': '200ml',
        'price': '16.99',
        'rating': '4.6',
        'soldOut': false,
        'image':
            'assets/images/cosmetics-beauty-products-skincare-social-media-instagram-post-square-banner-template_611904-184.avif',
      },
      {
        'brand': 'Bioderma',
        'name': 'Sensibio H2O Micellar Cleansing Water',
        'category': 'face_care',
        'description': 'The original micellar water that gently cleanses and removes makeup from face and eyes. Specifically formulated for sensitive skin with a biomimetic formulation that respects skin ecology.',
        'size': '250ml',
        'price': '13.99',
        'rating': '4.8',
        'soldOut': true,
        'image':
            'assets/images/cosmetics-beauty-products-skincare-social-media-instagram-post-square-banner-template_611904-184.avif',
      },
      // Add some Body Care products
      {
        'brand': 'La Roche-Posay',
        'name': 'Lipikar Balm AP+ Body Moisturizer',
        'category': 'body_care',
        'description': 'An intensive moisturizing balm for very dry, irritated skin. Formulated with shea butter and thermal spring water to restore skin barrier.',
        'size': '400ml',
        'price': '24.99',
        'rating': '4.6',
        'soldOut': false,
        'image':
            'assets/images/cosmetics-beauty-products-skincare-social-media-instagram-post-square-banner-template_611904-184.avif',
      },
      {
        'brand': 'Eucerin',
        'name': 'Advanced Repair Hand Cream',
        'category': 'body_care',
        'description': 'A fast-absorbing hand cream that provides immediate and long-lasting relief for very dry, cracked hands.',
        'size': '75ml',
        'price': '8.99',
        'rating': '4.4',
        'soldOut': false,
        'image':
            'assets/images/cosmetics-beauty-products-skincare-social-media-instagram-post-square-banner-template_611904-184.avif',
      },
      // Add some Hair Care products
      {
        'brand': 'Vichy',
        'name': 'Dercos Anti-Dandruff Shampoo',
        'category': 'hair_care',
        'description': 'A gentle anti-dandruff shampoo that eliminates dandruff and soothes sensitive scalp with selenium DS.',
        'size': '300ml',
        'price': '18.99',
        'rating': '4.3',
        'soldOut': false,
        'image':
            'assets/images/cosmetics-beauty-products-skincare-social-media-instagram-post-square-banner-template_611904-184.avif',
      },
    ];
  }

  static List<Map<String, dynamic>> getSortedProducts(
    String sortBy, {
    String? category,
    String? searchQuery,
    String? brand,
    double? minPrice,
    double? maxPrice,
    double? minRating,
    bool showOnlyInStock = false,
  }) {
    // Start with all products
    List<Map<String, dynamic>> products = List.from(getDemoProducts());
    
    // Apply search filter FIRST if there's a search query
    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      String query = searchQuery.trim().toLowerCase();
      products = _filterBySearch(products, query);
    }
    
    // Then apply other filters
    if (category != null && category.isNotEmpty && category != 'all') {
      products = products.where((product) => product['category'] == category).toList();
    }
    
    if (brand != null && brand.isNotEmpty) {
      products = products.where((product) => product['brand'] == brand).toList();
    }
    
    if (minPrice != null) {
      products = products.where((product) {
        double price = double.tryParse(product['price'].toString()) ?? 0;
        return price >= minPrice;
      }).toList();
    }
    
    if (maxPrice != null) {
      products = products.where((product) {
        double price = double.tryParse(product['price'].toString()) ?? 0;
        return price <= maxPrice;
      }).toList();
    }
    
    if (minRating != null && minRating > 0) {
      products = products.where((product) {
        double rating = double.tryParse(product['rating'].toString()) ?? 0;
        return rating >= minRating;
      }).toList();
    }
    
    if (showOnlyInStock) {
      products = products.where((product) => !(product['soldOut'] ?? false)).toList();
    }
    
    switch (sortBy) {
      case 'A to Z':
        products.sort((a, b) => a['name'].toString().toLowerCase().compareTo(b['name'].toString().toLowerCase()));
        break;
      case 'Z to A':
        products.sort((a, b) => b['name'].toString().toLowerCase().compareTo(a['name'].toString().toLowerCase()));
        break;
      case 'Price Low':
        products.sort((a, b) => double.parse(a['price'].toString()).compareTo(double.parse(b['price'].toString())));
        break;
      case 'Price High':
        products.sort((a, b) => double.parse(b['price'].toString()).compareTo(double.parse(a['price'].toString())));
        break;
      default:
        // Default to A to Z if somehow an invalid sort option is selected
        products.sort((a, b) => a['name'].toString().toLowerCase().compareTo(b['name'].toString().toLowerCase()));
    }
    
    return products;
  }

  // Helper method for search filtering - isolated for clarity
  static List<Map<String, dynamic>> _filterBySearch(List<Map<String, dynamic>> products, String query) {
    List<Map<String, dynamic>> results = [];
    
    for (var product in products) {
      // Only search in the product name (title) for more precise results
      String name = (product['name'] ?? '').toString().toLowerCase();
      
      // Check if the query appears in the product name
      if (name.contains(query)) {
        results.add(product);
      }
    }
    
    return results;
  }

  static List<Map<String, dynamic>> getProductsByCategory(String category) {
    return getDemoProducts().where((product) => product['category'] == category).toList();
  }

  static List<String> getAllBrands() {
    return getDemoProducts()
        .map((product) => product['brand'].toString())
        .toSet()
        .toList()
        ..sort();
  }

  static List<String> getAllCategories() {
    return getDemoProducts()
        .map((product) => product['category'].toString())
        .toSet()
        .toList()
        ..sort();
  }
}
