import 'package:flutter/material.dart';

class ProductsAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onBackPressed;
  final VoidCallback? onCartPressed;

  const ProductsAppBarWidget({
    super.key,
    this.onBackPressed,
    this.onCartPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
      ),
      title: Text(
        'Products',
        style: TextStyle(color: Colors.white, fontSize: 20.0),
      ),
      backgroundColor: Colors.deepPurpleAccent.shade700,
      elevation: 0,
      actions: [
        IconButton(
          icon: Icon(Icons.shopping_cart, color: Colors.white),
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
