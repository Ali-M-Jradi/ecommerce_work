import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import 'cart_page_widgets/cart_item_widget.dart';
import 'cart_page_widgets/cart_summary_widget.dart';
import 'cart_page_widgets/empty_cart_widget.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBFF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Shopping Cart',
          style: TextStyle(
            color: Colors.deepPurple.shade700,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.deepPurple.shade700,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Consumer<CartProvider>(
            builder: (context, cart, child) {
              if (cart.isNotEmpty) {
                return TextButton(
                  onPressed: () {
                    _showClearCartDialog(context, cart);
                  },
                  child: Text(
                    'Clear All',
                    style: TextStyle(
                      color: Colors.red.shade600,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Consumer<CartProvider>(
        builder: (context, cart, child) {
          if (cart.isEmpty) {
            return const EmptyCartWidget();
          }

          return Column(
            children: [
              // Cart Items List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: cart.items.length,
                  itemBuilder: (context, index) {
                    final cartItem = cart.items[index];
                    return CartItemWidget(
                      cartItem: cartItem,
                      onQuantityChanged: (newQuantity) {
                        cart.updateItemQuantity(cartItem.id, newQuantity);
                      },
                      onRemove: () {
                        cart.removeItem(cartItem.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${cartItem.name} removed from cart'),
                            backgroundColor: Colors.deepPurple.shade600,
                            duration: const Duration(seconds: 2),
                            action: SnackBarAction(
                              label: 'UNDO',
                              textColor: Colors.white,
                              onPressed: () {
                                // Re-add the item
                                cart.addItem({
                                  'id': cartItem.productId,
                                  'name': cartItem.name,
                                  'brand': cartItem.brand,
                                  'price': cartItem.price,
                                  'image': cartItem.image,
                                  'size': cartItem.size,
                                  'category': cartItem.category,
                                  'description': cartItem.description,
                                }, quantity: cartItem.quantity);
                              },
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              
              // Cart Summary
              CartSummaryWidget(
                onCheckout: () {
                  _navigateToCheckout(context, cart);
                },
              ),
            ],
          );
        },
      ),
    );
  }

  void _showClearCartDialog(BuildContext context, CartProvider cart) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Row(
            children: [
              Icon(
                Icons.warning,
                color: Colors.orange.shade600,
              ),
              const SizedBox(width: 8),
              const Text('Clear Cart'),
            ],
          ),
          content: const Text(
            'Are you sure you want to remove all items from your cart?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                cart.clearCart();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Cart cleared successfully'),
                    backgroundColor: Colors.deepPurple.shade600,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade600,
                foregroundColor: Colors.white,
              ),
              child: const Text('Clear All'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToCheckout(BuildContext context, CartProvider cart) {
    if (cart.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Your cart is empty!'),
          backgroundColor: Colors.orange.shade600,
        ),
      );
      return;
    }

    // Navigate to checkout page
    Navigator.of(context).pushNamed('/checkout');
  }
}
