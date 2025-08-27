import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import 'dart:math' as math;

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
  // Semantic colors now always derive from brand/theme using theme and brand colors

  // Derive success from secondary but bias towards green hue
  return _deriveSemanticColor(context, base: AppColors.secondary(context), targetHue: 120);
  }

  /// Get warning color (orange variant)
  static Color warning(BuildContext context) {
  // derive warning from brand/theme

  // Derive a warning (orange) by shifting primary hue toward orange (30deg)
  return _deriveSemanticColor(context, base: AppColors.primary(context), targetHue: 30);
  }

  /// Get error color from theme
  static Color error(BuildContext context) {
  // derive error color from brand/theme

  // Derive error as strong red variant from primary
  return _deriveSemanticColor(context, base: AppColors.primary(context), targetHue: 0, makeStronger: true);
  }

  /// Get info color (blue variant)
  static Color info(BuildContext context) {
  // derive info color from brand/theme

    // Prefer tertiary if available, else derive a bluish tint from secondary
    final tertiary = AppColors.secondary(context);
    return _deriveSemanticColor(context, base: tertiary, targetHue: 210);
  }

  // Helper: derive a semantic color by shifting hue toward targetHue and ensuring sufficient contrast
  static Color _deriveSemanticColor(BuildContext context, {required Color base, required double targetHue, bool makeStronger = false}) {
    final hsl = HSLColor.fromColor(base);
    final shifted = hsl.withHue(targetHue).withSaturation((hsl.saturation + 0.15).clamp(0.0, 1.0));
    final adjusted = makeStronger ? shifted.withLightness((shifted.lightness * 0.85).clamp(0.0, 1.0)) : shifted;
    final candidate = adjusted.toColor();

    // Ensure contrast against surface
    final contrast = _contrastRatio(candidate, Theme.of(context).colorScheme.surface);
    if (contrast < 3.0) {
      // fallback to theme semantic defaults when candidate is too low contrast
      if (targetHue == 0) return Theme.of(context).colorScheme.error;
      if (targetHue == 120) return Theme.of(context).colorScheme.secondary;
      if (targetHue == 30) return lighten(AppColors.primary(context), 0.18);
      return Theme.of(context).colorScheme.primary;
    }
    return candidate;
  }

  // Contrast ratio helper (WCAG approximation)
  static double _luminance(Color c) {
    final r = _channel(c.red / 255);
    final g = _channel(c.green / 255);
    final b = _channel(c.blue / 255);
    return 0.2126 * r + 0.7152 * g + 0.0722 * b;
  }

  static double _channel(double c) => (c <= 0.03928) ? c / 12.92 : math.pow((c + 0.055) / 1.055, 2.4).toDouble();

  static double _contrastRatio(Color a, Color b) {
    final la = _luminance(a) + 0.05;
    final lb = _luminance(b) + 0.05;
    return (la > lb) ? la / lb : lb / la;
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
        return Theme.of(context).colorScheme.onSurface.withOpacity(0.6);
      case 'suspended':
        return error(context);
      case 'pending':
        return warning(context);
      default:
        return Theme.of(context).colorScheme.onSurface.withOpacity(0.6);
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
