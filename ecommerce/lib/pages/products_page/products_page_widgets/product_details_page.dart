import 'package:flutter/material.dart';

class ProductDetailsPage extends StatelessWidget {
  final Map<String, dynamic> product;
  const ProductDetailsPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final name = product['name'] is Map ? product['name']['en'] ?? '' : product['name'] ?? 'Product Details';
    final barcode = product['barcode'] ?? '';
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(name, style: TextStyle(color: colorScheme.onSurface)),
        backgroundColor: colorScheme.surface,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
      ),
      body: Center(
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          margin: const EdgeInsets.all(24),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(Icons.qr_code, color: colorScheme.onSurface),
                    const SizedBox(width: 8),
                    Text(
                      'Barcode: $barcode',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(color: colorScheme.onSurface),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Placeholder for additional product info
                Text(
                  'More product details coming soon...',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface.withOpacity(0.7)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
