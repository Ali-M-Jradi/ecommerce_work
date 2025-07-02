import 'package:flutter/material.dart';
import 'package:ecommerce/pages/base_page/base_page_widgets/footer_widget.dart';
import 'product_card_widget.dart';
import 'products_data_provider.dart';

class ProductsGridViewWidget extends StatelessWidget {
  final ScrollController scrollController;
  final String sortBy;
  final Function(Map<String, dynamic>) onProductTap;

  const ProductsGridViewWidget({
    super.key,
    required this.scrollController,
    required this.sortBy,
    required this.onProductTap,
  });

  @override
  Widget build(BuildContext context) {
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
                final product = ProductsDataProvider.getSortedProducts(sortBy)[index];
                return ProductCardWidget(
                  product: product,
                  onTap: () => onProductTap(product),
                );
              },
              childCount: ProductsDataProvider.getSortedProducts(sortBy).length,
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
