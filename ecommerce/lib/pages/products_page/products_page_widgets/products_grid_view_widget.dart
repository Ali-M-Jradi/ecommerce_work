import 'package:flutter/material.dart';
import 'package:ecommerce/pages/base_page/base_page_widgets/footer_widget.dart';
import 'product_card_widget.dart';
import 'package:provider/provider.dart';
import '../../../providers/api_product_provider.dart';
import '../../../models/product.dart';
import 'no_products_found_widget.dart';

class ProductsGridViewWidget extends StatelessWidget {
  final ScrollController scrollController;
  final String sortBy;
  final Function(Product) onProductTap;
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
    return Consumer<ApiProductProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (provider.error != null) {
          return Center(child: Text('Error: ${provider.error}'));
        }
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
              padding: const EdgeInsets.all(16.0),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 12.0,
                  mainAxisSpacing: 12.0,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final product = filteredProducts[index];
                    return ProductCardWidget(
                      product: product,
                      onTap: () => onProductTap(product),
                      searchQuery: searchQuery,
                    );
                  },
                  childCount: filteredProducts.length,
                ),
              ),
            ),
            // Add footer as the last item
            const SliverToBoxAdapter(
              child: FooterWidget(),
            ),
          ],
        );
      },
    );
  }
}
