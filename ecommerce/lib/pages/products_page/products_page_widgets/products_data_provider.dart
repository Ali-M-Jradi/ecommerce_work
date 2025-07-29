import 'package:flutter/material.dart';

class ProductsDataProvider {
  static List<Map<String, dynamic>> getDemoProducts() {
    return [
      {
        'id': '5287002102122',
        'brand': 'Avène',
        'name': {
          'en': 'Thermal Spring Water Face Mist',
          'ar': 'رذاذ الوجه بالمياه الحرارية الطبيعية',
        },
        'category': 'face_care',
        'description': {
          'en':
              'A soothing and anti-irritating thermal spring water mist that provides instant relief and comfort for sensitive skin. Rich in minerals and silicates for optimal skin health.',
          'ar':
              'رذاذ مياه حرارية طبيعية مهدئ ومضاد للتهيج يوفر راحة فورية للبشرة الحساسة. غني بالمعادن والسيليكات لصحة البشرة المثلى.',
        },
        'size': '150ml',
        'price': '12.99',
        'rating': '4.5',
        'soldOut': false,
        'barcode': '5287002102122',
        'image':
            'assets/images/cosmetics-beauty-products-skincare-social-media-instagram-post-square-banner-template_611904-184.avif',
      },
      {
        'id': '2345678901234',
        'brand': 'La Roche-Posay',
        'name': {
          'en': 'Toleriane Double Repair Face Moisturizer with SPF 30',
          'id': 'eucerin-daily-protection-face-lotion-spf-30',
          'ar': 'مرطب الوجه المضاعف الإصلاح مع عامل حماية من الشمس 30',
        },
        'category': 'face_care',
        'description': {
          'en':
              'A daily moisturizer with broad-spectrum SPF 30 sunscreen that provides all-day hydration while protecting against UV rays. Formulated with ceramides and niacinamide for barrier repair.',
          'ar':
              'مرطب يومي مع واقي الشمس عريض الطيف بمعامل حماية 30 يوفر ترطيب طوال اليوم مع الحماية من الأشعة فوق البنفسجية. مكون بالسيراميد والنياسيناميد لإصلاح حاجز البشرة.',
        },
        'size': '75ml',
        'price': '19.99',
        'rating': '4.7',
        'soldOut': true,
        'barcode': '2345678901234',
        'image':
            'assets/images/cosmetics-beauty-products-skincare-social-media-instagram-post-square-banner-template_611904-184.avif',
      },
      {
        'id': '3456789012345',
        'brand': 'Vichy',
        'name': {
          'en': 'Mineral 89 Hyaluronic Acid Face Serum',
          'ar': 'سيروم الوجه بحمض الهيالورونيك المينرال 89',
        },
        'category': 'face_care',
        'description': {
          'en':
              'A powerful hyaluronic acid serum fortified with 89% Vichy volcanic water and natural origin hyaluronic acid to strengthen and plump skin for 24-hour hydration.',
          'ar':
              'سيروم قوي بحمض الهيالورونيك معزز بـ89% من المياه البركانية فيشي وحمض الهيالورونيك الطبيعي لتقوية ونفخ البشرة مع ترطيب 24 ساعة.',
        },
        'size': '30ml',
        'price': '29.99',
        'rating': '4.3',
        'soldOut': false,
        'barcode': '3456789012345',
        'image':
            'assets/images/cosmetics-beauty-products-skincare-social-media-instagram-post-square-banner-template_611904-184.avif',
      },
      {
        'id': 'bioderma-sensibio-h2o-micellar-cleansing-water',
        'brand': 'Eucerin', // Keep brand name in English
        'name': {
          'en': 'Daily Protection Face Lotion SPF 30',
          'ar': 'لوشن الوجه للحماية اليومية بعامل حماية 30',
        },
        'category': 'face_care',
        'description': {
          'en':
              'A lightweight, non-greasy daily moisturizer with broad-spectrum SPF 30. Provides 24-hour hydration while protecting against harmful UVA/UVB rays and environmental damage.',
          'ar':
              'مرطب يومي خفيف وغير دهني مع عامل حماية واسع الطيف 30. يوفر ترطيب لمدة 24 ساعة مع الحماية من أشعة UVA/UVB الضارة والأضرار البيئية.',
        },
        'size': '120ml',
        'price': '14.99',
        'rating': '4.2',
        'soldOut': false,
        'image':
            'assets/images/cosmetics-beauty-products-skincare-social-media-instagram-post-square-banner-template_611904-184.avif',
      },
      {
        'id': 'la-roche-posay-lipikar-balm-ap-plus-body-moisturizer',
        'brand': 'Avène', // Keep brand name in English
        'name': {
          'en': 'Gentle Milk Cleanser for Sensitive Skin',
          'ar': 'منظف الحليب اللطيف للبشرة الحساسة',
        },
        'category': 'face_care',
        'description': {
          'en':
              'A gentle, soap-free cleanser that removes makeup and impurities while respecting the skin\'s natural balance. Enriched with Avène thermal spring water for soothing benefits.',
          'ar':
              'منظف لطيف خالي من الصابون يزيل المكياج والشوائب مع احترام التوازن الطبيعي للبشرة. معزز بالمياه الحرارية أفين للفوائد المهدئة.',
        },
        'size': '200ml',
        'price': '16.99',
        'rating': '4.6',
        'soldOut': false,
        'image':
            'assets/images/cosmetics-beauty-products-skincare-social-media-instagram-post-square-banner-template_611904-184.avif',
      },
      {
        'id': 'eucerin-advanced-repair-hand-cream',
        'brand': 'Bioderma', // Keep brand name in English
        'name': {
          'en': 'Sensibio H2O Micellar Cleansing Water',
          'ar': 'ماء التنظيف المذيب سنسيبيو اتش 2 أو',
        },
        'category': 'face_care',
        'description': {
          'en':
              'The original micellar water that gently cleanses and removes makeup from face and eyes. Specifically formulated for sensitive skin with a biomimetic formulation that respects skin ecology.',
          'ar':
              'الماء المذيب الأصلي الذي ينظف بلطف ويزيل المكياج من الوجه والعينين. مصمم خصيصاً للبشرة الحساسة بتركيبة بيولوجية تحترم بيئة البشرة.',
        },
        'size': '250ml',
        'price': '13.99',
        'rating': '4.8',
        'soldOut': true,
        'image':
            'assets/images/cosmetics-beauty-products-skincare-social-media-instagram-post-square-banner-template_611904-184.avif',
      },
      // Add some Body Care products
      {
        'brand': 'La Roche-Posay', // Keep brand name in English
        'name': {
          'en': 'Lipikar Balm AP+ Body Moisturizer',
          'ar': 'بلسم الجسم المرطب ليبيكار اي بي بلس',
        },
        'category': 'body_care',
        'description': {
          'en':
              'An intensive moisturizing balm for very dry, irritated skin. Formulated with shea butter and thermal spring water to restore skin barrier.',
          'ar':
              'بلسم مرطب مكثف للبشرة الجافة جداً والمتهيجة. مصنوع بزبدة الشيا والمياه الحرارية لاستعادة حاجز البشرة.',
        },
        'size': '400ml',
        'price': '24.99',
        'rating': '4.6',
        'soldOut': false,
        'image':
            'assets/images/cosmetics-beauty-products-skincare-social-media-instagram-post-square-banner-template_611904-184.avif',
      },
      {
        'brand': 'Eucerin', // Keep brand name in English
        'name': {
          'en': 'Advanced Repair Hand Cream',
          'ar': 'كريم اليدين للإصلاح المتقدم',
        },
        'category': 'body_care',
        'description': {
          'en':
              'A fast-absorbing hand cream that provides immediate and long-lasting relief for very dry, cracked hands.',
          'ar':
              'كريم سريع الامتصاص لليدين يوفر راحة فورية وطويلة الأمد للأيدي الجافة جداً والمتشققة.',
        },
        'size': '75ml',
        'price': '8.99',
        'rating': '4.4',
        'soldOut': false,
        'image':
            'assets/images/cosmetics-beauty-products-skincare-social-media-instagram-post-square-banner-template_611904-184.avif',
      },
      // Add some Hair Care products
      {
        'brand': 'Vichy', // Keep brand name in English
        'name': {
          'en': 'Dercos Anti-Dandruff Shampoo',
          'ar': 'شامبو ديركوس المضاد للقشرة',
        },
        'category': 'hair_care',
        'description': {
          'en':
              'A gentle anti-dandruff shampoo that eliminates dandruff and soothes sensitive scalp with selenium DS.',
          'ar':
              'شامبو لطيف مضاد للقشرة يقضي على القشرة ويهدئ فروة الرأس الحساسة بالسيلينيوم DS.',
        },
        'size': '300ml',
        'price': '18.99',
        'rating': '4.3',
        'soldOut': false,
        'image':
            'assets/images/cosmetics-beauty-products-skincare-social-media-instagram-post-square-banner-template_611904-184.avif',
      },
    ];
  }

