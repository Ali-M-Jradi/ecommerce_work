import 'package:flutter/material.dart';
import '../../../models/cart_item.dart';
import '../../../localization/app_localizations_helper.dart';

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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      elevation: 2,
      color: colorScheme.surfaceContainerHighest,
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
                color: colorScheme.surface,
                border: Border.all(color: colorScheme.outlineVariant),
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
                            color: colorScheme.primaryContainer,
                          );
                        },
                      )
                    : Icon(
                        Icons.spa,
                        size: 40,
                        color: colorScheme.primaryContainer,
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
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Product Name
                  Text(
                    cartItem.getLocalizedName(context),
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // Size (if available)
                  if (cartItem.size != null && cartItem.size!.isNotEmpty)
                    Text(
                      '${AppLocalizationsHelper.of(context).sizeLabel}: ${cartItem.size}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    )
                  else if (cartItem.size == null)
                    Text(
                      '${AppLocalizationsHelper.of(context).sizeLabel}: ${AppLocalizationsHelper.of(context).notSpecified}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
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
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.primary,
                            ),
                          ),
                          if (cartItem.quantity > 1)
                            Text(
                              'Total: \$${cartItem.totalPrice.toStringAsFixed(2)}',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
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
                              border: Border.all(color: colorScheme.outlineVariant),
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
                                    ? colorScheme.onSurfaceVariant
                                    : colorScheme.error,
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
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onSurface,
                              ),
                            ),
                          ),
                          // Increase button
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              border: Border.all(color: colorScheme.outlineVariant),
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
                                color: colorScheme.onSurfaceVariant,
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
                color: colorScheme.outline,
                size: 20,
              ),
              tooltip: MaterialLocalizations.of(context).deleteButtonTooltip,
            ),
          ],
        ),
      ),
    );
  }
}
