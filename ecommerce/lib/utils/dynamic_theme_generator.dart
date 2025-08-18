import 'package:flutter/material.dart';

/// Utility class to generate dynamic color schemes based on admin settings
class DynamicThemeGenerator {
  /// Generate a light color scheme from primary color
  static ColorScheme generateLightScheme({
    required Color primaryColor,
    Color? secondaryColor,
    Color? tertiaryColor,
  }) {
    final ColorScheme baseScheme = ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.light,
    );

    // Calculate harmonious colors based on primary
    final HSLColor primaryHsl = HSLColor.fromColor(primaryColor);
    
    // Generate secondary color if not provided
    Color finalSecondaryColor = secondaryColor ?? Color.fromARGB(
      255,
      ((primaryHsl.hue + 30) % 360 / 360 * 255).round(),
      (primaryHsl.saturation * 0.7 * 255).round(),
      ((primaryHsl.lightness + 0.1).clamp(0.0, 1.0) * 255).round(),
    );

    // Generate tertiary color if not provided
    Color finalTertiaryColor = tertiaryColor ?? Color.fromARGB(
      255,
      ((primaryHsl.hue + 60) % 360 / 360 * 255).round(),
      (primaryHsl.saturation * 0.6 * 255).round(),
      ((primaryHsl.lightness + 0.15).clamp(0.0, 1.0) * 255).round(),
    );

