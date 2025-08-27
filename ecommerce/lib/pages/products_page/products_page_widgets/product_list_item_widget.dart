import 'package:flutter/material.dart';
import '../../../utils/app_colors.dart';
import 'highlighted_text_widget.dart';
import '../../../localization/app_localizations_helper.dart';
import 'products_data_provider.dart';

class ProductListItemWidget extends StatelessWidget {
  final Map<String, dynamic> product;
  final VoidCallback onTap;
  final String? searchQuery;

  const ProductListItemWidget({
    super.key,
    required this.product,
    required this.onTap,
    this.searchQuery,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // Product Image
              Stack(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: isDark ? colorScheme.surfaceContainerHighest : colorScheme.secondaryContainer,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: _buildProductImage(product['image']?.toString() ?? '', colorScheme),
                    ),
                  ),
                  if (product['soldOut'])
                    Positioned(
                      top: 4,
                      right: 4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        decoration: BoxDecoration(
                              color: AppColors.error(context),
                              borderRadius: BorderRadius.circular(8),
                            ),
                        child: Text(
                          AppLocalizationsHelper.of(context).soldOut,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 12),
              // Product Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HighlightedText(
                      text: product['brand'],
                      highlight: searchQuery ?? '',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? colorScheme.primary : colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                      highlightColor: AppColors.info(context),
                    ),
                    const SizedBox(height: 4),
                    HighlightedText(
                      text: ProductsDataProvider.getLocalizedName(product, context),
                      highlight: searchQuery ?? '',
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      highlightColor: AppColors.info(context),
                    ),
                    const SizedBox(height: 4),
                    HighlightedText(
                      text: ProductsDataProvider.getLocalizedDescription(product, context),
                      highlight: searchQuery ?? '',
                      style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      highlightColor: AppColors.info(context),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getDisplaySize(context),
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${product['price']}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark ? colorScheme.primary : colorScheme.primary,
                        ),
                        ),
                        Row(
                          children: [
                            Icon(Icons.star, color: AppColors.warning(context), size: 14),
                            Text(
                              '${product['rating']}',
                              style: const TextStyle(fontSize: 12),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              Icons.info_outline,
                              size: 16,
                              color: colorScheme.onSurface.withOpacity(0.7),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to get display size with localization
  String _getDisplaySize(BuildContext context) {
    final size = product['size'];
    if (size == null || size.toString().isEmpty || size.toString() == 'Not specified') {
      return AppLocalizationsHelper.of(context).notSpecified;
    }
    return size.toString();
  }

  // Helper method to build product image from network
  Widget _buildProductImage(String imagePath, ColorScheme colorScheme) {
    return Image.network(
      imagePath,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return const Center(child: CircularProgressIndicator(strokeWidth: 2));
      },
      errorBuilder: (context, error, stack) => Container(
        color: colorScheme.surfaceContainerHighest,
        child: Icon(Icons.image_not_supported, size: 30, color: colorScheme.onSurface.withOpacity(0.3)),
      ),
    );
  }
}
