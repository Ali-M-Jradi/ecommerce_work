import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce/pages/base_page/base_page_widgets/footer_widget.dart';
import 'product_list_item_widget.dart';
import '../../../providers/product_provider.dart';
import '../../../models/product.dart';
import 'no_products_found_widget.dart';

class ProductsListViewWidget extends StatelessWidget {
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

  const ProductsListViewWidget({
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
    return Consumer<ProductProvider>(
      builder: (context, provider, child) {
        // ProductProvider doesn't have loading states like ApiProductProvider
        // It uses local/demo data, so we just check if products are available
        
        final products = provider.getFilteredSortedProducts(
          searchQuery: searchQuery ?? '',
          sortBy: sortBy,
        );

        // Apply additional filtering locally since ProductProvider doesn't support all filters
        List<Product> filteredProducts = products;
        
        if (category != null && category!.isNotEmpty) {
          filteredProducts = filteredProducts.where((p) => p.category.toLowerCase() == category!.toLowerCase()).toList();
        }
        
        if (brand != null && brand!.isNotEmpty) {
          filteredProducts = filteredProducts.where((p) => p.brand.toLowerCase().contains(brand!.toLowerCase())).toList();
        }
        
        if (minPrice != null) {
          filteredProducts = filteredProducts.where((p) => p.price >= minPrice!).toList();
        }
        
        if (maxPrice != null) {
          filteredProducts = filteredProducts.where((p) => p.price <= maxPrice!).toList();
        }
        
        if (minRating != null) {
          filteredProducts = filteredProducts.where((p) => p.rating >= minRating!).toList();
        }
        
        if (showOnlyInStock) {
          filteredProducts = filteredProducts.where((p) => !p.soldOut).toList();
        }

        if (filteredProducts.isEmpty) {
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
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final product = filteredProducts[index];
                    final productMap = product.toMap(); // Convert Product to Map
                    return Padding(
                      padding: EdgeInsets.only(bottom: 12.0),
                      child: ProductListItemWidget(
                        product: productMap,
                        onTap: () => onProductTap(productMap),
                        searchQuery: searchQuery,
                      ),
                    );
                  },
                  childCount: filteredProducts.length,
                ),
              ),
            ),
            // Add footer as the last item
            SliverToBoxAdapter(
              child: FooterWidget(),
            ),
          ],
        );
      },
    );
  }
}