    return baseScheme.copyWith(
      primary: primaryColor,
      secondary: finalSecondaryColor,
      tertiary: finalTertiaryColor,
      primaryContainer: primaryColor.withOpacity(0.12),
      secondaryContainer: finalSecondaryColor.withOpacity(0.12),
      tertiaryContainer: finalTertiaryColor.withOpacity(0.12),
      // Status colors that adapt to theme
      error: _adaptStatusColor(Colors.red, primaryHsl),
      errorContainer: _adaptStatusColor(Colors.red, primaryHsl).withOpacity(0.12),
    );
  }

  /// Generate a dark color scheme from primary color
  static ColorScheme generateDarkScheme({
    required Color primaryColor,
    Color? secondaryColor,
    Color? tertiaryColor,
  }) {
    final ColorScheme baseScheme = ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.dark,
    );

    // Calculate harmonious colors for dark theme
    final HSLColor primaryHsl = HSLColor.fromColor(primaryColor);
    
    // Adjust primary color for dark theme (usually lighter)
    Color darkPrimaryColor = primaryHsl.withLightness(
      (primaryHsl.lightness + 0.2).clamp(0.0, 1.0)
    ).toColor();

    // Generate secondary color if not provided
    Color finalSecondaryColor = secondaryColor ?? Color.fromARGB(
      255,
      ((primaryHsl.hue + 30) % 360 / 360 * 255).round(),
      (primaryHsl.saturation * 0.8 * 255).round(),
      ((primaryHsl.lightness + 0.3).clamp(0.0, 1.0) * 255).round(),
    );

    // Generate tertiary color if not provided
    Color finalTertiaryColor = tertiaryColor ?? Color.fromARGB(
      255,
      ((primaryHsl.hue + 60) % 360 / 360 * 255).round(),
      (primaryHsl.saturation * 0.7 * 255).round(),
      ((primaryHsl.lightness + 0.35).clamp(0.0, 1.0) * 255).round(),
    );

    return baseScheme.copyWith(
      primary: darkPrimaryColor,
      secondary: finalSecondaryColor,
      tertiary: finalTertiaryColor,
      primaryContainer: darkPrimaryColor.withOpacity(0.3),
      secondaryContainer: finalSecondaryColor.withOpacity(0.3),
      tertiaryContainer: finalTertiaryColor.withOpacity(0.3),
      // Dark theme surfaces
      surface: const Color(0xFF121212),
      surfaceContainerHighest: const Color(0xFF1E1E1E),
      // Status colors that adapt to dark theme
      error: _adaptStatusColor(Colors.red, primaryHsl, isDark: true),
      errorContainer: _adaptStatusColor(Colors.red, primaryHsl, isDark: true).withOpacity(0.3),
    );
  }

  /// Adapt status colors (success, warning, error) to harmonize with theme
  static Color _adaptStatusColor(Color statusColor, HSLColor themeHsl, {bool isDark = false}) {
    final HSLColor statusHsl = HSLColor.fromColor(statusColor);
    
    // Adjust saturation to match theme saturation
    double newSaturation = (statusHsl.saturation + themeHsl.saturation) / 2;
    
    // Adjust lightness for dark/light theme
    double newLightness = isDark 
        ? (statusHsl.lightness + 0.2).clamp(0.0, 1.0)
        : (statusHsl.lightness - 0.1).clamp(0.0, 1.0);
    
    return statusHsl.withSaturation(newSaturation).withLightness(newLightness).toColor();
  }

  /// Generate success color that harmonizes with theme
  static Color getSuccessColor(Color primaryColor, {bool isDark = false}) {
    final HSLColor primaryHsl = HSLColor.fromColor(primaryColor);
    return _adaptStatusColor(Colors.green, primaryHsl, isDark: isDark);
  }

  /// Generate warning color that harmonizes with theme
  static Color getWarningColor(Color primaryColor, {bool isDark = false}) {
    final HSLColor primaryHsl = HSLColor.fromColor(primaryColor);
    return _adaptStatusColor(Colors.orange, primaryHsl, isDark: isDark);
  }

  /// Generate info color that harmonizes with theme
  static Color getInfoColor(Color primaryColor, {bool isDark = false}) {
    final HSLColor primaryHsl = HSLColor.fromColor(primaryColor);
    return _adaptStatusColor(Colors.blue, primaryHsl, isDark: isDark);
  }

  /// Create a complete theme data from color scheme
  static ThemeData createThemeData({
    required ColorScheme colorScheme,
    required String fontFamily,
    Color? primaryColor,
  }) {
    final bool isDark = colorScheme.brightness == Brightness.dark;
    
    return ThemeData(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      fontFamily: fontFamily,
      
      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor ?? colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        titleTextStyle: TextStyle(
          color: colorScheme.onPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 20,
          fontFamily: fontFamily,
        ),
        iconTheme: IconThemeData(color: colorScheme.onPrimary),
        actionsIconTheme: IconThemeData(color: colorScheme.onPrimary),
        elevation: 2,
      ),
      
      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor ?? colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 2,
          shadowColor: colorScheme.shadow,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor ?? colorScheme.primary,
          side: BorderSide(color: primaryColor ?? colorScheme.primary),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor ?? colorScheme.primary,
        ),
      ),
      
      // Card Theme
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        elevation: 1,
        shadowColor: colorScheme.shadow,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      
      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: primaryColor ?? colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.error, width: 2),
        ),
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest.withOpacity(0.5),
      ),
      
      // Floating Action Button Theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor ?? colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      
      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.surfaceContainerHighest,
        selectedColor: (primaryColor ?? colorScheme.primary).withOpacity(0.2),
        labelStyle: TextStyle(
          color: colorScheme.onSurfaceVariant,
          fontFamily: fontFamily,
        ),
        side: BorderSide(color: colorScheme.outline),
      ),
      
      // Switch Theme
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryColor ?? colorScheme.primary;
          }
          return colorScheme.outline;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return (primaryColor ?? colorScheme.primary).withOpacity(0.5);
          }
          return colorScheme.surfaceContainerHighest;
        }),
      ),
      
      // SnackBar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: isDark ? colorScheme.surface : colorScheme.inverseSurface,
        contentTextStyle: TextStyle(
          color: isDark ? colorScheme.onSurface : colorScheme.onInverseSurface,
          fontFamily: fontFamily,
        ),
        actionTextColor: primaryColor ?? colorScheme.primary,
      ),
      
      // Bottom Navigation Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        selectedItemColor: primaryColor ?? colorScheme.primary,
        unselectedItemColor: colorScheme.onSurfaceVariant,
        type: BottomNavigationBarType.fixed,
      ),
      
      // Navigation Bar Theme (Material 3)
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        indicatorColor: (primaryColor ?? colorScheme.primary).withOpacity(0.2),
        labelTextStyle: WidgetStateProperty.all(
          TextStyle(fontFamily: fontFamily, fontSize: 12),
        ),
      ),
      
      // Progress Indicator Theme
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: primaryColor ?? colorScheme.primary,
      ),
      
      // Divider Theme
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        thickness: 0.5,
      ),
    );
  }
}
