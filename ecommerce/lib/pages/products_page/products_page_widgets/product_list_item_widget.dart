import 'package:flutter/material.dart';
import 'highlighted_text_widget.dart';
import '../../../localization/app_localizations_helper.dart';
import 'products_data_provider.dart';

class ProductListItemWidget extends StatelessWidget {
  final Map<String, dynamic> product;
  final VoidCallback onTap;
  final String? searchQuery;

  const ProductListItemWidget({
    super.key,
    required this.product,
    required this.onTap,
    this.searchQuery,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: Row(
            children: [
              // Product Image
              Stack(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.grey.shade200,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset(
                        product['image'],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.image,
                            size: 30,
                            color: Colors.grey.shade400,
                          );
                        },
                      ),
                    ),
                  ),
                  if (product['soldOut'])
                    Positioned(
                      top: 4,
                      right: 4,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          AppLocalizationsHelper.of(context).soldOut,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(width: 12),
              // Product Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HighlightedText(
                      text: product['brand'],
                      highlight: searchQuery ?? '',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.deepPurple.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                      highlightColor: Colors.yellow,
                    ),
                    SizedBox(height: 4),
                    HighlightedText(
                      text: ProductsDataProvider.getLocalizedName(product, context),
                      highlight: searchQuery ?? '',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      highlightColor: Colors.yellow,
                    ),
                    SizedBox(height: 4),
                    HighlightedText(
                      text: ProductsDataProvider.getLocalizedDescription(product, context),
                      highlight: searchQuery ?? '',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      highlightColor: Colors.yellow,
                    ),
                    SizedBox(height: 4),
                    Text(
                      _getDisplaySize(context),
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${product['price']}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple.shade700,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.orange, size: 14),
                            Text(
                              '${product['rating']}',
                              style: TextStyle(fontSize: 12),
                            ),
                            SizedBox(width: 8),
                            Icon(
                              Icons.info_outline,
                              size: 16,
                              color: Color(0xFF4A154B),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to get display size with localization
  String _getDisplaySize(BuildContext context) {
    final size = product['size'];
    if (size == null || size.toString().isEmpty || size.toString() == 'Not specified') {
      return AppLocalizationsHelper.of(context).notSpecified;
    }
    return size.toString();
  }
}
