import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce/providers/language_provider.dart';

import '../cart_page/cart_page.dart';
import '../../../main.dart'; // Import for global navigator key
import '../../models/product.dart';

import 'products_page_widgets/products_app_bar_widget.dart';
import 'products_page_widgets/products_grid_view_widget.dart';
import 'products_page_widgets/products_list_view_widget.dart';
import 'products_page_widgets/product_details_dialog_widget.dart';
import 'products_page_widgets/sort_controls_widget.dart';
import 'products_page_widgets/search_bar_widget.dart';
import 'products_page_widgets/filter_bottom_sheet.dart';
import 'products_page_widgets/products_page_controller.dart';
import 'products_page_widgets/products_page_constants.dart';

import '../../shared/scan_utils.dart';
import '../../shared/unified_scan_fab.dart';
import '../../services/category_mapper.dart';

class ProductsPage extends StatefulWidget {
  final String? category;
  final String? categoryTitle;
  final bool autoFocusSearch;
  
  const ProductsPage({
    super.key,
    this.category,
    this.categoryTitle,
    this.autoFocusSearch = false,
  });

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}


class _ProductsPageState extends State<ProductsPage> with ScanHistoryMixin, UnifiedScanFabMixin {
  late ProductsPageController _controller;

  @override
  void initState() {
    super.initState();
    // If category is a numeric id passed as a string, try to convert to classifier key first
    String? initialCategory = widget.category;
    if (initialCategory != null && initialCategory.isNotEmpty && !initialCategory.contains('_')) {
      try {
        final rev = mapCategoryIdToClassifierKey(context, initialCategory);
        if (rev != null && rev.isNotEmpty) initialCategory = rev;
      } catch (_) {
        // ignore
      }
    }
    _controller = ProductsPageController(
      onStateChanged: () => setState(() {}),
      category: initialCategory,
    );
    // Auto-focus search if requested
    if (widget.autoFocusSearch) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _controller.focusSearch();
      });
    }
    
    // ProductProvider automatically loads demo products at initialization
  }

  // Use showScanOptionsModal from UnifiedScanFabMixin
  // Use handleBulkScan from UnifiedScanFabMixin



  // Use handleBarcodeResult from mixin

  // Use showScanHistoryDialog from mixin

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
  // Use the category string supplied by the caller directly. It may be a
  // classifier key (e.g. 'face_care') which matches Product.category values.
        return Scaffold(
          appBar: ProductsAppBarWidget(
            onBackPressed: () => Navigator.of(context).pop(),
            onCartPressed: () {
              // Navigate to cart page using global navigator key
              navigatorKey.currentState?.push(
                MaterialPageRoute(
                  builder: (context) => const CartPage(),
                ),
              );
            },
            title: widget.categoryTitle ?? 'Products',
          ),
          backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        children: [
          // Search bar
          SearchBarWidget(
            controller: _controller.searchController,
            focusNode: _controller.searchFocusNode,
            onChanged: (value) {
              _controller.updateSearchQuery(value);
            },
            onClear: () {
              _controller.clearSearch();
            },
          ),
          // Top controls row
          SortControlsWidget(
            sortBy: _controller.sortBy,
            isGridView: _controller.isGridView,
            onSortChanged: (String? newValue) {
              _controller.updateSortBy(newValue ?? ProductsPageConstants.defaultSortOption);
            },
            onViewChanged: (bool isGrid) {
              _controller.updateViewMode(isGrid);
            },
            onFilterPressed: _showFilterBottomSheet,
            hasActiveFilters: _controller.hasActiveFilters,
          ),
          // Content area
          Expanded(
            child: _controller.isGridView 
        ? ProductsGridViewWidget(
                  scrollController: _controller.scrollController,
                  sortBy: _controller.sortBy,
                  onProductTap: _showProductDetails,
          // pass multi-select categories
          selectedCategories: _controller.selectedCategories,
                  searchQuery: _controller.searchQuery,
                  brand: _controller.selectedBrand,
                  minPrice: _controller.minPrice,
                  maxPrice: _controller.maxPrice,
                  minRating: _controller.minRating,
                  showOnlyInStock: _controller.showOnlyInStock,
                  onClearFilters: () {
                    _controller.clearAllFilters();
                    _controller.clearSearch();
                  },
                )
              : ProductsListViewWidget(
                  scrollController: _controller.scrollController,
                  sortBy: _controller.sortBy,
                  onProductTap: _showProductDetails,
          selectedCategories: _controller.selectedCategories,
                  searchQuery: _controller.searchQuery,
                  brand: _controller.selectedBrand,
                  minPrice: _controller.minPrice,
                  maxPrice: _controller.maxPrice,
                  minRating: _controller.minRating,
                  showOnlyInStock: _controller.showOnlyInStock,
                  onClearFilters: () {
                    _controller.clearAllFilters();
                    _controller.clearSearch();
                  },
                ),
          ),
        ],
      ),
      floatingActionButton: _controller.showFloatingButtons
          ? UnifiedScanFab(
              heroTagPrefix: 'products_page',
              onLoyaltyPressed: () {
                // Handle loyalty program
              },
              onContactPressed: () {
                // Handle contact us
              },
              onScanPressed: () async {
                await showScanOptionsModal(context);
              },
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        );
      },
    );
  }

  void _showProductDetails(Product product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ProductDetailsDialogWidget(product: product);
      },
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return FilterBottomSheet(
          selectedCategories: _controller.selectedCategories,
          selectedBrands: _controller.selectedBrands,
          minPrice: _controller.minPrice,
          maxPrice: _controller.maxPrice,
          minRating: _controller.minRating,
          showOnlyInStock: _controller.showOnlyInStock,
          onApplyFilters: (filters) {
            _controller.updateFilters(filters);
          },
        );
      },
    );
  }
}
