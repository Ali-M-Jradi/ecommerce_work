import 'package:flutter/material.dart';

class ImageDebugInfo extends StatelessWidget {
  final List<String> imageFilenames;

  const ImageDebugInfo({super.key, required this.imageFilenames});

  // Helper function to check if filename indicates WebP format
  bool _isWebPImage(String filename) {
    return filename.toLowerCase().endsWith('.webp');
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Image Debug Info',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text('Total Images: ${imageFilenames.length}'),
            const SizedBox(height: 8),
            const Text('Image Source: Local Assets'),
            const SizedBox(height: 16),
            ...imageFilenames.asMap().entries.map((entry) {
              final index = entry.key;
              final filename = entry.value;
              final isWebP = _isWebPImage(filename);
              final imagePath = 'assets/images/$filename';
              
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isWebP 
                    ? Colors.orange.withOpacity(0.1) 
                    : Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Image ${index + 1}: ${isWebP ? 'WebP' : 'Standard'}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isWebP ? Colors.orange : Colors.green,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'File: $filename',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Path: $imagePath',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 16,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Orange = WebP format, Green = JPG/PNG format',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
