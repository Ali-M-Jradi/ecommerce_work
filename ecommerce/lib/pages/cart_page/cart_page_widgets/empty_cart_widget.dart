import 'package:flutter/material.dart';
import '../../../localization/app_localizations_helper.dart';

class EmptyCartWidget extends StatelessWidget {
  const EmptyCartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 120,
              color: colorScheme.outlineVariant,
            ),
            const SizedBox(height: 24),
            Text(
              AppLocalizationsHelper.of(context).cartEmpty,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              AppLocalizationsHelper.of(context).addProductsToStart,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                // Capture the localized string before pop
                final continueShoppingText = AppLocalizationsHelper.of(context).continueShopping;
                Navigator.of(context).pop();
                // Use root context to get correct theme after pop
                Future.delayed(const Duration(milliseconds: 100), () {
                  final rootContext = Navigator.of(context).context;
                  final theme = Theme.of(rootContext);
                  final colorScheme = theme.colorScheme;
                  final isDark = theme.brightness == Brightness.dark;
                  final snackBgColor = isDark ? colorScheme.surfaceVariant : colorScheme.surface;
                  final snackTextColor = colorScheme.onSurface;
                  ScaffoldMessenger.of(rootContext).showSnackBar(
                    SnackBar(
                      content: Text(
                        continueShoppingText,
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
              icon: Icon(Icons.shopping_bag, color: colorScheme.onPrimary),
              label: Text(AppLocalizationsHelper.of(context).continueShopping),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
