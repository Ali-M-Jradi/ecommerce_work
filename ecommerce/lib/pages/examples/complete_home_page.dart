import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/content_provider.dart';
import 'package:extended_image/extended_image.dart';

/// Complete Home Page with API content consumption
class CompleteHomePage extends StatefulWidget {
  const CompleteHomePage({super.key});

  @override
  State<CompleteHomePage> createState() => _CompleteHomePageState();
}

class _CompleteHomePageState extends State<CompleteHomePage> {
  @override
  void initState() {
    super.initState();
    // Load content when page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ContentProvider>().loadContent();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ContentProvider>(
        builder: (context, contentProvider, child) {
          if (contentProvider.isLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading content...'),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => contentProvider.refreshContent(),
            child: CustomScrollView(
              slivers: [
                // 1. APP BAR WITH COLORS FROM API
                _buildAppBar(contentProvider),
                
                // 2. HERO CAROUSEL FROM API
                _buildHeroCarousel(contentProvider),
                
                // 3. MOVING BANNER FROM API
                _buildMovingBanner(contentProvider),
                
                // 4. CONTENT SECTIONS
                _buildContentSections(contentProvider),
                
                // 5. CONTACT INFORMATION
                _buildContactSection(contentProvider),
                
                // 6. SOCIAL MEDIA FOOTER
                _buildSocialMediaFooter(contentProvider),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAppBar(ContentProvider contentProvider) {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: contentProvider.getPrimaryColor(),
      flexibleSpace: FlexibleSpaceBar(
        title: const Text('E-Commerce Store'),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                contentProvider.getPrimaryColor(),
                contentProvider.getSecondaryColor(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroCarousel(ContentProvider contentProvider) {
    final carouselImages = contentProvider.getCarouselImages();
    
    return SliverToBoxAdapter(
      child: Container(
        height: 220,
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey[200],
        ),
        child: carouselImages.isEmpty
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.image_not_supported, size: 48, color: Colors.grey),
                    SizedBox(height: 8),
                    Text('No carousel images available'),
                  ],
                ),
              )
            : PageView.builder(
                itemCount: carouselImages.length,
                itemBuilder: (context, index) {
                  final imageFilename = carouselImages[index];
                  final imageUrl = 'assets/images/$imageFilename';
                  
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: ExtendedImage.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      cache: true,
                      loadStateChanged: (ExtendedImageState state) {
                        switch (state.extendedImageLoadState) {
                          case LoadState.loading:
                            return Container(
                              color: Colors.grey[200],
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          case LoadState.completed:
                            return ExtendedRawImage(
                              image: state.extendedImageInfo?.image,
                              fit: BoxFit.cover,
                            );
                          case LoadState.failed:
                            return Container(
                              color: Colors.grey[300],
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.broken_image, size: 48, color: Colors.grey[600]),
                                  const SizedBox(height: 8),
                                  Text(imageFilename, 
                                       style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                                  const Text('Image not available', 
                                             style: TextStyle(color: Colors.grey, fontSize: 10)),
                                ],
                              ),
                            );
                        }
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }

  Widget _buildMovingBanner(ContentProvider contentProvider) {
    final bannerTexts = contentProvider.getMovingBannerTexts();
    
    if (bannerTexts.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverToBoxAdapter(
      child: Container(
        height: 50,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: contentProvider.getThirdColor(),
          borderRadius: BorderRadius.circular(8),
        ),
        child: PageView.builder(
          controller: PageController(viewportFraction: 1.0),
          itemCount: bannerTexts.length,
          itemBuilder: (context, index) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  bannerTexts[index],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildContentSections(ContentProvider contentProvider) {
    // Get different types of content for home page sections
    final featuredProducts = contentProvider.getSectionContent('home', 'featured-products');
    final specialOffers = contentProvider.getSectionContent('home', 'special-offers');
    final categoryHighlights = contentProvider.getSectionContent('home', 'categories');

    return SliverList(
      delegate: SliverChildListDelegate([
        const SizedBox(height: 24),
        
        // Featured Products Section
        if (featuredProducts.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Featured Products',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: contentProvider.getPrimaryColor(),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 12),
          ...featuredProducts.map((item) => ListTile(
            leading: const Icon(Icons.star),
            title: Text(item.description),
            subtitle: Text(item.contentData),
          )),
        ],

        // Special Offers Section
        if (specialOffers.isNotEmpty) ...[
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Special Offers',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: contentProvider.getSecondaryColor(),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 12),
          ...specialOffers.map((item) => Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: ListTile(
              leading: const Icon(Icons.local_offer),
              title: Text(item.description),
              subtitle: Text(item.contentData),
            ),
          )),
        ],

        // Category Highlights
        if (categoryHighlights.isNotEmpty) ...[
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Shop by Category',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.5,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: categoryHighlights.length,
            itemBuilder: (context, index) {
              final category = categoryHighlights[index];
              return Card(
                child: InkWell(
                  onTap: () {
                    // Navigate to category page
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Navigate to ${category.description}')),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.category, size: 32),
                        const SizedBox(height: 8),
                        Text(
                          category.description,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        if (category.contentData.isNotEmpty)
                          Text(
                            category.contentData,
                            style: Theme.of(context).textTheme.bodySmall,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ]),
    );
  }

  Widget _buildContactSection(ContentProvider contentProvider) {
    final contactInfo = contentProvider.getContactInfo();
    
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Contact Us',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            if (contactInfo['phone']?.isNotEmpty == true)
              ListTile(
                leading: const Icon(Icons.phone),
                title: Text(contactInfo['phone']!),
                dense: true,
                contentPadding: EdgeInsets.zero,
                onTap: () {
                  // Launch phone dialer
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Calling ${contactInfo['phone']}')),
                  );
                },
              ),
            if (contactInfo['email']?.isNotEmpty == true)
              ListTile(
                leading: const Icon(Icons.email),
                title: Text(contactInfo['email']!),
                dense: true,
                contentPadding: EdgeInsets.zero,
                onTap: () {
                  // Launch email client
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Email ${contactInfo['email']}')),
                  );
                },
              ),
            if (contactInfo['location']?.isNotEmpty == true)
              ListTile(
                leading: const Icon(Icons.location_on),
                title: Text(contactInfo['location']!),
                dense: true,
                contentPadding: EdgeInsets.zero,
                onTap: () {
                  // Open maps
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Opening location: ${contactInfo['location']}')),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialMediaFooter(ContentProvider contentProvider) {
    final socialLinks = contentProvider.getSocialMediaLinks();
    
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Follow Us',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (socialLinks['facebook']?.isNotEmpty == true)
                  _buildSocialButton(Icons.facebook, 'Facebook', () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Opening Facebook: ${socialLinks['facebook']}')),
                    );
                  }),
                if (socialLinks['instagram']?.isNotEmpty == true)
                  _buildSocialButton(Icons.camera_alt, 'Instagram', () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Opening Instagram: ${socialLinks['instagram']}')),
                    );
                  }),
                if (socialLinks['whatsapp']?.isNotEmpty == true)
                  _buildSocialButton(Icons.chat, 'WhatsApp', () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Opening WhatsApp: ${socialLinks['whatsapp']}')),
                    );
                  }),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialButton(IconData icon, String label, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          IconButton(
            onPressed: onPressed,
            icon: Icon(icon, size: 32),
            style: IconButton.styleFrom(
              backgroundColor: Colors.grey[200],
              foregroundColor: Colors.grey[700],
              padding: const EdgeInsets.all(12),
            ),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
