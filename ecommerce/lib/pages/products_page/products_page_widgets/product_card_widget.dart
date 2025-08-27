

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'highlighted_text_widget.dart';
import '../../../localization/app_localizations_helper.dart';
import '../../../providers/wishlist_provider.dart';
import '../../../providers/cart_provider.dart';
import '../../../models/product.dart';
import '../../../utils/app_colors.dart';

class ProductCardWidget extends StatelessWidget {
  final Product product;
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
    final Color badgeColor = categoryColors[product.category] ?? colorScheme.secondaryContainer;
    final IconData? badgeIcon = categoryIcons[product.category];

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
                    tag: 'product_image_${product.id}',
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12.0),
                        ),
                        color: isDark ? colorScheme.surfaceContainerHighest : colorScheme.secondaryContainer,
                      ),
                        child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12.0),
                        ),
                        child: ColorFiltered(
                          // use theme-derived tints instead of hard-coded greys
                          colorFilter: product.soldOut
                              ? ColorFilter.mode(colorScheme.onSurface.withOpacity(0.3), BlendMode.saturation)
                              : ColorFilter.mode(Colors.transparent, BlendMode.multiply),
                          child: _buildProductImage(product.image, colorScheme),
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
                            product.category.replaceAll('_', ' ').toUpperCase(),
                            style: TextStyle(
                              color: colorScheme.onSecondaryContainer,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                            semanticsLabel: 'Category: ${product.category.replaceAll('_', ' ')}',
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Discount badge
                  if (product.hasDiscount)
                    Positioned(
                      top: 6,
                      left: 38,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.error,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '-${product.discountPercentage.round()}%',
                          style: TextStyle(color: colorScheme.onError, fontSize: 9, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  // Best Seller badge
                  if (product.isBestSeller)
                    Positioned(
                      top: 30,
                      right: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.warning(context),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text('BEST SELLER', style: TextStyle(color: colorScheme.onPrimary, fontSize: 8, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  // New badge
                  if (product.isNew)
                    Positioned(
                      top: product.isBestSeller ? 50 : 30,
                      right: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.success(context),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text('NEW', style: TextStyle(color: colorScheme.onPrimary, fontSize: 8, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  // Stock status badge
                  if (product.stock <= 5 && product.stock > 0 && !product.soldOut)
                    Positioned(
                      top: product.isNew ? (product.isBestSeller ? 70 : 50) : (product.isBestSeller ? 50 : 30),
                      right: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.warning(context),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text('LOW STOCK (${product.stock})', style: TextStyle(color: colorScheme.onPrimary, fontSize: 7, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  // Wishlist Icon Button
                  Positioned(
                    top: 6,
                    left: 6,
                    child: Consumer<WishlistProvider>(
                      builder: (context, wishlistProvider, _) {
                        final isFavorite = wishlistProvider.wishlist.any((p) => p.id == product.id);
                        return Semantics(
                          label: isFavorite ? 'Remove from wishlist' : 'Add to wishlist',
                          button: true,
                          child: IconButton(
                            icon: Icon(
                              isFavorite ? Icons.favorite : Icons.favorite_border,
                              color: isFavorite ? Theme.of(context).colorScheme.error : colorScheme.onSurface.withOpacity(0.7),
                              size: 22,
                            ),
                            onPressed: () {
                              wishlistProvider.toggleWishlist(product);
                              
                              // Show visual feedback
                              final isNowFavorite = wishlistProvider.wishlist.any((p) => p.id == product.id);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      isNowFavorite 
                                          ? '${product.name} added to wishlist!' 
                                          : '${product.name} removed from wishlist!',
                                    ),
                                    duration: const Duration(seconds: 2),
                                    backgroundColor: isNowFavorite ? Theme.of(context).colorScheme.error : colorScheme.surfaceContainerHighest,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              }
                            },
                            tooltip: isFavorite ? 'Remove from wishlist' : 'Add to wishlist',
                          ),
                        );
                      },
                    ),
                  ),
                  // Out-of-stock badge overlay
                  if (product.soldOut)
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
                      child: Consumer<CartProvider>(
                        builder: (context, cartProvider, _) {
                          return IconButton(
                            icon: const Icon(Icons.add_shopping_cart, size: 18),
                            color: colorScheme.primary,
                            onPressed: product.soldOut ? null : () async {
                              try {
                                await cartProvider.addItem(product.toMap(), context: context);
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('${product.name} added to cart!'),
                                      duration: const Duration(seconds: 2),
                                      backgroundColor: colorScheme.primary,
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Error: ${e.toString()}'),
                                      duration: const Duration(seconds: 3),
                                      backgroundColor: colorScheme.error,
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                }
                              }
                            },
                            tooltip: 'Add to cart',
                          );
                        },
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
                      text: product.brand,
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
                        text: product.name,
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
                    // Size and Stock info
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _getDisplaySize(context),
                            style: TextStyle(fontSize: 10, color: colorScheme.onSurface.withOpacity(0.6)),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        if (!product.soldOut && product.stock > 0)
                          Text(
                            '${product.stock} left',
                            style: TextStyle(fontSize: 9, color: colorScheme.onSurface.withOpacity(0.5)),
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Price and Rating with review count
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (product.hasDiscount) ...[
                                Text(
                                  '\$${product.originalPrice!.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: colorScheme.onSurface.withOpacity(0.5),
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ],
                              Text(
                                '\$${product.price.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? colorScheme.primary : colorScheme.primary,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.star, color: AppColors.warning(context), size: 11),
                                Text(
                                  product.rating.toStringAsFixed(1),
                                  style: const TextStyle(fontSize: 10),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                            if (product.reviewCount > 0)
                              Text(
                                '(${product.reviewCount} reviews)',
                                style: TextStyle(
                                  fontSize: 8,
                                  color: colorScheme.onSurface.withOpacity(0.5),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                          ],
                        ),
                      ],
                    ),
                    // Key features preview (first feature if available)
                    if (product.features.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          '• ${product.features.first}',
                          style: TextStyle(
                            fontSize: 8,
                            color: colorScheme.onSurface.withOpacity(0.6),
                            fontStyle: FontStyle.italic,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
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
    if (product.size.isEmpty || product.size == 'Not specified') {
      return AppLocalizationsHelper.of(context).notSpecified;
    }
    return product.size;
  }

  // Helper method to build product image
  Widget _buildProductImage(String imagePath, ColorScheme colorScheme) {
    return Image.network(
      imagePath,
      fit: BoxFit.cover,
      width: double.infinity,
      height: 120,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return const Center(child: CircularProgressIndicator(strokeWidth: 2));
      },
      errorBuilder: (c, _, __) => _imageFallback(colorScheme),
    );
  }  Widget _imageFallback(ColorScheme colorScheme) => Container(
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
      );
}
