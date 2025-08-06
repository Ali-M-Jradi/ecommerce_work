import 'package:flutter/material.dart';

class ProductsDataProvider {
  // Map category IDs to relevant keywords for broader matching
  static const Map<String, List<String>> categoryKeywords = {
    'face_care': [
      'face', 'cleanser', 'moisturizer', 'serum', 'mask', 'cream', 'toner', 'mist', 'spf', 'sunscreen', 'acne', 'anti-aging', 'eye', 'lips', 'peel', 'scrub', 'makeup remover', 'micellar', 'hydration', 'sensitive', 'balm', 'milk', 'exfoliator', 'spot', 'whitening', 'brightening', 'vitamin c', 'retinol', 'collagen', 'wrinkle', 'pore', 'essence', 'ampoule', 'patch', 'sheet', 'sunblock', 'sun', 'uv', 'day cream', 'night cream', 'gel', 'foam', 'clay', 'mud', 'facial', 'anti-wrinkle', 'anti-spot', 'blemish', 'soothing', 'repair', 'recovery', 'rejuvenating', 'rejuvenation', 'anti-redness', 'anti-pollution', 'makeup', 'remover', 'water', 'thermal', 'spring', 'thermal water', 'thermal spring', 'thermal mist', 'thermal spray', 'thermal face', 'thermal cleanser', 'thermal cream', 'thermal mask', 'thermal serum', 'thermal toner', 'thermal moisturizer', 'thermal balm', 'thermal milk', 'thermal exfoliator', 'thermal spot', 'thermal whitening', 'thermal brightening', 'thermal vitamin c', 'thermal retinol', 'thermal collagen', 'thermal wrinkle', 'thermal pore', 'thermal essence', 'thermal ampoule', 'thermal patch', 'thermal sheet', 'thermal sunblock', 'thermal sun', 'thermal uv', 'thermal day cream', 'thermal night cream', 'thermal gel', 'thermal foam', 'thermal clay', 'thermal mud', 'thermal facial', 'thermal anti-wrinkle', 'thermal anti-spot', 'thermal blemish', 'thermal soothing', 'thermal repair', 'thermal recovery', 'thermal rejuvenating', 'thermal rejuvenation', 'thermal anti-redness', 'thermal anti-pollution'
    ],
    'body_care': [
      'body', 'lotion', 'butter', 'scrub', 'wash', 'shower', 'deodorant', 'hand', 'foot', 'soap', 'oil', 'cream', 'gel', 'moisturizer', 'balm', 'milk', 'exfoliator', 'sensitive', 'hydration', 'repair', 'soothing', 'recovery', 'rejuvenating', 'rejuvenation', 'anti-redness', 'anti-pollution', 'spf', 'sunscreen', 'sunblock', 'sun', 'uv', 'day cream', 'night cream', 'anti-aging', 'anti-wrinkle', 'anti-spot', 'blemish', 'whitening', 'brightening', 'vitamin c', 'retinol', 'collagen', 'wrinkle', 'pore', 'essence', 'ampoule', 'patch', 'sheet', 'thermal', 'thermal water', 'thermal spring', 'thermal mist', 'thermal spray', 'thermal body', 'thermal cleanser', 'thermal cream', 'thermal mask', 'thermal serum', 'thermal toner', 'thermal moisturizer', 'thermal balm', 'thermal milk', 'thermal exfoliator', 'thermal spot', 'thermal whitening', 'thermal brightening', 'thermal vitamin c', 'thermal retinol', 'thermal collagen', 'thermal wrinkle', 'thermal pore', 'thermal essence', 'thermal ampoule', 'thermal patch', 'thermal sheet', 'thermal sunblock', 'thermal sun', 'thermal uv', 'thermal day cream', 'thermal night cream', 'thermal gel', 'thermal foam', 'thermal clay', 'thermal mud', 'thermal anti-wrinkle', 'thermal anti-spot', 'thermal blemish', 'thermal soothing', 'thermal repair', 'thermal recovery', 'thermal rejuvenating', 'thermal rejuvenation', 'thermal anti-redness', 'thermal anti-pollution'
    ],
    'hair_care': [
      'hair', 'shampoo', 'conditioner', 'scalp', 'serum', 'oil', 'mask', 'spray', 'treatment', 'styling', 'leave-in', 'anti-dandruff', 'volume', 'curl', 'moisturizer', 'balm', 'milk', 'exfoliator', 'sensitive', 'hydration', 'repair', 'soothing', 'recovery', 'rejuvenating', 'rejuvenation', 'anti-redness', 'anti-pollution', 'spf', 'sunscreen', 'sunblock', 'sun', 'uv', 'day cream', 'night cream', 'anti-aging', 'anti-wrinkle', 'anti-spot', 'blemish', 'whitening', 'brightening', 'vitamin c', 'retinol', 'collagen', 'wrinkle', 'pore', 'essence', 'ampoule', 'patch', 'sheet', 'thermal', 'thermal water', 'thermal spring', 'thermal mist', 'thermal spray', 'thermal hair', 'thermal cleanser', 'thermal cream', 'thermal mask', 'thermal serum', 'thermal toner', 'thermal moisturizer', 'thermal balm', 'thermal milk', 'thermal exfoliator', 'thermal spot', 'thermal whitening', 'thermal brightening', 'thermal vitamin c', 'thermal retinol', 'thermal collagen', 'thermal wrinkle', 'thermal pore', 'thermal essence', 'thermal ampoule', 'thermal patch', 'thermal sheet', 'thermal sunblock', 'thermal sun', 'thermal uv', 'thermal day cream', 'thermal night cream', 'thermal gel', 'thermal foam', 'thermal clay', 'thermal mud', 'thermal anti-wrinkle', 'thermal anti-spot', 'thermal blemish', 'thermal soothing', 'thermal repair', 'thermal recovery', 'thermal rejuvenating', 'thermal rejuvenation', 'thermal anti-redness', 'thermal anti-pollution'
    ],
    'fragrance': [
      'fragrance', 'perfume', 'eau de parfum', 'eau de toilette', 'cologne', 'body spray', 'mist', 'deodorant', 'scent', 'aroma', 'parfum', 'aftershave', 'body mist', 'body fragrance', 'body cologne', 'body perfume', 'body scent', 'body aroma', 'body aftershave', 'thermal', 'thermal fragrance', 'thermal perfume', 'thermal eau de parfum', 'thermal eau de toilette', 'thermal cologne', 'thermal body spray', 'thermal mist', 'thermal deodorant', 'thermal scent', 'thermal aroma', 'thermal parfum', 'thermal aftershave', 'thermal body mist', 'thermal body fragrance', 'thermal body cologne', 'thermal body perfume', 'thermal body scent', 'thermal body aroma', 'thermal body aftershave'
    ],
    'makeup': [
      'makeup', 'foundation', 'concealer', 'powder', 'blush', 'bronzer', 'highlighter', 'contour', 'primer', 'setting spray', 'setting powder', 'eyeshadow', 'mascara', 'eyeliner', 'brow', 'lipstick', 'lip gloss', 'lip liner', 'lip balm', 'tint', 'palette', 'face', 'eye', 'lip', 'cheek', 'brow', 'lash', 'base', 'complexion', 'color', 'cosmetic', 'cosmetics', 'thermal', 'thermal makeup', 'thermal foundation', 'thermal concealer', 'thermal powder', 'thermal blush', 'thermal bronzer', 'thermal highlighter', 'thermal contour', 'thermal primer', 'thermal setting spray', 'thermal setting powder', 'thermal eyeshadow', 'thermal mascara', 'thermal eyeliner', 'thermal brow', 'thermal lipstick', 'thermal lip gloss', 'thermal lip liner', 'thermal lip balm', 'thermal tint', 'thermal palette', 'thermal face', 'thermal eye', 'thermal lip', 'thermal cheek', 'thermal brow', 'thermal lash', 'thermal base', 'thermal complexion', 'thermal color', 'thermal cosmetic', 'thermal cosmetics'
    ],
    'baby_care': [
      'baby', 'infant', 'toddler', 'child', 'kids', 'children', 'baby lotion', 'baby oil', 'baby cream', 'baby shampoo', 'baby wash', 'baby soap', 'baby powder', 'baby wipes', 'baby balm', 'baby moisturizer', 'baby sunscreen', 'baby spf', 'baby sunblock', 'baby sun', 'baby uv', 'baby day cream', 'baby night cream', 'baby anti-aging', 'baby anti-wrinkle', 'baby anti-spot', 'baby blemish', 'baby whitening', 'baby brightening', 'baby vitamin c', 'baby retinol', 'baby collagen', 'baby wrinkle', 'baby pore', 'baby essence', 'baby ampoule', 'baby patch', 'baby sheet', 'baby thermal', 'baby thermal water', 'baby thermal spring', 'baby thermal mist', 'baby thermal spray', 'baby thermal cleanser', 'baby thermal cream', 'baby thermal mask', 'baby thermal serum', 'baby thermal toner', 'baby thermal moisturizer', 'baby thermal balm', 'baby thermal milk', 'baby thermal exfoliator', 'baby thermal spot', 'baby thermal whitening', 'baby thermal brightening', 'baby thermal vitamin c', 'baby thermal retinol', 'baby thermal collagen', 'baby thermal wrinkle', 'baby thermal pore', 'baby thermal essence', 'baby thermal ampoule', 'baby thermal patch', 'baby thermal sheet', 'baby thermal sunblock', 'baby thermal sun', 'baby thermal uv', 'baby thermal day cream', 'baby thermal night cream', 'baby thermal gel', 'baby thermal foam', 'baby thermal clay', 'baby thermal mud', 'baby thermal anti-wrinkle', 'baby thermal anti-spot', 'baby thermal blemish', 'baby thermal soothing', 'baby thermal repair', 'baby thermal recovery', 'baby thermal rejuvenating', 'baby thermal rejuvenation', 'baby thermal anti-redness', 'baby thermal anti-pollution'
    ],
    // Add more categories and keywords as needed
  };
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
      final categoryLower = category.toLowerCase();
      final keywords = categoryKeywords[categoryLower] ?? [categoryLower];
      products = products.where((product) {
        // Direct match on category field
        if ((product['category']?.toString().toLowerCase() ?? '') == categoryLower) return true;
        // Check if product fields contain any of the keywords
        final name = product['name'] is String
            ? product['name']
            : (product['name']?['en'] ?? '');
        final description = product['description'] is String
            ? product['description']
            : (product['description']?['en'] ?? '');
        final brand = product['brand']?.toString() ?? '';
        final allFields = ('$name $description $brand').toLowerCase();
        for (final keyword in keywords) {
          if (allFields.contains(keyword.toLowerCase())) return true;
        }
        return false;
      }).toList();
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
              ? getLocalizedName(a, context)
              : (a['name']['en'] ?? a['name'] ?? 'Unknown Product').toString();
          String nameB = context != null
              ? getLocalizedName(b, context)
              : (b['name']['en'] ?? b['name'] ?? 'Unknown Product').toString();
          return nameA.toLowerCase().compareTo(nameB.toLowerCase());
        });
        break;
      case 'Z to A':
        products.sort((a, b) {
          String nameA = context != null
              ? getLocalizedName(a, context)
              : (a['name']['en'] ?? a['name'] ?? 'Unknown Product').toString();
          String nameB = context != null
              ? getLocalizedName(b, context)
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
          ).toLowerCase().compareTo(getLocalizedName(b, context).toLowerCase()),
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
    final categoryLower = category.toLowerCase();
    final keywords = categoryKeywords[categoryLower] ?? [categoryLower];
    return getDemoProducts()
        .where((product) {
          if ((product['category']?.toString().toLowerCase() ?? '') == categoryLower) return true;
          final name = product['name'] is String
              ? product['name']
              : (product['name']?['en'] ?? '');
          final description = product['description'] is String
              ? product['description']
              : (product['description']?['en'] ?? '');
          final brand = product['brand']?.toString() ?? '';
          final allFields = ('$name $description $brand').toLowerCase();
          for (final keyword in keywords) {
            if (allFields.contains(keyword.toLowerCase())) return true;
          }
          return false;
        })
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
