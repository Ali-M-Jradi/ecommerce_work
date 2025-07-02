import 'package:flutter/material.dart';
import 'products_page_constants.dart';

/// Controller class for managing Products Page state and logic
class ProductsPageController {
  final ScrollController scrollController = ScrollController();
  
  String _sortBy = 'A to Z';
  bool _isGridView = true;
  bool _showFloatingButtons = true;

  // Getters
  String get sortBy => _sortBy;
  bool get isGridView => _isGridView;
  bool get showFloatingButtons => _showFloatingButtons;

  // State change callbacks
  VoidCallback? _onStateChanged;

  ProductsPageController({VoidCallback? onStateChanged}) {
    _onStateChanged = onStateChanged;
    scrollController.addListener(_scrollListener);
  }

  void dispose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
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
}
