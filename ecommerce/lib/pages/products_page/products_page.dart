import 'package:flutter/material.dart';
import 'package:ecommerce/pages/base_page/base_page_widgets/floating_action_buttons_widget.dart';
import 'products_page_widgets/products_app_bar_widget.dart';
import 'products_page_widgets/products_grid_view_widget.dart';
import 'products_page_widgets/products_list_view_widget.dart';
import 'products_page_widgets/product_details_dialog_widget.dart';
import 'products_page_widgets/sort_controls_widget.dart';
import 'products_page_widgets/products_page_controller.dart';
import 'products_page_widgets/products_page_constants.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  late ProductsPageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ProductsPageController(
      onStateChanged: () => setState(() {}),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ProductsAppBarWidget(
        onBackPressed: () => Navigator.of(context).pop(),
        onCartPressed: () {
          // Handle shopping cart action
        },
      ),
      backgroundColor: ProductsPageConstants.backgroundColor,
      body: Column(
        children: [
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
          ),
          // Content area
          Expanded(
            child: _controller.isGridView 
              ? ProductsGridViewWidget(
                  scrollController: _controller.scrollController,
                  sortBy: _controller.sortBy,
                  onProductTap: _showProductDetails,
                )
              : ProductsListViewWidget(
                  scrollController: _controller.scrollController,
                  sortBy: _controller.sortBy,
                  onProductTap: _showProductDetails,
                ),
          ),
        ],
      ),
      floatingActionButton: _controller.showFloatingButtons 
        ? FloatingActionButtonsWidget(
            onLoyaltyPressed: () {
              // Handle loyalty program
            },
            onContactPressed: () {
              // Handle contact us
            },
          )
        : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _showProductDetails(Map<String, dynamic> product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ProductDetailsDialogWidget(product: product);
      },
    );
  }
}
