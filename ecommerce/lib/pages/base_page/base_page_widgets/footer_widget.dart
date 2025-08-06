import 'package:flutter/material.dart';
import '../../../localization/app_localizations_helper.dart';

class FooterWidget extends StatelessWidget {
  const FooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            isDark ? colorScheme.surface : colorScheme.primaryContainer,
            isDark ? colorScheme.surfaceContainerHighest : colorScheme.secondaryContainer,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // Background women silhouette image
          Positioned.fill(
            child: Opacity(
              opacity: isDark ? 0.18 : 0.14,
              child: Image.asset(
                'assets/images/digital-art-style-mental-health-day-awareness-illustration.png',
                fit: BoxFit.contain,
                alignment: Alignment.centerRight,
                errorBuilder: (context, error, stackTrace) {
                  return Container(); // Fallback to no background image
                },
              ),
            ),
          ),
          // Main content
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Company Info Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/three_leaves.png',
                      height: 25,
                      width: 25,
                      color: isDark ? colorScheme.primary : colorScheme.primary,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.eco,
                          color: isDark ? colorScheme.primary : colorScheme.primary,
                          size: 25,
                        );
                      },
                    ),
                    SizedBox(width: 8),
                    Text(
                      AppLocalizationsHelper.of(context).appTitle,
                      style: TextStyle(
                        color: isDark ? colorScheme.onSurface : colorScheme.onPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Text(
                  AppLocalizationsHelper.of(context).appSubtitle,
                  style: TextStyle(
                    color: isDark ? colorScheme.onSurface.withOpacity(0.7) : colorScheme.onPrimary.withOpacity(0.7),
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                SizedBox(height: 15),
                
                // Quick Links Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _FooterLink(
                      icon: Icons.info_outline,
                      label: AppLocalizationsHelper.of(context).aboutUsFooter,
                      onTap: () {
                        // Handle About Us
                      },
                    ),
                    _FooterLink(
                      icon: Icons.card_giftcard,
                      label: AppLocalizationsHelper.of(context).loyaltyFooter,
                      onTap: () {
                        // Handle Loyalty Program
                      },
                    ),
                    _FooterLink(
                      icon: Icons.support_agent,
                      label: AppLocalizationsHelper.of(context).supportFooter,
                      onTap: () {
                        // Handle Support
                      },
                    ),
                    _FooterLink(
                      icon: Icons.privacy_tip_outlined,
                      label: AppLocalizationsHelper.of(context).privacyFooter,
                      onTap: () {
                        // Handle Privacy
                      },
                    ),
                    _FooterLink(
                      icon: Icons.article_outlined,
                      label: AppLocalizationsHelper.of(context).termsFooter,
                      onTap: () {
                        // Handle Terms
                      },
                    ),
                  ],
                ),
                
                SizedBox(height: 15),
                
                // Social Media Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizationsHelper.of(context).followUs,
                      style: TextStyle(
                        color: colorScheme.onPrimary.withOpacity(0.7),
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(width: 10),
                    _SocialButton(
                      icon: Icons.facebook,
                      onTap: () {
                        // Handle Facebook
                      },
                    ),
                    SizedBox(width: 8),
                    _SocialButton(
                      icon: Icons.camera_alt,
                      onTap: () {
                        // Handle Instagram
                      },
                    ),
                    SizedBox(width: 8),
                  ],
                ),
                
                SizedBox(height: 15),
                
                // Copyright Section
                Divider(color: isDark ? colorScheme.onSurface.withOpacity(0.18) : colorScheme.onPrimary.withOpacity(0.18)),
                SizedBox(height: 10),
                Text(
                  AppLocalizationsHelper.of(context).copyrightText,
                  style: TextStyle(
                    color: isDark ? colorScheme.onSurface.withOpacity(0.6) : colorScheme.onPrimary.withOpacity(0.6),
                    fontSize: 12,
                  ),
                ),
                Text(
                  AppLocalizationsHelper.of(context).allRightsReserved,
                  style: TextStyle(
                    color: isDark ? colorScheme.onSurface.withOpacity(0.5) : colorScheme.onPrimary.withOpacity(0.5),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FooterLink extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _FooterLink({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: Theme.of(context).colorScheme.onPrimary,
            size: 20,
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _SocialButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: 15,
        backgroundColor: Theme.of(context).colorScheme.surface,
        child: Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
          size: 18,
        ),
      ),
    );
  }
}
