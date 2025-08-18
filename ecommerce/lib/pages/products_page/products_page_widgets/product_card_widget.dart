

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'highlighted_text_widget.dart';
import '../../../localization/app_localizations_helper.dart';
import 'products_data_provider.dart';
import '../../../providers/wishlist_provider.dart';
import '../../../models/product.dart';

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
    // Generate a consistent fallback id for this widget instance
    final fallbackId = product['id']?.toString() ?? (product.hashCode.toString());
    // Category badge color map using theme-based colors for consistency
    final Map<String, Color> categoryColors = {
      'face_care': colorScheme.primaryContainer,
      'body_care': colorScheme.secondaryContainer,
      'hair_care': colorScheme.tertiaryContainer,
      'fragrance': colorScheme.surfaceContainerHighest,
      'makeup': colorScheme.errorContainer,
      'baby_care': colorScheme.inversePrimary,
    };
    final Map<String, IconData> categoryIcons = {
      'face_care': Icons.face,
      'body_care': Icons.spa,
      'hair_care': Icons.waves,
      'fragrance': Icons.local_florist,
      'makeup': Icons.brush,
      'baby_care': Icons.child_friendly,
    };
    final String category = (product['category'] ?? '').toString();
    final Color badgeColor = categoryColors[category] ?? colorScheme.secondaryContainer;
    final IconData? badgeIcon = categoryIcons[category];
    final bool isBestSeller = product['bestSeller'] == true;
    final bool isNew = product['isNew'] == true;
    final double? oldPrice = product['oldPrice'] != null ? double.tryParse(product['oldPrice'].toString()) : null;
    final double? price = double.tryParse(product['price']?.toString() ?? '');
    final bool hasDiscount = oldPrice != null && price != null && oldPrice > price;
    //

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image with Badges, Wishlist, Category, Out-of-Stock, Discount, Best Seller/New, Add to Cart
            Expanded(
              flex: 5,
              child: Stack(
                children: [
                  // Hero animation for product image, ColorFiltered only wraps the image
                  Hero(
                    tag: 'product_image_$fallbackId',
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(12.0),
                        ),
                        color: isDark ? colorScheme.surfaceContainerHighest : colorScheme.secondaryContainer,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(12.0),
                        ),
                        child: ColorFiltered(
                          colorFilter: product['soldOut'] == true
                              ? const ColorFilter.mode(Colors.grey, BlendMode.saturation)
                              : const ColorFilter.mode(Colors.transparent, BlendMode.multiply),
                          child: _buildProductImage(product['image'], colorScheme),
                        ),
                      ),
                    ),
                  ),
                  // Category Badge with Icon
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: badgeColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (badgeIcon != null) ...[
                            Icon(badgeIcon, size: 12, color: colorScheme.onSecondaryContainer),
                            const SizedBox(width: 2),
                          ],
                          Text(
                            category.replaceAll('_', ' ').toUpperCase(),
                            style: TextStyle(
                              color: colorScheme.onSecondaryContainer,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                            semanticsLabel: 'Category: ${category.replaceAll('_', ' ')}',
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Discount badge
                  if (hasDiscount && oldPrice > 0)
                    Positioned(
                      top: 6,
                      left: 38,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '-${((100 * (oldPrice - price) / oldPrice).round())}%',
                          style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  // Best Seller/New badge
                  if (isBestSeller)
                    Positioned(
                      top: 30,
                      right: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.orangeAccent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text('BEST SELLER', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  if (isNew)
                    Positioned(
                      top: isBestSeller ? 50 : 30,
                      right: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text('NEW', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  // Wishlist Icon Button
                  Positioned(
                    top: 6,
                    left: 6,
                    child: Consumer<WishlistProvider>(
                      builder: (context, wishlistProvider, _) {
                        final isFavorite = wishlistProvider.wishlist.any((p) => p.id == fallbackId);
                        return Semantics(
                          label: isFavorite ? 'Remove from wishlist' : 'Add to wishlist',
                          button: true,
                          child: IconButton(
                            icon: Icon(
                              isFavorite ? Icons.favorite : Icons.favorite_border,
                              color: isFavorite ? Colors.red : colorScheme.onSurface.withOpacity(0.7),
                              size: 22,
                            ),
                            onPressed: () {
                              String id = fallbackId;
                              String name = product['name'] is String
                                  ? product['name']
                                  : (product['name']?['en'] ?? 'Unnamed Product');
                              String description = product['description'] is String
                                  ? product['description']
                                  : (product['description']?['en'] ?? '');
                              double price = double.tryParse(product['price']?.toString() ?? '') ?? 0.0;
                              double rating = double.tryParse(product['rating']?.toString() ?? '') ?? 0.0;
                              final prod = Product.fromMap({
                                ...product,
                                'id': id,
                                'name': name,
                                'description': description,
                                'price': price,
                                'rating': rating,
                              });
                              wishlistProvider.toggleWishlist(prod);
                            },
                            tooltip: isFavorite ? 'Remove from wishlist' : 'Add to wishlist',
                          ),
                        );
                      },
                    ),
                  ),
                  // Out-of-stock badge overlay
                  if (product['soldOut'])
                    Positioned(
                      bottom: 6,
                      right: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
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
                  // Quick add to cart button (bottom left)
                  Positioned(
                    bottom: 6,
                    left: 6,
                    child: Semantics(
                      label: 'Add to cart',
                      button: true,
                      child: IconButton(
                        icon: const Icon(Icons.add_shopping_cart, size: 18),
                        color: colorScheme.primary,
                        onPressed: product['soldOut'] == true ? null : () {
                          // TODO: Implement add to cart logic
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Added to cart!')),
                          );
                        },
                        tooltip: 'Add to cart',
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
                padding: const EdgeInsets.all(8.0),
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
                    const SizedBox(height: 2),
                    // Product Name
                    Expanded(
                      child: HighlightedText(
                        text: ProductsDataProvider.getLocalizedName(product, context),
                        highlight: searchQuery ?? '',
                        style: const TextStyle(
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
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 4),
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
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.star, color: Colors.orange, size: 11),
                            Text(
                              '${product['rating']}',
                              style: const TextStyle(fontSize: 10),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(width: 4),
                            Tooltip(
                              message: ProductsDataProvider.getLocalizedDescription(product, context),
                              child: Icon(
                                Icons.info_outline,
                                size: 14,
                                color: colorScheme.onSurface.withOpacity(0.7),
                              ),
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

  // Helper method to build product image (asset images only)
  Widget _buildProductImage(String imagePath, ColorScheme colorScheme) {
    // Use asset image (network images removed)
    return Image.asset(
      imagePath.startsWith('assets/') ? imagePath : 'assets/images/$imagePath',
      fit: BoxFit.cover,
      width: double.infinity,
      height: 120,
      errorBuilder: (context, error, stackTrace) => Container(
        width: double.infinity,
        height: 120,
        color: colorScheme.surfaceContainerHighest,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image_not_supported,
              size: 40,
              color: colorScheme.onSurface.withOpacity(0.3),
            ),
            const SizedBox(height: 8),
            Text(
              'Image not available',
              style: TextStyle(
                fontSize: 10,
                color: colorScheme.onSurface.withOpacity(0.5),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ));
    // <-- Add this closing parenthesis to fix the error
  }
}
