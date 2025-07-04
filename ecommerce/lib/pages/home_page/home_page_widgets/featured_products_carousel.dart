import 'package:flutter/material.dart';
import '../../products_page/products_page_widgets/product_details_dialog_widget.dart';
import '../../products_page/products_page_widgets/products_data_provider.dart';
import 'package:ecommerce/localization/app_localizations_helper.dart';

class FeaturedProductsCarousel extends StatefulWidget {
  const FeaturedProductsCarousel({super.key});

  @override
  State<FeaturedProductsCarousel> createState() => _FeaturedProductsCarouselState();
}

class _FeaturedProductsCarouselState extends State<FeaturedProductsCarousel> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  // Featured products data based on your website
  final List<Map<String, dynamic>> featuredProducts = [
    {
      'name': {
        'en': 'EFFACLAR K (+) Oily Skin Renovating Care',
        'ar': 'كريم إيفاكلار كي (+) المجدد للبشرة الدهنية'
      },
      'brand': 'La Roche Posay', // Keep brand in English
      'price': '0',
      'originalPrice': null,
      'image': 'assets/images/WhatsApp Image 2025-07-01 at 12.15.01_267ad068.jpg',
      'rating': '0',
      'description': {
        'en': 'Anti-oxidation anti-sebum renovating care for oily skin',
        'ar': 'كريم مجدد مضاد للأكسدة ومضاد للزهم للبشرة الدهنية'
      },
      'soldOut': true,
      'fcfa': '0 FCFA',
      'size': null,
      'category': 'face_care',
    },
    {
      'name': {
        'en': 'Pure Vitamin C Light Anti-Wrinkle Care',
        'ar': 'كريم فيتامين سي الخفيف المضاد للتجاعيد'
      },
      'brand': 'La Roche Posay', // Keep brand in English
      'price': '0',
      'originalPrice': null,
      'image': 'assets/images/WhatsApp Image 2025-07-01 at 12.15.01_33c0f20c.jpg',
      'rating': '4.2',
      'description': {
        'en': 'Radiance care for normal to combination skin, 40ml tube',
        'ar': 'كريم إشراق للبشرة العادية إلى المختلطة، أنبوب 40 مل'
      },
      'soldOut': true,
      'fcfa': '0 FCFA',
      'size': '40ml',
      'category': 'face_care',
    },
    {
      'name': {
        'en': 'EFFACLAR H Compensating Purifying Cream',
        'ar': 'كريم إيفاكلار إتش المنظف التعويضي'
      },
      'brand': 'La Roche Posay', // Keep brand in English
      'price': '0',
      'originalPrice': null,
      'image': 'assets/images/WhatsApp Image 2025-07-01 at 12.15.02_1f1fc92c.jpg',
      'rating': '4.1',
      'description': {
        'en': 'Purifying compensating washing cream for sensitive skin',
        'ar': 'كريم غسول منظف تعويضي للبشرة الحساسة'
      },
      'soldOut': true,
      'fcfa': '0 FCFA',
      'size': null,
      'category': 'face_care',
    },
    {
      'name': {
        'en': 'ANTHELIOS UV MUNE 400 Invisible Tinted Fluid',
        'ar': 'أنثيليوس يو في مون 400 سائل ملون غير مرئي'
      },
      'brand': 'La Roche Posay', // Keep brand in English
      'price': '0',
      'originalPrice': null,
      'image': 'assets/images/WhatsApp Image 2025-07-01 at 12.15.02_21a37162.jpg',
      'rating': '4.5',
      'description': {
        'en': 'Invisible tinted fluid with fragrance SPF50+ sun protection',
        'ar': 'سائل ملون غير مرئي معطر مع حماية من الشمس SPF50+'
      },
      'soldOut': true,
      'fcfa': '0 FCFA',
      'size': null,
      'category': 'face_care',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 280,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemCount: featuredProducts.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: _buildProductCard(featuredProducts[index]),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        // Page indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            featuredProducts.length,
            (index) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentIndex == index ? 24 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: _currentIndex == index
                    ? const Color(0xFF6B73FF)
                    : const Color(0xFFD1D5DB),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }
  Widget _buildProductCard(Map<String, dynamic> product) {
    return GestureDetector(
      onTap: () => _showProductDetails(product),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                color: Color(0xFFF8F9FA),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xFFE5E7EB),
                          width: 1,
                        ),
                      ),
                      child: const Icon(
                        Icons.spa,
                        size: 50,
                        color: Color(0xFF6B73FF),
                      ),
                    ),
                  ),
                  // Sold out badge
                  if (product['soldOut'] == true)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1B365D),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          AppLocalizationsHelper.of(context).soldOut,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  // Tap to view indicator
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.shade600.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.visibility,
                        size: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Product Details
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Brand
                  Text(
                    product['brand'],
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF1B365D),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  
                  // Product Name
                  Text(
                    ProductsDataProvider.getLocalizedName(product, context),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1B1B1B),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  
                  // Description
                  Text(
                    ProductsDataProvider.getLocalizedDescription(product, context),
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFF666666),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  
                  // Rating and Price Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Rating (only show if rating > 0)
                      if (double.tryParse(product['rating'].toString()) != null && double.parse(product['rating'].toString()) > 0)
                        Row(
                          children: [
                            ...List.generate(5, (index) {
                              double rating = double.tryParse(product['rating'].toString()) ?? 0.0;
                              return Icon(
                                index < rating.floor() 
                                  ? Icons.star 
                                  : Icons.star_border,
                                size: 12,
                                color: const Color(0xFFFFA726),
                              );
                            }),
                            const SizedBox(width: 4),
                            Text(
                              product['rating'].toString(),
                              style: const TextStyle(
                                fontSize: 10,
                                color: Color(0xFF666666),
                              ),
                            ),
                          ],
                        ),
                      
                      // Price
                      Text(
                        product['fcfa'],
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: product['soldOut'] == true 
                            ? const Color(0xFF666666)
                            : const Color(0xFF1B365D),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }

  void _showProductDetails(Map<String, dynamic> product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ProductDetailsDialogWidget(product: product);
      },
    );
  }
}
