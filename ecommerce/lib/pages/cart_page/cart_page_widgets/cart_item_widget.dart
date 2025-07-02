import 'package:flutter/material.dart';
import '../../../models/cart_item.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;
  final Function(int) onQuantityChanged;
  final VoidCallback onRemove;

  const CartItemWidget({
    super.key,
    required this.cartItem,
    required this.onQuantityChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey.shade100,
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: cartItem.image.isNotEmpty
                    ? Image.asset(
                        cartItem.image,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.spa,
                            size: 40,
                            color: Colors.deepPurple.shade300,
                          );
                        },
                      )
                    : Icon(
                        Icons.spa,
                        size: 40,
                        color: Colors.deepPurple.shade300,
                      ),
              ),
            ),
            const SizedBox(width: 12),
            
            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Brand
                  Text(
                    cartItem.brand,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.deepPurple.shade600,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  
                  // Product Name
                  Text(
                    cartItem.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B1B1B),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  
                  // Size (if available)
                  if (cartItem.size != null && cartItem.size!.isNotEmpty)
                    Text(
                      'Size: ${cartItem.size}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  const SizedBox(height: 8),
                  
                  // Price and Quantity Controls
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Price
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '\$${cartItem.price.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple.shade700,
                            ),
                          ),
                          if (cartItem.quantity > 1)
                            Text(
                              'Total: \$${cartItem.totalPrice.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                        ],
                      ),
                      
                      // Quantity Controls
                      Row(
                        children: [
                          // Decrease button
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              iconSize: 16,
                              onPressed: () {
                                if (cartItem.quantity > 1) {
                                  onQuantityChanged(cartItem.quantity - 1);
                                } else {
                                  onRemove();
                                }
                              },
                              icon: Icon(
                                cartItem.quantity > 1 ? Icons.remove : Icons.delete_outline,
                                color: cartItem.quantity > 1 
                                    ? Colors.grey.shade700 
                                    : Colors.red.shade600,
                              ),
                            ),
                          ),
                          
                          // Quantity display
                          Container(
                            width: 40,
                            height: 32,
                            alignment: Alignment.center,
                            child: Text(
                              cartItem.quantity.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          
                          // Increase button
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              iconSize: 16,
                              onPressed: () {
                                onQuantityChanged(cartItem.quantity + 1);
                              },
                              icon: Icon(
                                Icons.add,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Remove button
            IconButton(
              onPressed: onRemove,
              icon: Icon(
                Icons.close,
                color: Colors.grey.shade500,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
