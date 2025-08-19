import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce/providers/content_provider.dart';

class ContentTestWidget extends StatelessWidget {
  const ContentTestWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Content API Test'),
      ),
      body: Consumer<ContentProvider>(
        builder: (context, contentProvider, child) {
          if (contentProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (contentProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: ${contentProvider.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => contentProvider.refreshContent(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          // Display sample content
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Content Statistics',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            ElevatedButton.icon(
                              onPressed: () => contentProvider.refreshContent(),
                              icon: const Icon(Icons.refresh, size: 16),
                              label: const Text('Refresh API'),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text('Total Items: ${contentProvider.items.length}'),
                        Text('Has Content: ${contentProvider.hasContent}'),
                        Text('API Endpoint: https://localhost:7184/api/site-content'),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: contentProvider.items.isNotEmpty 
                                ? Colors.green.withOpacity(0.1)
                                : Colors.orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                contentProvider.items.isNotEmpty 
                                    ? Icons.check_circle 
                                    : Icons.warning,
                                size: 16,
                                color: contentProvider.items.isNotEmpty 
                                    ? Colors.green 
                                    : Colors.orange,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                contentProvider.items.isNotEmpty 
                                    ? 'API Connected Successfully'
                                    : 'Using Mock Data (API may be offline)',
                                style: TextStyle(
                                  color: contentProvider.items.isNotEmpty 
                                      ? Colors.green.shade700
                                      : Colors.orange.shade700,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Colors',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 8),
                        _buildColorItem('Primary Color', contentProvider.getColor('MainColor')),
                        _buildColorItem('Secondary Color', contentProvider.getColor('SecondaryColor')),
                        _buildColorItem('Third Color', contentProvider.getColor('ThirdColor')),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Social Media',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 8),
                        _buildTextItem('Facebook', contentProvider.getSocialMedia('FaceBook')),
                        _buildTextItem('Instagram', contentProvider.getSocialMedia('Instagram')),
                        _buildTextItem('WhatsApp', contentProvider.getSocialMedia('Whatsapp')),
                        _buildTextItem('Email', contentProvider.getSocialMedia('Email')),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Home Content',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 8),
                        _buildTextItem('Phone', contentProvider.getHomeContent('UpperBanner', 'PhoneNumber')),
                        _buildTextItem('Location', contentProvider.getHomeContent('UpperBanner', 'Location')),
                        _buildTextItem('Banner Image', contentProvider.getHomeContent('UpperBanner', 'UpperBannerPhoto')),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Moving Banner Texts',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 8),
                        ...contentProvider.getMovingBannerTexts().map(
                          (text) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Text('• $text'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Carousel Images',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 8),
                        Text('Found ${contentProvider.getCarouselImages().length} carousel images:'),
                        const SizedBox(height: 8),
                        ...contentProvider.getCarouselImages().map(
                          (image) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Row(
                              children: [
                                const Text('• ', style: TextStyle(fontSize: 12)),
                                Expanded(
                                  child: Text(
                                    image, 
                                    style: const TextStyle(fontSize: 12),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'URL: https://localhost:7184/images/$image',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (contentProvider.getCarouselImages().isEmpty)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'No carousel images found in API data',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.error,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildColorItem(String label, String colorValue) {
    Color color;
    try {
      color = Color(int.parse(colorValue.replaceFirst('#', '0xff')));
    } catch (e) {
      color = Colors.grey;
    }
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: color,
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 8),
          Text('$label: $colorValue'),
        ],
      ),
    );
  }

  Widget _buildTextItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value.isEmpty ? '(empty)' : value),
          ),
        ],
      ),
    );
  }
}
