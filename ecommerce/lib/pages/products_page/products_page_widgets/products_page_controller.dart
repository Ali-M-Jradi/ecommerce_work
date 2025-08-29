import 'package:flutter/material.dart';
import 'dart:async';
import 'products_page_constants.dart';

/// Controller class for managing Products Page state and logic
class ProductsPageController {
  final ScrollController scrollController = ScrollController();
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  Timer? _debounceTimer;
  
  String _sortBy = 'A to Z';
  bool _isGridView = true;
  bool _showFloatingButtons = true;
  String? _category;
  // Support multiple categories
  Set<String> _selectedCategories = {};
  Set<String> _selectedBrands = {};
  String _searchQuery = '';
  
  // Additional filter properties
  String? _selectedBrand;
  double? _minPrice;
  double? _maxPrice;
  double? _minRating;
  bool _showOnlyInStock = false;

  // Getters
  String get sortBy => _sortBy;
  bool get isGridView => _isGridView;
  bool get showFloatingButtons => _showFloatingButtons;
  String? get category => _category;
  List<String> get selectedCategories => List.unmodifiable(_selectedCategories);
  List<String> get selectedBrands => List.unmodifiable(_selectedBrands);
  String get searchQuery => _searchQuery;
  String? get selectedBrand => _selectedBrand;
  double? get minPrice => _minPrice;
  double? get maxPrice => _maxPrice;
  double? get minRating => _minRating;
  bool get showOnlyInStock => _showOnlyInStock;

  bool get hasActiveFilters {
    return _selectedBrand != null ||
           _minPrice != null ||
           _maxPrice != null ||
           _minRating != null ||
           _showOnlyInStock;
  }

  // State change callbacks
  VoidCallback? _onStateChanged;

  ProductsPageController({VoidCallback? onStateChanged, String? category}) {
    _onStateChanged = onStateChanged;
    // If caller provided a classifier key (contains underscore), treat it as an initial selected category
    if (category != null && category.isNotEmpty) {
      // If category is non-numeric (e.g. 'makeup' or 'face_care'), treat it as a classifier key
      final parsed = int.tryParse(category);
      if (parsed == null) {
        _selectedCategories = {category};
        _category = null;
      } else {
        _category = category;
      }
    }
    scrollController.addListener(_scrollListener);
  }

  void dispose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    searchController.dispose();
    searchFocusNode.dispose();
    _debounceTimer?.cancel();
  }

  void focusSearch() {
    searchFocusNode.requestFocus();
  }

  void _scrollListener() {
    // Hide floating buttons when near the bottom (footer area)
    if (scrollController.hasClients) {
      final maxScroll = scrollController.position.maxScrollExtent;
      final currentScroll = scrollController.offset;
      
      // Calculate threshold based on constants for better responsiveness
      final threshold = maxScroll - ProductsPageConstants.fabHideThreshold;
      final percentageScrolled = maxScroll > 0 ? currentScroll / maxScroll : 0.0;
      
      // Check if user has scrolled to the very bottom (within 10px)
      final atBottom = (maxScroll - currentScroll) <= 10.0;
      
      // Hide buttons if close to bottom OR if scrolled more than specified percentage OR at bottom
      final newShowFloatingButtons = !atBottom && 
                                   currentScroll < threshold && 
                                   percentageScrolled < ProductsPageConstants.fabHidePercentage;
      
      if (_showFloatingButtons != newShowFloatingButtons) {
        _showFloatingButtons = newShowFloatingButtons;
        _onStateChanged?.call();
      }
    }
  }

  void updateSortBy(String newSortBy) {
    if (_sortBy != newSortBy) {
      _sortBy = newSortBy;
      _onStateChanged?.call();
    }
  }

  void updateViewMode(bool isGrid) {
    if (_isGridView != isGrid) {
      _isGridView = isGrid;
      _onStateChanged?.call();
    }
  }

  void updateSearchQuery(String query) {
    // Cancel previous timer
    _debounceTimer?.cancel();
    
    // Debounce the actual search to avoid too many rebuilds
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      String trimmedQuery = query.trim();
      
      if (_searchQuery != trimmedQuery) {
        _searchQuery = trimmedQuery;
        _onStateChanged?.call();
      }
    });
  }

  void clearSearch() {
    _debounceTimer?.cancel();
    
    if (_searchQuery.isNotEmpty || searchController.text.isNotEmpty) {
      _searchQuery = '';
      searchController.clear();
      _onStateChanged?.call();
    }
  }

  void updateFilters(Map<String, dynamic> filters) {
    bool hasChanges = false;
    
    // Handle backward compatible 'category' (single) or 'categories' (multi)
    final newCategories = <String>{};
    if (filters.containsKey('categories') && filters['categories'] is List) {
      newCategories.addAll((filters['categories'] as List).map((e) => e?.toString() ?? '').where((s) => s.isNotEmpty));
    } else if (filters['category'] != null && (filters['category'] as String).isNotEmpty) {
      newCategories.add(filters['category'] as String);
    }
    if (!_setEquals(_selectedCategories, newCategories)) {
      _selectedCategories = newCategories;
      hasChanges = true;
    }

    // Handle brands (multi-select)
    final newBrands = <String>{};
    if (filters.containsKey('brands') && filters['brands'] is List) {
      newBrands.addAll((filters['brands'] as List).map((e) => e?.toString() ?? '').where((s) => s.isNotEmpty));
    } else if (filters['brand'] != null && (filters['brand'] as String).isNotEmpty) {
      newBrands.add(filters['brand'] as String);
    }
    if (!_setEquals(_selectedBrands, newBrands)) {
      _selectedBrands = newBrands;
      hasChanges = true;
    }
    
    if (_selectedBrand != filters['brand']) {
      _selectedBrand = filters['brand'];
      hasChanges = true;
    }
    
    if (_minPrice != filters['minPrice']) {
      _minPrice = filters['minPrice'];
      hasChanges = true;
    }
    
    if (_maxPrice != filters['maxPrice']) {
      _maxPrice = filters['maxPrice'];
      hasChanges = true;
    }
    
    if (_minRating != filters['minRating']) {
      _minRating = filters['minRating'];
      hasChanges = true;
    }
    
    if (_showOnlyInStock != filters['showOnlyInStock']) {
      _showOnlyInStock = filters['showOnlyInStock'] ?? false;
      hasChanges = true;
    }
    
    if (hasChanges) {
      _onStateChanged?.call();
    }
  }

  void clearAllFilters() {
    bool hasChanges = false;
    
    if (_selectedCategories.isNotEmpty) {
      _selectedCategories.clear();
      hasChanges = true;
    }

    if (_selectedBrand != null) {
      _selectedBrand = null;
      hasChanges = true;
    }
    
    if (_minPrice != null) {
      _minPrice = null;
      hasChanges = true;
    }
    
    if (_maxPrice != null) {
      _maxPrice = null;
      hasChanges = true;
    }
    
    if (_minRating != null) {
      _minRating = null;
      hasChanges = true;
    }
    
    if (_showOnlyInStock) {
      _showOnlyInStock = false;
      hasChanges = true;
    }
    
    if (hasChanges) {
      _onStateChanged?.call();
    }
  }

  bool _setEquals(Set a, Set b) {
    if (a.length != b.length) return false;
    for (final v in a) {
      if (!b.contains(v)) return false;
    }
    return true;
  }
}
