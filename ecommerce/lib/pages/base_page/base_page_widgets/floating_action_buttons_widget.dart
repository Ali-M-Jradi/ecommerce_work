import 'package:flutter/material.dart';
import '../../../localization/app_localizations_helper.dart';
import '../../../utils/app_colors.dart';

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
          const SizedBox(width: 10.0),
          _buildEnhancedFAB(
            context: context,
            heroTag: "${heroTagPrefix ?? 'default'}_loyalty_fab",
            onPressed: onLoyaltyPressed ?? () {},
            backgroundColor: AppColors.primary(context),
            icon: const CircleAvatar(
              backgroundImage: AssetImage('assets/images/gift_icon.jpg'),
              radius: 12.0,
            ),
            label: AppLocalizationsHelper.of(context).loyaltyProgram,
          ),
          const SizedBox(width: 25.0),
          _buildEnhancedFAB(
            context: context,
            heroTag: "${heroTagPrefix ?? 'default'}_scan_fab",
            onPressed: onScanBarcodePressed ?? () {},
            backgroundColor: AppColors.primary(context),
            icon: const Icon(Icons.qr_code_scanner, color: Colors.white),
            label: 'Scan',
            isPrimary: true,
          ),
          const SizedBox(width: 25.0),
          _buildEnhancedFAB(
            context: context,
            heroTag: "${heroTagPrefix ?? 'default'}_contact_fab",
            onPressed: onContactPressed ?? () {},
            backgroundColor: AppColors.primary(context),
            icon: const CircleAvatar(
              backgroundImage: AssetImage('assets/images/whatsapp_icon.jpg'),
              radius: 12.0,
            ),
            label: AppLocalizationsHelper.of(context).contactUs,
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedFAB({
    required BuildContext context,
    required String heroTag,
    required VoidCallback onPressed,
    required Color backgroundColor,
    required Widget icon,
    required String label,
    bool isPrimary = false,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: FloatingActionButton.extended(
        heroTag: heroTag,
        onPressed: onPressed,
        backgroundColor: backgroundColor,
        elevation: isPrimary ? 8 : 6,
        highlightElevation: isPrimary ? 12 : 8,
        splashColor: backgroundColor.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(isPrimary ? 28 : 24),
        ),
        label: Container(
          padding: EdgeInsets.symmetric(
            horizontal: isPrimary ? 8 : 4,
            vertical: 2,
          ),
          decoration: BoxDecoration(
            boxShadow: isPrimary ? [
              BoxShadow(
                color: backgroundColor.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ] : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              icon,
              const SizedBox(width: 8.0),
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontSize: isPrimary ? 15 : 14,
                  fontWeight: isPrimary ? FontWeight.w600 : FontWeight.w500,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
