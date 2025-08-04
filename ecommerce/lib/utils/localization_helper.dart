import 'package:flutter/material.dart';

/// Helper class for managing localized content in the application
class LocalizationHelper {
  /// Get the localized string value from a map containing language code keys
  static String getLocalizedString(Map<String, dynamic> map, BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    
    // Try to get string for the current locale
    if (map.containsKey(locale)) {
      return map[locale];
    }
    
    // Fall back to English if current locale is not available
    if (map.containsKey('en')) {
      return map['en'];
    }
    
    // Return the first value as a last resort
    return map.values.first;
  }
  
  /// Check if the current locale is RTL
  static bool isRTL(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    return locale == 'ar';
  }
  
  /// Get a product field that might be localized
  /// If the field is a Map with language codes, get the appropriate value
  /// Otherwise return the original value
  static dynamic getLocalizedProductField(dynamic field, BuildContext context) {
    if (field is Map<String, dynamic>) {
      return getLocalizedString(field, context);
    }
    return field;
  }
  
  /// Format price based on the current locale (RTL/LTR handling)
  static String formatPrice(String price, BuildContext context, {String? currency}) {
    final currencySymbol = currency ?? '\$';
    final isRightToLeft = isRTL(context);
    
    if (isRightToLeft) {
      return '${price.trim()} $currencySymbol';
    } else {
      return '$currencySymbol${price.trim()}';
    }
  }
  
  /// Apply RTL-aware padding
  static EdgeInsetsDirectional getDirectionalPadding({
    required BuildContext context,
    double? start,
    double? end,
    double? top,
    double? bottom,
  }) {
    return EdgeInsetsDirectional.fromSTEB(
      start ?? 0, 
      top ?? 0, 
      end ?? 0, 
      bottom ?? 0
    );
  }
  
  /// Apply RTL-aware margin
  static EdgeInsetsDirectional getDirectionalMargin({
    required BuildContext context,
    double? start,
    double? end,
    double? top,
    double? bottom,
  }) {
    return EdgeInsetsDirectional.fromSTEB(
      start ?? 0, 
      top ?? 0, 
      end ?? 0, 
      bottom ?? 0
    );
  }
  
  /// Get RTL-aware alignment
  static Alignment getStartAlignment(BuildContext context) {
    return isRTL(context) ? Alignment.centerRight : Alignment.centerLeft;
  }
  
  /// Get RTL-aware alignment
  static Alignment getEndAlignment(BuildContext context) {
    return isRTL(context) ? Alignment.centerLeft : Alignment.centerRight;
  }
}
