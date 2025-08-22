import 'package:flutter/material.dart';

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
  static List<Widget> getStarIcons(double rating, {double size = 16.0}) {
    List<Widget> stars = [];
    int fullStars = rating.floor();
    bool hasHalfStar = (rating - fullStars) >= 0.5;
    
    // Add full stars
    for (int i = 0; i < fullStars; i++) {
      stars.add(Icon(
        Icons.star,
        color: Colors.amber,
        size: size,
      ));
    }
    
    // Add half star if needed
    if (hasHalfStar) {
      stars.add(Icon(
        Icons.star_half,
        color: Colors.amber,
        size: size,
      ));
    }
    
    // Add empty stars to make it 5 total
    int remainingStars = 5 - fullStars - (hasHalfStar ? 1 : 0);
    for (int i = 0; i < remainingStars; i++) {
      stars.add(Icon(
        Icons.star_border,
        color: Colors.grey,
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
  static Color getPriceColor(double price) {
    if (price > 100) return Colors.red.shade700;
    if (price > 50) return Colors.orange.shade700;
    return Colors.green.shade700;
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
  static Widget getPlaceholderImage({double? width, double? height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Icon(
        Icons.image_not_supported,
        color: Colors.grey.shade400,
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
