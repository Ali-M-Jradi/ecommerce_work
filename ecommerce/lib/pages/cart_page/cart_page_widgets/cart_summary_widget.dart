import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/cart_provider.dart';
import '../../../localization/app_localizations_helper.dart';

class CartSummaryWidget extends StatelessWidget {
  final VoidCallback onCheckout;

  const CartSummaryWidget({
    super.key,
    required this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        return Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Order Summary
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizationsHelper.of(context).subtotalItems(cart.itemCount),
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF666666),
                      ),
                    ),
                    Text(
                      cart.formattedTotalAmount,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1B1B1B),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                
                // Shipping (placeholder)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizationsHelper.of(context).shipping,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF666666),
                      ),
                    ),
                    Text(
                      AppLocalizationsHelper.of(context).free,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Divider
                Divider(
                  color: Colors.grey.shade300,
                  thickness: 1,
                ),
                const SizedBox(height: 16),
                
                // Total
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizationsHelper.of(context).total,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1B1B1B),
                      ),
                    ),
                    Text(
                      cart.formattedTotalAmount,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple.shade700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                
                // Checkout Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: cart.isEmpty ? null : onCheckout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple.shade600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 2,
                    ),
                    child: Text(
                      AppLocalizationsHelper.of(context).proceedToCheckout,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                
                // Continue Shopping Button
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      AppLocalizationsHelper.of(context).continueShopping,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.deepPurple.shade600,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
