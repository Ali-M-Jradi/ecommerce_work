import 'package:flutter/material.dart';

class FooterWidget extends StatelessWidget {
  const FooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.deepPurpleAccent.shade700,
            Colors.deepPurple.shade800,
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
              opacity: 0.225,
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
                      color: Colors.white,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.eco,
                          color: Colors.white,
                          size: 25,
                        );
                      },
                    ),
                    SizedBox(width: 8),
                    Text(
                      'DERMOCOSMETIQUE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Text(
                  'BY PH.MARIAM',
                  style: TextStyle(
                    color: Colors.white70,
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
                      label: 'About Us',
                      onTap: () {
                        // Handle About Us
                      },
                    ),
                    _FooterLink(
                      icon: Icons.card_giftcard,
                      label: 'Loyalty',
                      onTap: () {
                        // Handle Loyalty Program
                      },
                    ),
                    _FooterLink(
                      icon: Icons.support_agent,
                      label: 'Support',
                      onTap: () {
                        // Handle Support
                      },
                    ),
                    _FooterLink(
                      icon: Icons.privacy_tip_outlined,
                      label: 'Privacy',
                      onTap: () {
                        // Handle Privacy
                      },
                    ),
                    _FooterLink(
                      icon: Icons.article_outlined,
                      label: 'Terms',
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
                      'Follow us: ',
                      style: TextStyle(
                        color: Colors.white70,
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
                    CircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.white,
                      child: Image.asset(
                        'assets/images/whatsapp_icon.jpg',
                        width: 20,
                        height: 20,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.chat,
                            color: Colors.deepPurpleAccent.shade700,
                            size: 18,
                          );
                        },
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: 15),
                
                // Copyright Section
                Divider(color: Colors.white24),
                SizedBox(height: 10),
                Text(
                  '© 2025 Dermocosmetique by Ph.Mariam',
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 12,
                  ),
                ),
                Text(
                  'All rights reserved',
                  style: TextStyle(
                    color: Colors.white60,
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
            color: Colors.white,
            size: 20,
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
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
        backgroundColor: Colors.white,
        child: Icon(
          icon,
          color: Colors.deepPurpleAccent.shade700,
          size: 18,
        ),
      ),
    );
  }
}
