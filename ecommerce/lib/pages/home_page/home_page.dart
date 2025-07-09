import 'package:flutter/material.dart';
import 'home_page_widgets/featured_products_carousel.dart';
import 'home_page_widgets/hero_banner_carousel.dart';
import '../base_page/base_page_widgets/footer_widget.dart';
import '../products_page/products_page.dart';
import 'package:ecommerce/l10n/app_localizations.dart';
import 'package:ecommerce/localization/app_localizations_helper.dart';

class HomePage extends StatefulWidget {
  final Function(bool)? onFloatingButtonVisibilityChanged;
  
  const HomePage({super.key, this.onFloatingButtonVisibilityChanged});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  bool _lastVisibilityState = true;

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
    final threshold = maxScroll * 0.85; // Hide when 85% scrolled

    bool shouldShow = currentScroll < threshold;

    if (shouldShow != _lastVisibilityState) {
      _lastVisibilityState = shouldShow;
      widget.onFloatingButtonVisibilityChanged?.call(shouldShow);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBFF),
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
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizationsHelper.of(context).featuredProducts,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1B1B1B),
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
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.deepPurple.shade600,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
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
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizationsHelper.of(context).shopByCategory,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B1B1B),
                    ),
                  ),
                  const SizedBox(height: 16),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    childAspectRatio: 1.5,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: [
                      _buildCategoryCard(
                        AppLocalizationsHelper.of(context).skincare,
                        'assets/images/cosmetics-beauty-products-skincare-social-media-instagram-post-square-banner-template_611904-184.avif',
                        const Color(0xFFE8F5E8),
                      ),
                      _buildCategoryCard(
                        AppLocalizationsHelper.of(context).makeup,
                        'assets/images/digital-art-style-mental-health-day-awareness-illustration.png',
                        const Color(0xFFFFF2E8),
                      ),
                      _buildCategoryCard(
                        AppLocalizationsHelper.of(context).hairCare,
                        'assets/images/three_leaves.png',
                        const Color(0xFFE8F0FF),
                      ),
                      _buildCategoryCard(
                        AppLocalizationsHelper.of(context).fragrance,
                        'assets/images/gift_icon.jpg',
                        const Color(0xFFF8E8FF),
                      ),
                    ],
                  ),
                ],
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
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizationsHelper.of(context).whyChooseUs,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B1B1B),
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
    
    return InkWell(
      onTap: () {
        // Navigate to products page with the selected category
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
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Icon(
                Icons.spa,
                size: 30,
                color: Color(0xFF6B73FF),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1B1B1B),
              ),
            ),
          ],
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF6B73FF).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: const Color(0xFF6B73FF),
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
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1B1B1B),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF666666),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
