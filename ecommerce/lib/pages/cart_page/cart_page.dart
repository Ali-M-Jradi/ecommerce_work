import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/language_provider.dart';
import 'cart_page_widgets/cart_item_widget.dart';
import 'cart_page_widgets/cart_summary_widget.dart';
import 'cart_page_widgets/empty_cart_widget.dart';
import '../../localization/app_localizations_helper.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;
        return Scaffold(
          backgroundColor: colorScheme.surface,
          appBar: AppBar(
            backgroundColor: colorScheme.surface,
            elevation: 0.5,
            title: Text(
              AppLocalizationsHelper.of(context).shoppingCartTitle,
              style: theme.textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: colorScheme.onSurface,
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
                        AppLocalizationsHelper.of(context).clearAll,
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: theme.colorScheme.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              // Debug button to clear cart table and reload
              IconButton(
                icon: Icon(Icons.refresh, color: theme.colorScheme.primary),
                tooltip: 'Reset Cart DB',
                onPressed: () async {
                  final cartProvider = Provider.of<CartProvider>(context, listen: false);
                  await cartProvider.clearCartTableAndReload();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Cart DB reset!')),
                  );
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
                        // Capture all required data and localized string before removal
                        final removedProduct = cartItem.originalProduct ?? {
                          'id': cartItem.productId,
                          'name': cartItem.getLocalizedName(context),
                          'brand': cartItem.brand,
                          'price': cartItem.price,
                          'image': cartItem.image,
                          'size': cartItem.size,
                          'category': cartItem.category,
                          'description': cartItem.description,
                        };
                        final removedQuantity = cartItem.quantity;
                        final removedName = cartItem.getLocalizedName(context);
                        final removedLocalizedMsg = AppLocalizationsHelper.of(context).itemRemovedFromCart(removedName);
                        final undoLabel = AppLocalizationsHelper.of(context).undo;
                        final theme = Theme.of(context);
                        final colorScheme = theme.colorScheme;
                        cart.removeItem(cartItem.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              removedLocalizedMsg,
                              style: TextStyle(
                                color: colorScheme.onSurface,
                              ),
                            ),
                            backgroundColor: colorScheme.surface,
                            duration: const Duration(seconds: 2),
                            action: SnackBarAction(
                              label: undoLabel,
                              textColor: colorScheme.primary,
                              onPressed: () {
                                cart.addItem(removedProduct, quantity: removedQuantity);
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
      }, // Consumer<LanguageProvider>
    ); // Consumer<LanguageProvider>
  }

  void _showClearCartDialog(BuildContext context, CartProvider cart) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Row(
            children: [
              Icon(
                Icons.warning,
                color: colorScheme.tertiary,
              ),
              const SizedBox(width: 8),
              Text(
                'Clear Cart',
                style: theme.textTheme.titleMedium?.copyWith(color: colorScheme.onSurface),
              ),
            ],
          ),
          content: Text(
            'Are you sure you want to remove all items from your cart?',
            style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: theme.textTheme.labelLarge?.copyWith(color: colorScheme.outline),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                cart.clearCart();
                Navigator.of(context).pop();
                Future.delayed(const Duration(milliseconds: 100), () {
                  final rootContext = Navigator.of(context).context;
                  final theme = Theme.of(rootContext);
                  final isDark = theme.brightness == Brightness.dark;
                  final snackTextColor = isDark ? Colors.white : Colors.black;
                  final snackBgColor = isDark ? const Color(0xFF22232B) : Colors.white;
                  ScaffoldMessenger.of(rootContext).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Cart cleared successfully',
                        style: TextStyle(color: snackTextColor),
                      ),
                      backgroundColor: snackBgColor,
                      duration: const Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 6,
                    ),
                  );
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.error,
                foregroundColor: colorScheme.onError,
              ),
              child: const Text('Clear All'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToCheckout(BuildContext context, CartProvider cart) {
    final colorScheme = Theme.of(context).colorScheme;
    if (cart.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Your cart is empty!',
            style: TextStyle(color: colorScheme.onInverseSurface),
          ),
          backgroundColor: colorScheme.inverseSurface,
        ),
      );
      return;
    }

    // Navigate to checkout page
    Navigator.of(context).pushNamed('/checkout');
  }
}
