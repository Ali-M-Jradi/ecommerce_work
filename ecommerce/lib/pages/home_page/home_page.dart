import 'package:flutter/material.dart';
import 'home_page_widgets/featured_products_carousel.dart';
import 'home_page_widgets/hero_banner_carousel.dart';
import '../base_page/base_page_widgets/footer_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBFF),
      body: CustomScrollView(
        slivers: [
          // Hero Banner Carousel
          SliverToBoxAdapter(
            child: const HeroBannerCarousel(),
          ),
          
          // Featured Products Section
          SliverToBoxAdapter(
            child: const Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Featured Products',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B1B1B),
                    ),
                  ),
                  SizedBox(height: 16),
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
                  const Text(
                    'Shop by Category',
                    style: TextStyle(
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
                        'Skincare',
                        'assets/images/cosmetics-beauty-products-skincare-social-media-instagram-post-square-banner-template_611904-184.avif',
                        const Color(0xFFE8F5E8),
                      ),
                      _buildCategoryCard(
                        'Makeup',
                        'assets/images/digital-art-style-mental-health-day-awareness-illustration.png',
                        const Color(0xFFFFF2E8),
                      ),
                      _buildCategoryCard(
                        'Hair Care',
                        'assets/images/three_leaves.png',
                        const Color(0xFFE8F0FF),
                      ),
                      _buildCategoryCard(
                        'Fragrance',
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
                  const Text(
                    'Why Choose Us?',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B1B1B),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildFeatureItem(
                    Icons.verified_user,
                    'Authentic Products',
                    'All products are 100% authentic and sourced directly from brands',
                  ),
                  const SizedBox(height: 12),
                  _buildFeatureItem(
                    Icons.local_shipping,
                    'Fast Delivery',
                    'Quick and secure delivery to your doorstep',
                  ),
                  const SizedBox(height: 12),
                  _buildFeatureItem(
                    Icons.support_agent,
                    'Expert Support',
                    'Professional skincare consultation and support',
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
    return Container(
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
    );
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
