import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

/// Utility class for consistent color usage throughout the app
class AppColors {
  /// Get the current theme's primary color
  static Color primary(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    return themeProvider.getPrimaryColor(context);
  }

  /// Get the current theme's secondary color
  static Color secondary(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    return themeProvider.getSecondaryColor(context);
  }

  /// Get success color (green variant)
  static Color success(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark 
        ? Colors.green.shade400 
        : Colors.green.shade600;
  }

  /// Get warning color (orange variant)
  static Color warning(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark 
        ? Colors.orange.shade400 
        : Colors.orange.shade600;
  }

  /// Get error color from theme
  static Color error(BuildContext context) {
    return Theme.of(context).colorScheme.error;
  }

  /// Get info color (blue variant)
  static Color info(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark 
        ? Colors.blue.shade400 
        : Colors.blue.shade600;
  }

  /// Get accent color (harmonious with primary/secondary colors)
  static Color accent(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final primaryColor = themeProvider.getPrimaryColor(context);
    
    // Create a harmonious accent color by adjusting the primary color's hue
    final hsl = HSLColor.fromColor(primaryColor);
    final accentHsl = hsl.withHue((hsl.hue + 60) % 360); // Complementary hue
    return accentHsl.toColor();
  }

  /// Status colors for user roles
  static Color getRoleColor(String role, BuildContext context) {
    switch (role.toLowerCase()) {
      case 'admin':
        return error(context);
      case 'moderator':
        return warning(context);
      case 'customer':
      default:
        return info(context);
    }
  }

  /// Status colors for user status
  static Color getStatusColor(String status, BuildContext context) {
    switch (status.toLowerCase()) {
      case 'active':
        return success(context);
      case 'inactive':
        return Colors.grey;
      case 'suspended':
        return error(context);
      case 'pending':
        return warning(context);
      default:
        return Colors.grey;
    }
  }

  /// Get surface color with elevation tint
  static Color getSurfaceColor(BuildContext context, {double elevation = 0}) {
    final base = Theme.of(context).colorScheme.surface;
    if (elevation == 0) return base;
    
    final primary = AppColors.primary(context);
    final tintAmount = (elevation / 24).clamp(0.0, 1.0) * 0.05;
    return Color.lerp(base, primary, tintAmount) ?? base;
  }

  /// Get a lighter variant of any color
  static Color lighten(Color color, [double amount = 0.1]) {
    final hsl = HSLColor.fromColor(color);
    final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
    return hslLight.toColor();
  }

  /// Get a darker variant of any color
  static Color darken(Color color, [double amount = 0.1]) {
    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }
}
