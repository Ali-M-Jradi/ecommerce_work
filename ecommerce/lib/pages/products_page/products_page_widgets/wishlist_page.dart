import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/wishlist_provider.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wishlist'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: Consumer<WishlistProvider>(
        builder: (context, wishlistProvider, _) {
          final wishlist = wishlistProvider.wishlist;
          if (wishlist.isEmpty) {
            return const Center(child: Text('No favorites yet.'));
          }
          return ListView.builder(
            itemCount: wishlist.length,
            itemBuilder: (context, index) {
              final product = wishlist[index];
              return ListTile(
                leading: Image.asset(product.image, width: 48, height: 48, fit: BoxFit.cover),
                title: Text(product.name),
                subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: colorScheme.error),
                  onPressed: () => wishlistProvider.removeFromWishlist(product),
                ),
                onTap: () {
                  // Optionally navigate to product details
                },
              );
            },
          );
        },
      ),
    );
  }
}
