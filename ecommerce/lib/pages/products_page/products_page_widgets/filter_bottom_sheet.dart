import 'package:flutter/material.dart';
import '../../../localization/app_localizations_helper.dart';
import 'products_page_service.dart';

class FilterBottomSheet extends StatefulWidget {
  final String? selectedCategory;
  final String? selectedBrand;
  final double? minPrice;
  final double? maxPrice;
  final double? minRating;
  final bool? showOnlyInStock;
  final Function(Map<String, dynamic>) onApplyFilters;

  const FilterBottomSheet({
    super.key,
    this.selectedCategory,
    this.selectedBrand,
    this.minPrice,
    this.maxPrice,
    this.minRating,
    this.showOnlyInStock,
    required this.onApplyFilters,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  String? _selectedCategory;
  String? _selectedBrand;
  RangeValues _priceRange = const RangeValues(0, 100);
  double _minRating = 0;
  bool _showOnlyInStock = false;

  late List<String> _categories;

  final List<String> _brands = [
    'All Brands',
    'Avène',
    'La Roche-Posay',
    'Vichy',
    'Eucerin',
    'CeraVe',
    'Neutrogena',
  ];

  @override
  void initState() {
    super.initState();
    
    // Initialize categories list dynamically
    final availableCategories = ProductsPageService().getAvailableCategories();
    _categories = ['All Categories', ...availableCategories];
    
    _selectedCategory = widget.selectedCategory ?? 'All Categories';
    _selectedBrand = widget.selectedBrand ?? 'All Brands';
    _priceRange = RangeValues(
      widget.minPrice ?? 0,
      widget.maxPrice ?? 100,
    );
    _minRating = widget.minRating ?? 0;
    _showOnlyInStock = widget.showOnlyInStock ?? false;
  }

  String _getCategoryDisplayName(BuildContext context, String category) {
    switch (category) {
      case 'All Categories':
        return AppLocalizationsHelper.of(context).allCategories;
      case 'face_care':
        return AppLocalizationsHelper.of(context).categoryFaceCare;
      case 'body_care':
        return AppLocalizationsHelper.of(context).categoryBodyCare;
      case 'hair_care':
        return AppLocalizationsHelper.of(context).categoryHairCare;
      default:
        // For any new categories that don't have localization yet,
        // format them nicely (replace underscores with spaces and capitalize)
        return category.replaceAll('_', ' ')
            .split(' ')
            .map((word) => word.isNotEmpty 
                ? word[0].toUpperCase() + word.substring(1).toLowerCase()
                : word)
            .join(' ');
    }
  }

  String _getBrandDisplayName(BuildContext context, String brand) {
    switch (brand) {
      case 'All Brands':
        return AppLocalizationsHelper.of(context).allBrandsFilter;
      default:
        return brand; // Keep brand names in English
    }
  }

  String _getCategoryValue(String category) {
    // Since we're now using database values directly, just return as-is
    // except for the "All Categories" case
    return category == 'All Categories' ? '' : category;
  }

  void _applyFilters() {
    final filters = <String, dynamic>{
      'category': _selectedCategory == 'All Categories' || _selectedCategory == null 
          ? null 
          : _getCategoryValue(_selectedCategory!),
      'brand': _selectedBrand == 'All Brands' || _selectedBrand == null 
          ? null 
          : _selectedBrand,
      'minPrice': _priceRange.start,
      'maxPrice': _priceRange.end,
      'minRating': _minRating,
      'showOnlyInStock': _showOnlyInStock,
    };
    
    widget.onApplyFilters(filters);
    Navigator.pop(context);
  }

  void _clearFilters() {
    setState(() {
      _selectedCategory = 'All Categories';
      _selectedBrand = 'All Brands';
      _priceRange = const RangeValues(0, 100);
      _minRating = 0;
      _showOnlyInStock = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? colorScheme.surface : colorScheme.surfaceVariant,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizationsHelper.of(context).filtersTitle,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? colorScheme.onSurface : colorScheme.primary,
                ),
              ),
              TextButton(
                onPressed: _clearFilters,
                child: Text(
                  AppLocalizationsHelper.of(context).clearAll,
                  style: TextStyle(
                    color: isDark ? colorScheme.primary : colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Category Filter
          Text(
            AppLocalizationsHelper.of(context).categoryFilter,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDark ? colorScheme.onSurface : Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: _categories.map((category) {
              final isSelected = _selectedCategory == category;
              return FilterChip(
                label: Text(
                  _getCategoryDisplayName(context, category),
                  style: TextStyle(
                    color: isSelected
                        ? (isDark ? colorScheme.onPrimary : colorScheme.onPrimary)
                        : (isDark ? colorScheme.onSurface : colorScheme.onSurface),
                  ),
                ),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    _selectedCategory = category;
                  });
                },
                selectedColor: isDark ? colorScheme.primary : colorScheme.primary,
                backgroundColor: isDark ? colorScheme.surfaceVariant : colorScheme.surfaceVariant,
                checkmarkColor: isDark ? colorScheme.onPrimary : colorScheme.onPrimary,
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // Brand Filter
          Text(
            AppLocalizationsHelper.of(context).brandFilter,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDark ? colorScheme.onSurface : Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: _brands.map((brand) {
              final isSelected = _selectedBrand == brand;
              return FilterChip(
                label: Text(
                  _getBrandDisplayName(context, brand),
                  style: TextStyle(
                    color: isSelected
                        ? (isDark ? colorScheme.onPrimary : colorScheme.onPrimary)
                        : (isDark ? colorScheme.onSurface : colorScheme.onSurface),
                  ),
                ),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    _selectedBrand = brand;
                  });
                },
                selectedColor: isDark ? colorScheme.primary : colorScheme.primary,
                backgroundColor: isDark ? colorScheme.surfaceVariant : colorScheme.surfaceVariant,
                checkmarkColor: isDark ? colorScheme.onPrimary : colorScheme.onPrimary,
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // Price Range Filter
          Text(
            AppLocalizationsHelper.of(context).priceRange(_priceRange.start.round(), _priceRange.end.round()),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDark ? colorScheme.onSurface : colorScheme.onSurface,
            ),
          ),
          RangeSlider(
            values: _priceRange,
            min: 0,
            max: 100,
            divisions: 20,
            activeColor: isDark ? colorScheme.primary : colorScheme.primary,
            inactiveColor: isDark ? colorScheme.outlineVariant : colorScheme.outlineVariant,
            onChanged: (values) {
              setState(() {
                _priceRange = values;
              });
            },
          ),
          const SizedBox(height: 20),

          // Rating Filter
          Text(
            AppLocalizationsHelper.of(context).minimumRating(_minRating.toStringAsFixed(1)),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDark ? colorScheme.onSurface : Colors.grey.shade700,
            ),
          ),
          Slider(
            value: _minRating,
            min: 0,
            max: 5,
            divisions: 10,
            activeColor: isDark ? colorScheme.primary : colorScheme.primary,
            inactiveColor: isDark ? colorScheme.outlineVariant : colorScheme.outlineVariant,
            onChanged: (value) {
              setState(() {
                _minRating = value;
              });
            },
          ),
          const SizedBox(height: 20),

          // Stock Filter
          CheckboxListTile(
            title: Text(
              AppLocalizationsHelper.of(context).showOnlyInStock,
              style: TextStyle(color: isDark ? colorScheme.onSurface : null),
            ),
            value: _showOnlyInStock,
            onChanged: (value) {
              setState(() {
                _showOnlyInStock = value ?? false;
              });
            },
            activeColor: isDark ? colorScheme.primary : colorScheme.primary,
            checkColor: isDark ? colorScheme.onPrimary : colorScheme.onPrimary,
            controlAffinity: ListTileControlAffinity.leading,
          ),
          const SizedBox(height: 30),

          // Apply Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _applyFilters,
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark ? colorScheme.primary : colorScheme.primary,
                foregroundColor: isDark ? colorScheme.onPrimary : colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                AppLocalizationsHelper.of(context).applyFilters,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
