import 'package:flutter/material.dart';
import 'highlighted_text_widget.dart';
import '../../../localization/app_localizations_helper.dart';
import 'products_data_provider.dart';

class ProductCardWidget extends StatelessWidget {
  final Map<String, dynamic> product;
  final VoidCallback onTap;
  final String? searchQuery;

  const ProductCardWidget({
    super.key,
    required this.product,
    required this.onTap,
    this.searchQuery,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final highlightColor = colorScheme.secondary;
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image with Badge
            Expanded(
              flex: 5,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(12.0),
                      ),
                      color: isDark ? colorScheme.surfaceVariant : colorScheme.secondaryContainer,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(12.0),
                      ),
                      child: Image.asset(
                        product['image'],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.image,
                            size: 40,
                            color: colorScheme.onSurface.withOpacity(0.3),
                          );
                        },
                      ),
                    ),
                  ),
                  if (product['soldOut'])
                    Positioned(
                      top: 6,
                      right: 6,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: colorScheme.error,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          AppLocalizationsHelper.of(context).soldOut,
                          style: TextStyle(
                            color: colorScheme.onError,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Product Info
            Expanded(
              flex: 4,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Brand
                    HighlightedText(
                      text: product['brand'],
                      highlight: searchQuery ?? '',
                      style: TextStyle(
                        fontSize: 11,
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      highlightColor: highlightColor,
                    ),
                    SizedBox(height: 2),
                    // Product Name
                    Expanded(
                      child: HighlightedText(
                        text: ProductsDataProvider.getLocalizedName(product, context),
                        highlight: searchQuery ?? '',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        highlightColor: highlightColor,
                      ),
                    ),
                    // Size
                    Text(
                      _getDisplaySize(context),
                      style: TextStyle(fontSize: 10, color: colorScheme.onSurface.withOpacity(0.6)),
                    ),
                    SizedBox(height: 4),
                    // Price and Rating with info icon
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            '\$${product['price']}',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: isDark ? colorScheme.primary : colorScheme.primary,
                          ),
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.star, color: Colors.orange, size: 11),
                            Text(
                              '${product['rating']}',
                              style: TextStyle(fontSize: 10),
                            ),
                            SizedBox(width: 4),
                            Icon(
                              Icons.info_outline,
                              size: 14,
                              color: colorScheme.onSurface.withOpacity(0.7),
                            ),
                          ],
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

  // Helper method to get display size with localization
  String _getDisplaySize(BuildContext context) {
    final size = product['size'];
    if (size == null || size.toString().isEmpty || size.toString() == 'Not specified') {
      return AppLocalizationsHelper.of(context).notSpecified;
    }
    return size.toString();
  }
}
