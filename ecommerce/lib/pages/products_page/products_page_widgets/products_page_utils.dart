import 'package:flutter/material.dart';
import '../../../utils/app_colors.dart';

/// Utility functions for the Products Page
class ProductsPageUtils {
  /// Format price with currency symbol
  static String formatPrice(double price) {
    return '\$${price.toStringAsFixed(2)}';
  }

  /// Format rating to show one decimal place
  static String formatRating(double rating) {
    return rating.toStringAsFixed(1);
  }

  /// Get star icons for rating display
  static List<Widget> getStarIcons(BuildContext context, double rating, {double size = 16.0}) {
    List<Widget> stars = [];
    int fullStars = rating.floor();
    bool hasHalfStar = (rating - fullStars) >= 0.5;
    
    // Add full stars
    for (int i = 0; i < fullStars; i++) {
      stars.add(Icon(
        Icons.star,
        color: AppColors.warning(context),
        size: size,
      ));
    }
    
    // Add half star if needed
    if (hasHalfStar) {
      stars.add(Icon(
        Icons.star_half,
        color: AppColors.warning(context),
        size: size,
      ));
    }
    
    // Add empty stars to make it 5 total
    int remainingStars = 5 - fullStars - (hasHalfStar ? 1 : 0);
    for (int i = 0; i < remainingStars; i++) {
      stars.add(Icon(
        Icons.star_border,
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
        size: size,
      ));
    }
    
    return stars;
  }

  /// Truncate text to specified length
  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  /// Get appropriate color for price based on value
  static Color getPriceColor(BuildContext context, double price) {
    if (price > 100) return AppColors.error(context);
    if (price > 50) return AppColors.warning(context);
    return AppColors.success(context);
  }

  /// Show snackbar with message
  static void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Validate product data
  static bool isValidProduct(Map<String, dynamic> product) {
    return product.containsKey('name') &&
           product.containsKey('price') &&
           product['name'] != null &&
           product['price'] != null;
  }

  /// Get placeholder image widget
  static Widget getPlaceholderImage(BuildContext context, {double? width, double? height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Icon(
        Icons.image_not_supported,
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
        size: 48.0,
      ),
    );
  }

  /// Get optimized hero tag for widgets
  static String getHeroTag(String prefix, int index) {
    return '${prefix}_$index';
  }

  /// Calculate discount percentage
  static double calculateDiscountPercentage(double originalPrice, double discountedPrice) {
    if (originalPrice <= 0) return 0.0;
    return ((originalPrice - discountedPrice) / originalPrice) * 100;
  }

  /// Format discount percentage
  static String formatDiscountPercentage(double percentage) {
    return '${percentage.toStringAsFixed(0)}% OFF';
  }
}
