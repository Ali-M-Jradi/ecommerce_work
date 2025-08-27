import 'package:flutter/material.dart';
import 'products_page_config.dart';

class ProductsPageConstants {
  // Colors (theme-driven helpers)
  static Color primaryColor(BuildContext context) => Theme.of(context).colorScheme.primary;
  static Color primaryDarkColor(BuildContext context) => Theme.of(context).colorScheme.primary;
  static Color backgroundColor(BuildContext context) => Theme.of(context).colorScheme.background;
  static const Color whiteColor = Colors.white;

  // Spacing (using config values)
  static const double defaultPadding = ProductsPageConfig.defaultPadding;
  static const double cardSpacing = ProductsPageConfig.cardSpacing;
  static const double smallSpacing = ProductsPageConfig.smallSpacing;
  static const double fabSpacing = ProductsPageConfig.fabHideThreshold;
  static const double fabHideThreshold = 150.0; // Distance from bottom to hide FABs
  static const double fabHidePercentage = 0.85; // Hide when 85% scrolled

  // Text Styles
  static TextStyle appBarTitleStyle(BuildContext context) => TextStyle(
    color: Theme.of(context).colorScheme.onPrimary,
    fontSize: 20.0,
  );

  static TextStyle fabTextStyle(BuildContext context) => TextStyle(
    color: Theme.of(context).colorScheme.onPrimary,
    fontSize: 14,
  );

  // Grid Properties (using config values)
  static const int gridCrossAxisCount = ProductsPageConfig.gridCrossAxisCount;
  static const double gridChildAspectRatio = ProductsPageConfig.gridChildAspectRatio;
  static const double gridCrossAxisSpacing = ProductsPageConfig.gridCrossAxisSpacing;
  static const double gridMainAxisSpacing = ProductsPageConfig.gridMainAxisSpacing;

  // Icon Sizes
  static const double defaultIconSize = 18.0;

  // Default Sort Option
  static const String defaultSortOption = 'A to Z';

  // Available Sort Options
  static const List<String> sortOptions = [
    'A to Z',
    'Z to A',
    'Price Low to High',
    'Price High to Low',
  ];
}
