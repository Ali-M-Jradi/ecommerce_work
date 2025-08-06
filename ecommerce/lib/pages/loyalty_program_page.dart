import 'package:flutter/material.dart';
import 'package:ecommerce/localization/app_localizations_helper.dart';

class LoyaltyProgramPage extends StatelessWidget {
  const LoyaltyProgramPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizationsHelper.of(context).loyaltyProgram),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor ?? Theme.of(context).colorScheme.primary,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Icon(Icons.card_giftcard, size: 80, color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(height: 24),
            Text(
              AppLocalizationsHelper.of(context).loyaltyProgram,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              'Earn points with every purchase and unlock exclusive rewards!\n\n- 1 point for every 1 USD spent.\n- Redeem points for discounts and gifts.\n- Special offers for loyal members.\n\nJoin now and start earning!',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Loyalty program coming soon!')),
                  );
                },
                child: Text('Join Now', style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
