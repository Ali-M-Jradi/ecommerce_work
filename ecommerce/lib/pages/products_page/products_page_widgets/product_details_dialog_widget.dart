import 'package:flutter/material.dart';
import '../../../utils/app_colors.dart';
import 'package:provider/provider.dart';
import '../../../providers/cart_provider.dart';
import '../../cart_page/cart_page.dart';
import '../../../main.dart'; // Import to access navigatorKey
import 'star_rating_widget.dart';
import '../../../localization/app_localizations_helper.dart';
import '../../../models/product.dart';

class ProductDetailsDialogWidget extends StatefulWidget {
  final Product product;

  const ProductDetailsDialogWidget({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailsDialogWidget> createState() => _ProductDetailsDialogWidgetState();
}

class _ProductDetailsDialogWidgetState extends State<ProductDetailsDialogWidget> {
  double userRating = 0.0; // Local rating for this product

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 600),
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Images Gallery
              SizedBox(
                height: 220,
                child: PageView.builder(
                  itemCount: widget.product.images.isNotEmpty ? widget.product.images.length : 1,
                  controller: PageController(viewportFraction: 0.9),
                  itemBuilder: (context, index) {
                    final imageUrl = widget.product.images.isNotEmpty 
                        ? widget.product.images[index] 
                        : widget.product.image;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: Container(
                          color: colorScheme.surfaceContainerHighest,
                          child: _buildProductImage(imageUrl, colorScheme),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              
              // Header with Brand, Badges, and Status
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Brand
                        Text(
                          widget.product.brand,
                          style: TextStyle(
                            fontSize: 14,
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // SKU
                        if (widget.product.sku.isNotEmpty)
                          Text(
                            'SKU: ${widget.product.sku}',
                            style: TextStyle(
                              fontSize: 12,
                              color: colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                      ],
                    ),
                  ),
                  // Status badges
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (widget.product.isNew)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: colorScheme.tertiary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text('NEW', style: TextStyle(color: colorScheme.onTertiary, fontSize: 10, fontWeight: FontWeight.bold)),
                        ),
                      if (widget.product.isBestSeller) ...[
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: colorScheme.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text('BEST SELLER', style: TextStyle(color: colorScheme.onPrimary, fontSize: 10, fontWeight: FontWeight.bold)),
                        ),
                      ],
                      if (widget.product.isFeatured) ...[
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: colorScheme.secondary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text('FEATURED', style: TextStyle(color: colorScheme.onSecondary, fontSize: 10, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              
              // Product Name
              Text(
                widget.product.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              
              // Category and Size
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      widget.product.category.replaceAll('_', ' ').toUpperCase(),
                      style: TextStyle(
                        color: colorScheme.onPrimaryContainer,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (widget.product.size.isNotEmpty && widget.product.size != 'Not specified')
                    Text(
                      'Size: ${widget.product.size}',
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Price Section with Discount
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (widget.product.hasDiscount) ...[
                    Text(
                      '\$${widget.product.originalPrice!.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 16,
                        color: colorScheme.onSurface.withOpacity(0.5),
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: colorScheme.error,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '-${widget.product.discountPercentage.round()}%',
                          style: TextStyle(color: colorScheme.onError, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    '\$${widget.product.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Rating and Reviews
              Row(
                children: [
                  Row(
                    children: List.generate(5, (index) => Icon(
                      index < widget.product.rating.floor() ? Icons.star : Icons.star_border,
                      color: AppColors.warning(context),
                      size: 16,
                    )),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.product.rating.toStringAsFixed(1),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  if (widget.product.reviewCount > 0) ...[
                    const SizedBox(width: 4),
                    Text(
                      '(${widget.product.reviewCount} reviews)',
                      style: TextStyle(
                        fontSize: 14,
                        color: colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 16),
              
              // Stock Information
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                  color: widget.product.soldOut 
                      ? colorScheme.errorContainer
                      : widget.product.stock <= 5 
                          ? AppColors.warning(context).withOpacity(0.12)
                          : colorScheme.primaryContainer.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      widget.product.soldOut 
                          ? Icons.remove_shopping_cart 
                          : widget.product.stock <= 5 
                              ? Icons.warning 
                              : Icons.check_circle,
                      size: 16,
                    color: widget.product.soldOut 
                          ? AppColors.error(context) 
                          : widget.product.stock <= 5 
                            ? AppColors.warning(context) 
                            : colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.product.stockStatus,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
            color: widget.product.soldOut 
              ? AppColors.error(context) 
              : colorScheme.onSurface,
                      ),
                    ),
                    if (!widget.product.soldOut && widget.product.stock > 0) ...[
                      const Spacer(),
                      Text(
                        '${widget.product.stock} available',
                        style: TextStyle(
                          fontSize: 12,
                          color: colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              
              // Available Colors
              if (widget.product.colors.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  'Available Colors',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: widget.product.colors.map((color) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      color,
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSecondaryContainer,
                      ),
                    ),
                  )).toList(),
                ),
              ],
              
              // Available Sizes
              if (widget.product.sizes.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  'Available Sizes',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: widget.product.sizes.map((size) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: colorScheme.tertiaryContainer,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      size,
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onTertiaryContainer,
                      ),
                    ),
                  )).toList(),
                ),
              ],
              
              // Description
              if (widget.product.description.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  'Description',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.product.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: colorScheme.onSurface.withOpacity(0.8),
                    height: 1.4,
                  ),
                ),
              ],
              
              // Features
              if (widget.product.features.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  'Key Features',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                ...widget.product.features.map((feature) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 6),
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          feature,
                          style: TextStyle(
                            fontSize: 13,
                            color: colorScheme.onSurface.withOpacity(0.8),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
              ],
              
              // Specifications
              if (widget.product.specifications.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  'Specifications',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: widget.product.specifications.entries.map((spec) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 100,
                            child: Text(
                              spec.key,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: colorScheme.onSurface.withOpacity(0.7),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              spec.value,
                              style: TextStyle(
                                fontSize: 12,
                                color: colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )).toList(),
                  ),
                ),
              ],
              
              const SizedBox(height: 20),
              
              // User Rating Section
              Text(
                AppLocalizationsHelper.of(context).rateThisProduct,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                AppLocalizationsHelper.of(context).ratingInstructions,
                style: TextStyle(
                  fontSize: 12,
                  color: colorScheme.onSurface.withOpacity(0.6),
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 12),
              
              // Interactive Star Rating
              Center(
                child: StarRatingWidget(
                  currentRating: userRating,
                  onRatingChanged: (rating) {
                    setState(() {
                      userRating = rating;
                    });
                  },
                ),
              ),
              const SizedBox(height: 8),
              
              // Rating Text
              Center(
                child: Text(
                  userRating == 0.0 
                      ? AppLocalizationsHelper.of(context).noRatingSelected
                      : AppLocalizationsHelper.of(context).yourRating(
                          userRating.toString(), 
                          userRating == 1.0 
                            ? AppLocalizationsHelper.of(context).star 
                            : AppLocalizationsHelper.of(context).stars
                        ),
                  style: TextStyle(
                    fontSize: 14,
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // Submit Rating Button (only show if user has rated)
              if (userRating > 0.0)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      final colorScheme = Theme.of(context).colorScheme;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            AppLocalizationsHelper.of(context).ratingSubmitted(userRating.toString()),
                            style: TextStyle(color: colorScheme.onSurface),
                          ),
                          backgroundColor: colorScheme.surface,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      AppLocalizationsHelper.of(context).submitRating,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              if (userRating > 0.0) const SizedBox(height: 12),
              
              // Sold Out or Add to Cart
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: widget.product.soldOut ? null : () async {
                    try {
                      // Add to cart using CartProvider
                      final cartProvider = Provider.of<CartProvider>(context, listen: false);
                      await cartProvider.addItem(widget.product.toMap(), context: context);
                      
                      // Pop the dialog first
                      Navigator.of(context).pop();
                      
                      // Show success snackbar
                      final colorScheme = Theme.of(context).colorScheme;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            AppLocalizationsHelper.of(context).addedToCart(widget.product.name),
                            style: TextStyle(color: colorScheme.onSurface),
                          ),
                          backgroundColor: colorScheme.surface,
                          duration: const Duration(seconds: 4),
                          action: SnackBarAction(
                            label: AppLocalizationsHelper.of(context).viewCart,
                            textColor: colorScheme.primary,
                            onPressed: () {
                              // Use the global navigator key for guaranteed navigation
                              navigatorKey.currentState?.push(
                                MaterialPageRoute(
                                  builder: (context) => const CartPage(),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    } catch (e) {
                      // Show parameter validation error
                      final colorScheme = Theme.of(context).colorScheme;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            e.toString(),
                            style: TextStyle(color: colorScheme.onError),
                          ),
                          backgroundColor: colorScheme.error,
                          duration: const Duration(seconds: 3),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.product.soldOut 
                        ? colorScheme.onSurface.withOpacity(0.12)
                        : colorScheme.primary,
                    foregroundColor: widget.product.soldOut ? colorScheme.onSurface : colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    widget.product.soldOut 
                      ? AppLocalizationsHelper.of(context).soldOut 
                      : AppLocalizationsHelper.of(context).addToCart,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              
              // Close Button
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Builder(
                    builder: (context) {
                      final colorScheme = Theme.of(context).colorScheme;
                      return Text(
                        AppLocalizationsHelper.of(context).closeDialog,
                        style: TextStyle(
                          color: colorScheme.primary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Unified helper to load images from network with a safe fallback
  Widget _buildProductImage(String imagePath, ColorScheme colorScheme) {
    final path = imagePath.trim();
    if (path.isEmpty) {
      return _imageFallback(colorScheme);
    }
    
    return Image.network(
      path,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return const Center(child: CircularProgressIndicator(strokeWidth: 2));
      },
      errorBuilder: (c, _, __) => _imageFallback(colorScheme),
    );
  }

  Widget _imageFallback(ColorScheme colorScheme) => Center(
        child: Icon(
          Icons.image_not_supported,
          size: 40,
          color: colorScheme.onSurface.withOpacity(0.3),
        ),
      );
}
