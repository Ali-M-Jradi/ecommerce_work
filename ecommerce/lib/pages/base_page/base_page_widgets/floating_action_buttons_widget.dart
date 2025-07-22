import 'package:flutter/material.dart';
import '../../../localization/app_localizations_helper.dart';

class FloatingActionButtonsWidget extends StatelessWidget {
  final VoidCallback? onLoyaltyPressed;
  final VoidCallback? onContactPressed;
  final VoidCallback? onScanBarcodePressed;
  final String? heroTagPrefix;

  const FloatingActionButtonsWidget({
    super.key,
    this.onLoyaltyPressed,
    this.onContactPressed,
    this.onScanBarcodePressed,
    this.heroTagPrefix,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(width: 10.0),
          FloatingActionButton.extended(
            heroTag: "${heroTagPrefix ?? 'default'}_loyalty_fab",
            onPressed: onLoyaltyPressed ?? () {},
            backgroundColor: colorScheme.primary,
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage('assets/images/gift_icon.jpg'),
                  radius: 12.0,
                ),
                const SizedBox(width: 8.0),
                Text(
                  AppLocalizationsHelper.of(context).loyaltyProgram,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onPrimary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 25.0),
          FloatingActionButton.extended(
            heroTag: "${heroTagPrefix ?? 'default'}_scan_fab",
            onPressed: onScanBarcodePressed ?? () {},
            backgroundColor: colorScheme.primary,
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.qr_code_scanner, color: colorScheme.onPrimary),
                const SizedBox(width: 8.0),
                Text(
                  'Scan',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onPrimary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 25.0),
          FloatingActionButton.extended(
            heroTag: "${heroTagPrefix ?? 'default'}_contact_fab",
            onPressed: onContactPressed ?? () {},
            backgroundColor: colorScheme.primary,
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppLocalizationsHelper.of(context).contactUs,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onPrimary,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 8.0),
                CircleAvatar(
                  backgroundImage: AssetImage('assets/images/whatsapp_icon.jpg'),
                  radius: 12.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
