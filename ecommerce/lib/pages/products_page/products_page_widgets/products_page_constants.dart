import 'package:flutter/material.dart';
import 'products_page_config.dart';

class ProductsPageConstants {
  // Colors
  static final Color primaryColor = Colors.deepPurpleAccent.shade700;
  static final Color primaryDarkColor = Colors.deepPurple.shade800;
  static final Color backgroundColor = Colors.grey.shade50;
  static const Color whiteColor = Colors.white;

  // Spacing (using config values)
  static const double defaultPadding = ProductsPageConfig.defaultPadding;
  static const double cardSpacing = ProductsPageConfig.cardSpacing;
  static const double smallSpacing = ProductsPageConfig.smallSpacing;
  static const double fabSpacing = ProductsPageConfig.fabHideThreshold;
  static const double fabHideThreshold = 150.0; // Distance from bottom to hide FABs
  static const double fabHidePercentage = 0.85; // Hide when 85% scrolled

  // Text Styles
  static const TextStyle appBarTitleStyle = TextStyle(
    color: Colors.white,
    fontSize: 20.0,
  );

  static const TextStyle fabTextStyle = TextStyle(
    color: Colors.white,
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
