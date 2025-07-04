import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/cart_provider.dart';
import '../../cart_page/cart_page.dart';
import '../../../main.dart'; // Import to access navigatorKey
import 'star_rating_widget.dart';
import '../../../localization/app_localizations_helper.dart';
import 'products_data_provider.dart';

class ProductDetailsDialogWidget extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetailsDialogWidget({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailsDialogWidget> createState() => _ProductDetailsDialogWidgetState();
}

class _ProductDetailsDialogWidgetState extends State<ProductDetailsDialogWidget> {
  double userRating = 0.0; // Local rating for this product

  // Helper method to check if product is sold out
  bool _isSoldOut() {
    // Handle both formats: 'soldOut': bool and 'status': 'sold_out'
    if (widget.product.containsKey('soldOut')) {
      return widget.product['soldOut'] == true;
    }
    if (widget.product.containsKey('status')) {
      return widget.product['status'] == 'sold_out';
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              Center(
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    color: Colors.grey.shade200,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Image.asset(
                      widget.product['image'],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.image,
                          size: 60,
                          color: Colors.grey.shade400,
                        );
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              // Brand
              Text(
                widget.product['brand'] ?? 'Unknown Brand',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.deepPurple.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              // Product Name (Full)
              Text(
                ProductsDataProvider.getLocalizedName(widget.product, context),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              // Description (Full)
              if (ProductsDataProvider.getLocalizedDescription(widget.product, context).isNotEmpty)
                Text(
                  ProductsDataProvider.getLocalizedDescription(widget.product, context),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),
              SizedBox(height: 8),
              // Size
              Text(
                '${AppLocalizationsHelper.of(context).sizeLabel}: ${_getDisplaySize()}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              SizedBox(height: 16),
              // Price and Current Rating
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$${widget.product['price'] ?? 0}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple.shade700,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.orange, size: 18),
                      Text(
                        '${widget.product['rating'] ?? 0}',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        ' (${AppLocalizationsHelper.of(context).currentRating})',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              // User Rating Section
              Text(
                AppLocalizationsHelper.of(context).rateThisProduct,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple.shade700,
                ),
              ),
              SizedBox(height: 8),
              // Instructions
              Text(
                AppLocalizationsHelper.of(context).ratingInstructions,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontStyle: FontStyle.italic,
                ),
              ),
              SizedBox(height: 12),
              // Interactive Star Rating
              Center(
                child: StarRatingWidget(
                  currentRating: userRating,
                  onRatingChanged: (rating) {
                    setState(() {
                      userRating = rating;
                    });
                  },
                ),
              ),
              SizedBox(height: 8),
              // Rating Text
              Center(
                child: Text(
                  userRating == 0.0 
                      ? AppLocalizationsHelper.of(context).noRatingSelected
                      : AppLocalizationsHelper.of(context).yourRating(
                          userRating.toString(), 
                          userRating == 1.0 
                            ? AppLocalizationsHelper.of(context).star 
                            : AppLocalizationsHelper.of(context).stars
                        ),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.deepPurple.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Submit Rating Button (only show if user has rated)
              if (userRating > 0.0)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(AppLocalizationsHelper.of(context).ratingSubmitted(userRating.toString())),
                          backgroundColor: Colors.deepPurple.shade600,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple.shade600,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      AppLocalizationsHelper.of(context).submitRating,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              if (userRating > 0.0) SizedBox(height: 12),
              // Sold Out or Add to Cart
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSoldOut() ? null : () {
                    // Add to cart using CartProvider
                    final cartProvider = Provider.of<CartProvider>(context, listen: false);
                    cartProvider.addItem(widget.product, context: context);
                    
                    // Pop the dialog first
                    Navigator.of(context).pop();
                    
                    // Show snackbar with simple navigation
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(AppLocalizationsHelper.of(context).addedToCart(ProductsDataProvider.getLocalizedName(widget.product, context))),
                        backgroundColor: Colors.deepPurple.shade600,
                        duration: const Duration(seconds: 4),
                        action: SnackBarAction(
                          label: AppLocalizationsHelper.of(context).viewCart,
                          textColor: Colors.white,
                          onPressed: () {
                            // Use the global navigator key for guaranteed navigation
                            navigatorKey.currentState?.push(
                              MaterialPageRoute(
                                builder: (context) => const CartPage(),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isSoldOut() 
                        ? Colors.grey 
                        : Color(0xFF4A154B),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    _isSoldOut() 
                      ? AppLocalizationsHelper.of(context).soldOut 
                      : AppLocalizationsHelper.of(context).addToCart,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12),
              // Close Button
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    AppLocalizationsHelper.of(context).closeDialog,
                    style: TextStyle(
                      color: Color(0xFF4A154B),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to get display size with localization
  String _getDisplaySize() {
    final size = widget.product['size'];
    if (size == null || size.toString().isEmpty || size.toString() == 'Not specified') {
      return AppLocalizationsHelper.of(context).notSpecified;
    }
    return size.toString();
  }
}
