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
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: 10.0),
          FloatingActionButton.extended(
            heroTag: "${heroTagPrefix ?? 'default'}_loyalty_fab",
            onPressed: onLoyaltyPressed ?? () {},
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage('assets/images/gift_icon.jpg'),
                  radius: 12.0,
                ),
                SizedBox(width: 8.0),
                Text(
                  AppLocalizationsHelper.of(context).loyaltyProgram,
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
            backgroundColor: Colors.deepPurpleAccent.shade700,
          ),
          SizedBox(width: 25.0),
          FloatingActionButton.extended(
            heroTag: "${heroTagPrefix ?? 'default'}_scan_fab",
            onPressed: onScanBarcodePressed ?? () {},
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.qr_code_scanner, color: Colors.white),
                SizedBox(width: 8.0),
                Text(
                  'Scan',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
            backgroundColor: Colors.deepPurpleAccent.shade700,
          ),
          SizedBox(width: 25.0),
          FloatingActionButton.extended(
            heroTag: "${heroTagPrefix ?? 'default'}_contact_fab",
            onPressed: onContactPressed ?? () {},
            tooltip: AppLocalizationsHelper.of(context).contactUs,
            backgroundColor: Colors.deepPurpleAccent.shade700,
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppLocalizationsHelper.of(context).contactUs,
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                SizedBox(width: 8.0),
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
