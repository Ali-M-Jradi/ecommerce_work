import 'package:flutter/material.dart';
import 'star_rating_widget.dart';

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
                widget.product['brand'],
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.deepPurple.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              // Product Name (Full)
              Text(
                widget.product['name'],
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              // Description (Full)
              if (widget.product['description'] != null)
                Text(
                  widget.product['description'],
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),
              SizedBox(height: 8),
              // Size
              Text(
                'Size: ${widget.product['size']}',
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
                    '\$${widget.product['price']}',
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
                        '${widget.product['rating']}',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        ' (current)',
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
                'Rate this product:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple.shade700,
                ),
              ),
              SizedBox(height: 8),
              // Instructions
              Text(
                'Tap stars to rate (tap twice for half-star)',
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
                      ? 'No rating selected' 
                      : 'Your rating: ${userRating.toString()} ${userRating == 1.0 ? 'star' : 'stars'}',
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
                          content: Text('Rating submitted: ${userRating.toString()} stars!'),
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
                      'SUBMIT RATING',
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
                  onPressed: widget.product['soldOut'] ? null : () {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${widget.product['name']} added to cart!'),
                        backgroundColor: Colors.deepPurple.shade600,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.product['soldOut'] 
                        ? Colors.grey 
                        : Color(0xFF4A154B),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    widget.product['soldOut'] ? 'SOLD OUT' : 'ADD TO CART',
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
                    'CLOSE',
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
}