  // Helper method to get localized product name
  static String getLocalizedName(
    Map<String, dynamic> product,
    BuildContext context,
  ) {
    final languageCode = Localizations.localeOf(context).languageCode;
    if (product['name'] is Map) {
      return product['name'][languageCode] ??
          product['name']['en'] ??
          'Unknown Product';
    }
    return product['name'] ?? 'Unknown Product';
  }

  // Helper method to get localized product description
  static String getLocalizedDescription(
    Map<String, dynamic> product,
    BuildContext context,
  ) {
    final languageCode = Localizations.localeOf(context).languageCode;
    if (product['description'] is Map) {
      return product['description'][languageCode] ??
          product['description']['en'] ??
          '';
    }
    return product['description'] ?? '';
  }

  static List<Map<String, dynamic>> getSortedProducts(
    String sortBy, {
    BuildContext? context,
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
      products = products
          .where((product) => product['category'] == category)
          .toList();
    }

    if (brand != null && brand.isNotEmpty) {
      products = products
          .where((product) => product['brand'] == brand)
          .toList();
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
      products = products
          .where((product) => !(product['soldOut'] ?? false))
          .toList();
    }

    switch (sortBy) {
      case 'A to Z':
        products.sort((a, b) {
          String nameA = context != null
              ? getLocalizedName(a, context!)
              : (a['name']['en'] ?? a['name'] ?? 'Unknown Product').toString();
          String nameB = context != null
              ? getLocalizedName(b, context!)
              : (b['name']['en'] ?? b['name'] ?? 'Unknown Product').toString();
          return nameA.toLowerCase().compareTo(nameB.toLowerCase());
        });
        break;
      case 'Z to A':
        products.sort((a, b) {
          String nameA = context != null
              ? getLocalizedName(a, context!)
              : (a['name']['en'] ?? a['name'] ?? 'Unknown Product').toString();
          String nameB = context != null
              ? getLocalizedName(b, context!)
              : (b['name']['en'] ?? b['name'] ?? 'Unknown Product').toString();
          return nameB.toLowerCase().compareTo(nameA.toLowerCase());
        });
        break;
      case 'Price Low':
        products.sort(
          (a, b) => double.parse(
            a['price'].toString(),
          ).compareTo(double.parse(b['price'].toString())),
        );
        break;
      case 'Price High':
        products.sort(
          (a, b) => double.parse(
            b['price'].toString(),
          ).compareTo(double.parse(a['price'].toString())),
        );
        break;
      default:
        // Default to A to Z if somehow an invalid sort option is selected
        products.sort(
          (a, b) => getLocalizedName(
            a,
            context!,
          ).toLowerCase().compareTo(getLocalizedName(b, context!).toLowerCase()),
        );
    }

    return products;
  }

  // Helper method for search filtering - isolated for clarity
  static List<Map<String, dynamic>> _filterBySearch(
    List<Map<String, dynamic>> products,
    String query,
  ) {
    List<Map<String, dynamic>> results = [];

    for (var product in products) {
      // Search in both English and Arabic product names
      String nameEn = '';
      String nameAr = '';

      if (product['name'] is Map) {
        nameEn = (product['name']['en'] ?? '').toString().toLowerCase();
        nameAr = (product['name']['ar'] ?? '').toString().toLowerCase();
      } else {
        nameEn = (product['name'] ?? '').toString().toLowerCase();
      }

      // Check if the query appears in either English or Arabic name
      if (nameEn.contains(query) || nameAr.contains(query)) {
        results.add(product);
      }
    }

    return results;
  }

  static List<Map<String, dynamic>> getProductsByCategory(String category) {
    return getDemoProducts()
        .where((product) => product['category'] == category)
        .toList();
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
