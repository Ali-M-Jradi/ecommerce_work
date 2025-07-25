import 'package:flutter/material.dart';
import 'home_page_widgets/featured_products_carousel.dart';
import 'home_page_widgets/hero_banner_carousel.dart';
import '../base_page/base_page_widgets/footer_widget.dart';
import '../products_page/products_page.dart';
import 'package:ecommerce/localization/app_localizations_helper.dart';

import 'package:ecommerce/shared/scan_utils.dart';
import 'package:ecommerce/shared/unified_scan_fab.dart';


class HomePage extends StatefulWidget {
  final Function(bool)? onFloatingButtonVisibilityChanged;
  const HomePage({super.key, this.onFloatingButtonVisibilityChanged});

  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> with ScanHistoryMixin, UnifiedScanFabMixin {
  final ScrollController _scrollController = ScrollController();
  bool _showFloatingButtons = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    final threshold = maxScroll - 80.0; // Hide when near bottom/footer (80px from bottom)
    final percentageScrolled = maxScroll > 0 ? currentScroll / maxScroll : 0.0;
    final atBottom = (maxScroll - currentScroll) <= 10.0;
    final shouldShow = !atBottom && currentScroll < threshold && percentageScrolled < 0.97;
    if (_showFloatingButtons != shouldShow) {
      setState(() {
        _showFloatingButtons = shouldShow;
      });
    }
  }





  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.background,
      floatingActionButton: _showFloatingButtons
          ? UnifiedScanFab(
              heroTagPrefix: 'home_page',
              onLoyaltyPressed: () {},
              onContactPressed: () {},
              onScanPressed: () async {
                await showScanOptionsModal(context);
              },
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Hero Banner Carousel
          SliverToBoxAdapter(
            child: const HeroBannerCarousel(),
          ),
          // Featured Products Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizationsHelper.of(context).featuredProducts,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onBackground,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductsPage(
                                categoryTitle: AppLocalizationsHelper.of(context).allProducts,
                              ),
                            ),
                          );
                        },
                        child: Text(
                          AppLocalizationsHelper.of(context).viewAll,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.primary,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Divider(
                    height: 1,
                    thickness: 0.7,
                    color: colorScheme.outlineVariant.withOpacity(0.15),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: FeaturedProductsCarousel(),
            ),
          ),
          // Categories Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizationsHelper.of(context).shopByCategory,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onBackground,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: [
                          SizedBox(
                            width: (constraints.maxWidth - 16) / 2,
                            child: _buildCategoryCard(
                              AppLocalizationsHelper.of(context).skincare,
                              'assets/images/cosmetics-beauty-products-skincare-social-media-instagram-post-square-banner-template_611904-184.avif',
                              theme.brightness == Brightness.dark
                                  ? colorScheme.surfaceVariant
                                  : colorScheme.secondaryContainer,
                            ),
                          ),
                          SizedBox(
                            width: (constraints.maxWidth - 16) / 2,
                            child: _buildCategoryCard(
                              AppLocalizationsHelper.of(context).makeup,
                              'assets/images/digital-art-style-mental-health-day-awareness-illustration.png',
                              theme.brightness == Brightness.dark
                                  ? colorScheme.surfaceVariant
                                  : colorScheme.tertiaryContainer,
                            ),
                          ),
                          SizedBox(
                            width: (constraints.maxWidth - 16) / 2,
                            child: _buildCategoryCard(
                              AppLocalizationsHelper.of(context).hairCare,
                              'assets/images/three_leaves.png',
                              theme.brightness == Brightness.dark
                                  ? colorScheme.surfaceVariant
                                  : colorScheme.primaryContainer,
                            ),
                          ),
                          SizedBox(
                            width: (constraints.maxWidth - 16) / 2,
                            child: _buildCategoryCard(
                              AppLocalizationsHelper.of(context).fragrance,
                              'assets/images/gift_icon.jpg',
                              theme.brightness == Brightness.dark
                                  ? colorScheme.surfaceVariant
                                  : colorScheme.secondaryContainer,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Divider(
                        height: 1,
                        thickness: 0.7,
                        color: colorScheme.outlineVariant.withOpacity(0.15),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: const SizedBox(height: 30),
          ),
          // About Section
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadow.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizationsHelper.of(context).whyChooseUs,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildFeatureItem(
                    Icons.verified_user,
                    AppLocalizationsHelper.of(context).authenticProducts,
                    AppLocalizationsHelper.of(context).authenticProductsDesc,
                  ),
                  const SizedBox(height: 12),
                  _buildFeatureItem(
                    Icons.local_shipping,
                    AppLocalizationsHelper.of(context).fastDelivery,
                    AppLocalizationsHelper.of(context).fastDeliveryDesc,
                  ),
                  const SizedBox(height: 12),
                  _buildFeatureItem(
                    Icons.support_agent,
                    AppLocalizationsHelper.of(context).expertSupport,
                    AppLocalizationsHelper.of(context).expertSupportDesc,
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: const SizedBox(height: 40),
          ),
          // Footer - Only appears when scrolling to the end
          SliverToBoxAdapter(
            child: const FooterWidget(),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(String title, String imagePath, Color backgroundColor) {
    // Convert UI-friendly title to a category identifier for routing
    String categoryId = _getCategoryIdFromTitle(title);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final cardBackground = backgroundColor;
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductsPage(
              category: categoryId,
              categoryTitle: title,
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Material(
        elevation: 3,
        borderRadius: BorderRadius.circular(16),
        color: cardBackground,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: isDark
                      ? colorScheme.surface
                      : colorScheme.background,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.shadow.withOpacity(0.10),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.spa,
                  size: 30,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                title,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                  fontSize: 17,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Map UI-friendly category titles to their corresponding IDs used in the product data
  String _getCategoryIdFromTitle(String title) {
    // Get context-aware localizations
    final localizations = AppLocalizationsHelper.of(context);
    
    // Map localized UI titles to backend category IDs
    if (title == localizations.skincare) {
      return 'face_care'; // Face care is our skincare category
    } else if (title == localizations.makeup) {
      return 'makeup';
    } else if (title == localizations.hairCare) {
      return 'hair_care';
    } else if (title == localizations.fragrance) {
      return 'fragrance';
    }
    
    // Default case: convert the title to a slug format
    return title.toLowerCase().replaceAll(' ', '_');
  }

  Widget _buildFeatureItem(IconData icon, String title, String description) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Color.alphaBlend(colorScheme.primary.withAlpha((0.1 * 255).round()), colorScheme.surface),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: colorScheme.primary,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
