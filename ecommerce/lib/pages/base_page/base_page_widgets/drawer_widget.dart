import 'package:flutter/material.dart';
import '../../../localization/app_localizations_helper.dart';

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
                  AppLocalizationsHelper.of(context).welcome,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  AppLocalizationsHelper.of(context).userEmail,
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
            title: Text(AppLocalizationsHelper.of(context).shopByCategoryMenu),
            children: [
              ListTile(
                leading: SizedBox(width: 20),
                title: Text(AppLocalizationsHelper.of(context).faceCare),
                onTap: () {
                  widget.onNavigationTap?.call('face_care');
                },
              ),
              ListTile(
                leading: SizedBox(width: 20),
                title: Text(AppLocalizationsHelper.of(context).bodyCare),
                onTap: () {
                  widget.onNavigationTap?.call('body_care');
                },
              ),
              ListTile(
                leading: SizedBox(width: 20),
                title: Text(AppLocalizationsHelper.of(context).hairCareCategory),
                onTap: () {
                  widget.onNavigationTap?.call('hair_care');
                },
              ),
              ListTile(
                leading: SizedBox(width: 20),
                title: Text(AppLocalizationsHelper.of(context).allBrands),
                subtitle: Text(AppLocalizationsHelper.of(context).brandExamples),
                onTap: () {
                  widget.onNavigationTap?.call('brands');
                },
              ),
            ],
          ),
          
          // Loyalty Program
          ListTile(
            leading: Icon(Icons.card_giftcard, color: Colors.deepPurpleAccent.shade700),
            title: Text(AppLocalizationsHelper.of(context).loyaltyProgram),
            subtitle: Text(AppLocalizationsHelper.of(context).earnPointsRewards),
            onTap: () {
              widget.onNavigationTap?.call('loyalty_program');
            },
          ),
          
          // Special Offers
          ListTile(
            leading: Icon(Icons.local_offer, color: Colors.deepPurpleAccent.shade700),
            title: Text(AppLocalizationsHelper.of(context).specialOffersMenu),
            subtitle: Text(AppLocalizationsHelper.of(context).discountsPromotions),
            onTap: () {
              widget.onNavigationTap?.call('special_offers');
            },
          ),
          
          Divider(),
          
          // Contact Us
          ListTile(
            leading: Icon(Icons.contact_support, color: Colors.deepPurpleAccent.shade700),
            title: Text(AppLocalizationsHelper.of(context).contactUs),
            onTap: () {
              widget.onNavigationTap?.call('contact_us');
            },
          ),
          
          // About Us
          ListTile(
            leading: Icon(Icons.info, color: Colors.deepPurpleAccent.shade700),
            title: Text(AppLocalizationsHelper.of(context).aboutUs),
            onTap: () {
              widget.onNavigationTap?.call('about_us');
            },
          ),
          
          // Account Settings
          ListTile(
            leading: Icon(Icons.person, color: Colors.deepPurpleAccent.shade700),
            title: Text(AppLocalizationsHelper.of(context).accountSettings),
            subtitle: Text(AppLocalizationsHelper.of(context).profilePreferences),
            onTap: () {
              widget.onNavigationTap?.call('account_settings');
            },
          ),
        ],
      ),
    );
  }
}