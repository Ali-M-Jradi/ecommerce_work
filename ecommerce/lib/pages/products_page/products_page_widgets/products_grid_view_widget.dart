import 'package:flutter/material.dart';
import 'package:ecommerce/pages/base_page/base_page_widgets/footer_widget.dart';
import 'product_card_widget.dart';
// import 'products_data_provider.dart';
import 'package:provider/provider.dart';
import '../../../providers/product_provider.dart';
import 'no_products_found_widget.dart';

class ProductsGridViewWidget extends StatelessWidget {
  final ScrollController scrollController;
  final String sortBy;
  final Function(Map<String, dynamic>) onProductTap;
  final String? category;
  final String? searchQuery;
  final String? brand;
  final double? minPrice;
  final double? maxPrice;
  final double? minRating;
  final bool showOnlyInStock;
  final VoidCallback? onClearFilters;

  const ProductsGridViewWidget({
    super.key,
    required this.scrollController,
    required this.sortBy,
    required this.onProductTap,
    this.category,
    this.searchQuery,
    this.brand,
    this.minPrice,
    this.maxPrice,
    this.minRating,
    this.showOnlyInStock = false,
    this.onClearFilters,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context);
    final products = provider.getFilteredSortedProducts(
      searchQuery: searchQuery ?? '',
      sortBy: sortBy,
      // You can extend ProductProvider to support category, brand, price, rating, stock filters if needed
    );

    if (products.isEmpty) {
      return CustomScrollView(
        controller: scrollController,
        slivers: [
          SliverFillRemaining(
            child: NoProductsFoundWidget(
              searchQuery: searchQuery,
              hasActiveFilters: brand != null || 
                             minPrice != null || 
                             maxPrice != null || 
                             minRating != null || 
                             showOnlyInStock,
              onClearFilters: onClearFilters,
            ),
          ),
        ],
      );
    }

    return CustomScrollView(
      controller: scrollController,
      slivers: [
        SliverPadding(
          padding: EdgeInsets.all(16.0),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 12.0,
              mainAxisSpacing: 12.0,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final product = products[index];
                // Ensure product is Map<String, dynamic>
                Map<String, dynamic> productMap;
                if (product is Map<String, dynamic>) {
                  productMap = product as Map<String, dynamic>;
                } else {
                  // Assume product is Product type, use toMap()
                  productMap = (product as dynamic).toMap();
                }
                return ProductCardWidget(
                  product: productMap,
                  onTap: () => onProductTap(productMap),
                  searchQuery: searchQuery,
                );
              },
              childCount: products.length,
            ),
          ),
        ),
        // Add footer as the last item
        SliverToBoxAdapter(
          child: FooterWidget(),
        ),
      ],
    );
  }
}
