import 'package:flutter/material.dart';
import '../../../localization/app_localizations_helper.dart';

class FloatingActionButtonsWidget extends StatelessWidget {
  final VoidCallback? onLoyaltyPressed;
  final VoidCallback? onContactPressed;
  final String? heroTagPrefix;

  const FloatingActionButtonsWidget({
    super.key,
    this.onLoyaltyPressed,
    this.onContactPressed,
    this.heroTagPrefix,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(width: 10.0), 
        FloatingActionButton.extended(
          heroTag: "${heroTagPrefix ?? 'default'}_loyalty_fab", // Add unique hero tag with prefix
          onPressed: onLoyaltyPressed ?? () {
          // Handle loyalty program action
        }, label: 
          Row(
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
        SizedBox(width: 25.0), // Add space between buttons
        FloatingActionButton.extended(
          heroTag: "${heroTagPrefix ?? 'default'}_contact_fab", // Add unique hero tag with prefix
          onPressed: onContactPressed ?? () {
            // Handle contact us action
          },
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
    );
  }
}
