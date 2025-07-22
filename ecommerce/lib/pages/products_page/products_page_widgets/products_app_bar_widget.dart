import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/cart_provider.dart';
import '../../../localization/app_localizations_helper.dart';

class ProductsAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onBackPressed;
  final VoidCallback? onCartPressed;
  final String? title;

  const ProductsAppBarWidget({
    super.key,
    this.onBackPressed,
    this.onCartPressed,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: colorScheme.onPrimary),
        onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
      ),
      title: Text(
        title ?? AppLocalizationsHelper.of(context).productsPageTitle,
        style: textTheme.titleLarge?.copyWith(color: colorScheme.onPrimary),
      ),
      backgroundColor: colorScheme.primary,
      elevation: 0,
      actions: [
        IconButton(
          icon: Consumer<CartProvider>(
            builder: (context, cart, child) {
              return Badge(
                label: Text(cart.itemCount.toString()),
                isLabelVisible: cart.itemCount > 0,
                child: Icon(
                  Icons.shopping_cart,
                  color: colorScheme.onPrimary,
                ),
              );
            },
          ),
          onPressed: onCartPressed ?? () {
            // Handle shopping cart action
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
