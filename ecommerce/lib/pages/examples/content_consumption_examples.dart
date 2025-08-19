import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce/providers/content_provider.dart';

/// Example of how to consume different content types in widgets
class ContentConsumptionExamples extends StatelessWidget {
  const ContentConsumptionExamples({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Content Consumption Examples')),
      body: Consumer<ContentProvider>(
        builder: (context, contentProvider, child) {
          if (contentProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (contentProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, size: 64, color: Theme.of(context).colorScheme.error),
                  const SizedBox(height: 16),
                  Text('Error loading content'),
                  const SizedBox(height: 8),
                  Text(contentProvider.error!, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => contentProvider.refreshContent(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. CAROUSEL IMAGES
                _buildCarouselSection(contentProvider),
                const SizedBox(height: 24),
                
                // 2. MOVING BANNER TEXTS
                _buildMovingBannerSection(contentProvider),
                const SizedBox(height: 24),
                
                // 3. CONTACT INFORMATION
                _buildContactSection(contentProvider),
                const SizedBox(height: 24),
                
                // 4. SOCIAL MEDIA
                _buildSocialMediaSection(contentProvider),
                const SizedBox(height: 24),
                
                // 5. THEME COLORS
                _buildColorsSection(contentProvider),
                const SizedBox(height: 24),
                
                // 6. RAW DATA DEBUG
                _buildDebugSection(contentProvider),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCarouselSection(ContentProvider contentProvider) {
    final carouselImages = contentProvider.getCarouselImages();
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('🎠 Carousel Images (${carouselImages.length})', 
                 style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            if (carouselImages.isEmpty)
              const Text('No carousel images found')
            else
              ...carouselImages.asMap().entries.map((entry) {
                final index = entry.key;
                final filename = entry.value;
                return ListTile(
                  leading: CircleAvatar(child: Text('${index + 1}')),
                  title: Text(filename),
                  subtitle: Text(_getImageType(filename)),
                  trailing: Icon(_isWebPImage(filename) ? Icons.image : Icons.photo),
                );
              }),
          ],
        ),
      ),
    );
  }

  Widget _buildMovingBannerSection(ContentProvider contentProvider) {
    final bannerTexts = contentProvider.getMovingBannerTexts();
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('📢 Moving Banner Texts (${bannerTexts.length})', 
                 style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            if (bannerTexts.isEmpty)
              const Text('No banner texts found')
            else
              ...bannerTexts.asMap().entries.map((entry) {
                final index = entry.key;
                final text = entry.value;
                return ListTile(
                  leading: CircleAvatar(child: Text('${index + 1}')),
                  title: Text(text),
                  trailing: const Icon(Icons.campaign),
                );
              }),
          ],
        ),
      ),
    );
  }

  Widget _buildContactSection(ContentProvider contentProvider) {
    final contactInfo = contentProvider.getContactInfo();
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('📞 Contact Information', 
                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text('Phone'),
              subtitle: Text(contactInfo['phone'] ?? 'Not set'),
            ),
            ListTile(
              leading: const Icon(Icons.location_on),
              title: const Text('Location'),
              subtitle: Text(contactInfo['location'] ?? 'Not set'),
            ),
            ListTile(
              leading: const Icon(Icons.email),
              title: const Text('Email'),
              subtitle: Text(contactInfo['email'] ?? 'Not set'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialMediaSection(ContentProvider contentProvider) {
    final socialLinks = contentProvider.getSocialMediaLinks();
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('🌐 Social Media Links', 
                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.facebook),
              title: const Text('Facebook'),
              subtitle: Text(socialLinks['facebook'] ?? 'Not set'),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Instagram'),
              subtitle: Text(socialLinks['instagram'] ?? 'Not set'),
            ),
            ListTile(
              leading: const Icon(Icons.chat),
              title: const Text('WhatsApp'),
              subtitle: Text(socialLinks['whatsapp'] ?? 'Not set'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorsSection(ContentProvider contentProvider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('🎨 Theme Colors', 
                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildColorSwatch('Primary', contentProvider.getPrimaryColor()),
                const SizedBox(width: 16),
                _buildColorSwatch('Secondary', contentProvider.getSecondaryColor()),
                const SizedBox(width: 16),
                _buildColorSwatch('Third', contentProvider.getThirdColor()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorSwatch(String label, Color color) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 12)),
        Text('#${color.value.toRadixString(16).substring(2).toUpperCase()}', 
             style: const TextStyle(fontSize: 10, fontFamily: 'monospace')),
      ],
    );
  }

  Widget _buildDebugSection(ContentProvider contentProvider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('🔧 Debug Info (${contentProvider.items.length} total items)', 
                 style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...contentProvider.items.take(5).map((item) => ListTile(
              title: Text('${item.pageName} → ${item.section}'),
              subtitle: Text('${item.description}: ${item.contentData}'),
              dense: true,
            )),
            if (contentProvider.items.length > 5)
              Text('... and ${contentProvider.items.length - 5} more items'),
          ],
        ),
      ),
    );
  }

  String _getImageType(String filename) {
    if (filename.contains('.webp')) return 'WebP Format';
    if (filename.contains('.jpg')) return 'JPEG Format';
    if (filename.contains('.png')) return 'PNG Format';
    return 'Unknown Format';
  }

  bool _isWebPImage(String filename) {
    return filename.toLowerCase().contains('.webp');
  }
}
