import 'package:flutter/material.dart';

class DrawerWidget extends StatefulWidget {
  final Function(String)? onNavigationTap;
  
  const DrawerWidget({super.key, this.onNavigationTap});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.deepPurpleAccent.shade700,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 35,
                    color: Colors.deepPurpleAccent.shade700,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Welcome!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'user@example.com',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          // Shop by Category
          ExpansionTile(
            leading: Icon(Icons.category, color: Colors.deepPurpleAccent.shade700),
            title: Text('Shop by Category'),
            children: [
              ListTile(
                leading: SizedBox(width: 20),
                title: Text('Face Care'),
                onTap: () {
                  widget.onNavigationTap?.call('face_care');
                },
              ),
              ListTile(
                leading: SizedBox(width: 20),
                title: Text('Body Care'),
                onTap: () {
                  widget.onNavigationTap?.call('body_care');
                },
              ),
              ListTile(
                leading: SizedBox(width: 20),
                title: Text('Hair Care'),
                onTap: () {
                  widget.onNavigationTap?.call('hair_care');
                },
              ),
              ListTile(
                leading: SizedBox(width: 20),
                title: Text('Brands'),
                subtitle: Text('La Roche Posay, Vichy, Bioderma...'),
                onTap: () {
                  widget.onNavigationTap?.call('brands');
                },
              ),
            ],
          ),
          
          // Loyalty Program
          ListTile(
            leading: Icon(Icons.card_giftcard, color: Colors.deepPurpleAccent.shade700),
            title: Text('Loyalty Program'),
            subtitle: Text('Earn points & rewards'),
            onTap: () {
              widget.onNavigationTap?.call('loyalty_program');
            },
          ),
          
          // Special Offers
          ListTile(
            leading: Icon(Icons.local_offer, color: Colors.deepPurpleAccent.shade700),
            title: Text('Special Offers'),
            subtitle: Text('Discounts & promotions'),
            onTap: () {
              widget.onNavigationTap?.call('special_offers');
            },
          ),
          
          Divider(),
          
          // Contact Us
          ListTile(
            leading: Icon(Icons.contact_support, color: Colors.deepPurpleAccent.shade700),
            title: Text('Contact Us'),
            onTap: () {
              widget.onNavigationTap?.call('contact_us');
            },
          ),
          
          // About Us
          ListTile(
            leading: Icon(Icons.info, color: Colors.deepPurpleAccent.shade700),
            title: Text('About Us'),
            onTap: () {
              widget.onNavigationTap?.call('about_us');
            },
          ),
          
          // Account Settings
          ListTile(
            leading: Icon(Icons.person, color: Colors.deepPurpleAccent.shade700),
            title: Text('Account Settings'),
            subtitle: Text('Profile & preferences'),
            onTap: () {
              widget.onNavigationTap?.call('account_settings');
            },
          ),
        ],
      ),
    );
  }
}