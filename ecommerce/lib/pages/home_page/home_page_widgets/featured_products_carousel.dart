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
                    ? Theme.of(context).colorScheme.primary
                    : Color.alphaBlend(
                        Theme.of(context).colorScheme.onSurface.withAlpha((0.2 * 255).round()),
                        Theme.of(context).colorScheme.surface,
                      ),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }
  Widget _buildProductCard(Map<String, dynamic> product) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    return GestureDetector(
      onTap: () => _showProductDetails(product),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Color.alphaBlend(Colors.black.withAlpha((0.18 * 255).round()), colorScheme.surface)
                  : Color.alphaBlend(Colors.black.withAlpha((0.08 * 255).round()), colorScheme.surface),
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
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  color: isDark ? colorScheme.surfaceVariant : colorScheme.background,
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Color.alphaBlend(colorScheme.outline.withAlpha((0.2 * 255).round()), colorScheme.surface),
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          Icons.spa,
                          size: 50,
                          color: colorScheme.primary,
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
                            color: colorScheme.error,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            AppLocalizationsHelper.of(context).soldOut,
                            style: TextStyle(
                              color: colorScheme.onError,
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
                          color: Color.alphaBlend(colorScheme.secondary.withAlpha((0.9 * 255).round()), colorScheme.surface),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.visibility,
                          size: 14,
                          color: colorScheme.onSecondary,
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
                      style: TextStyle(
                        fontSize: 11,
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Product Name
                    Text(
                      ProductsDataProvider.getLocalizedName(product, context),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Description
                    Text(
                      ProductsDataProvider.getLocalizedDescription(product, context),
                      style: TextStyle(
                        fontSize: 10,
                        color: Color.alphaBlend(colorScheme.onSurface.withAlpha((0.7 * 255).round()), colorScheme.surface),
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
                                  color: colorScheme.secondary,
                                );
                              }),
                              const SizedBox(width: 4),
                              Text(
                                product['rating'].toString(),
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Color.alphaBlend(colorScheme.onSurface.withAlpha((0.7 * 255).round()), colorScheme.surface),
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
                                ? Color.alphaBlend(colorScheme.onSurface.withAlpha((0.5 * 255).round()), colorScheme.surface)
                                : colorScheme.primary,
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
