import 'package:ecommerce/pages/base_page/base_page_widgets/drawer_widget.dart';

import 'package:ecommerce/pages/base_page/base_page_widgets/app_bar.dart';
import 'package:ecommerce/pages/home_page/home_page.dart';
import 'package:ecommerce/pages/products_page/products_page.dart';
import 'package:ecommerce/pages/cart_page/cart_page.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce/localization/app_localizations_helper.dart';
import 'package:ecommerce/pages/about_us_page.dart'; // Import AboutUsPage here
import 'package:ecommerce/pages/contact_us_page.dart'; // Import ContactUsPage here
import 'package:ecommerce/pages/account_settings_page.dart'; // Import AccountSettingsPage here
import 'package:ecommerce/pages/loyalty_program_page.dart'; // Import LoyaltyProgramPage
import 'package:ecommerce/pages/special_offers_page.dart'; // Import SpecialOffersPage

class BasePage extends StatefulWidget {
  const BasePage({super.key, required this.title});

  final String title;

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  int _bottomNavIndex = -1; // -1 means no bottom nav item is selected (on home)

  // Remove FAB from BasePage and let HomePage handle it
  // So, remove _showFloatingButtons and _onFloatingButtonVisibilityChanged

  // Delete this method and all references to _showFloatingButtons and FloatingActionButtonsWidget in build()
  // No replacement code needed here.

  // Handle navigation from drawer
  void _handleDrawerNavigation(String route) {
    Navigator.pop(context); // Close drawer first

    switch (route) {
      case 'face_care':
        setState(() {
          _bottomNavIndex = 2; // Products index
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductsPage(
              category: 'face_care',
              categoryTitle: AppLocalizationsHelper.of(context).faceCare,
            ),
          ),
        );
        break;
      case 'body_care':
        setState(() {
          _bottomNavIndex = 2; // Products index
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductsPage(
              category: 'body_care',
              categoryTitle: AppLocalizationsHelper.of(context).bodyCare,
            ),
          ),
        );
        break;
      case 'hair_care':
        setState(() {
          _bottomNavIndex = 2; // Products index
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductsPage(
              category: 'hair_care',
              categoryTitle: AppLocalizationsHelper.of(context).hairCareCategory,
            ),
          ),
        );
        break;
      case 'brands':
        setState(() {
          _bottomNavIndex = 2; // Products index
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductsPage(
              categoryTitle: AppLocalizationsHelper.of(context).allBrands,
            ),
          ),
        );
        break;
      case 'loyalty_program':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const LoyaltyProgramPage(),
          ),
        );
        break;
      case 'special_offers':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SpecialOffersPage(),
          ),
        );
        break;
      case 'contact_us':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ContactUsPage(),
          ),
        );
        break;
      case 'about_us':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AboutUsPage(),
          ),
        );
        break;
      case 'account_settings':
        // This should go to Profile page
        setState(() {
          _bottomNavIndex = 3; // Profile index
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AccountSettingsPage(),
          ),
        );
        break;
    }
  }

  void _showLoginRegisterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Row(
            children: [
              Icon(
                Icons.person_outline,
                color: Colors.deepPurpleAccent.shade700,
              ),
              const SizedBox(width: 8),
              Text(
                AppLocalizationsHelper.of(context).accessProfile,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: Text(
            AppLocalizationsHelper.of(context).loginRegisterPrompt,
            style: const TextStyle(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed('/signup');
              },
              child: Text(
                AppLocalizationsHelper.of(context).register,
                style: TextStyle(
                  color: Colors.deepPurpleAccent.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed('/login');
              },
              child: Text(
                AppLocalizationsHelper.of(context).loginButton,
                style: TextStyle(
                  color: Colors.deepPurpleAccent.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Handle navigation from bottom nav
  void _handleBottomNavigation(int index) {
    setState(() {
      _bottomNavIndex = index;
    });

    switch (index) {
      case 0: // Search
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductsPage(
              categoryTitle: AppLocalizationsHelper.of(context).searchProducts,
              autoFocusSearch: true,
            ),
          ),
        );
        break;
      case 1: // Cart
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const CartPage(),
          ),
        );
        break;
      case 2: // Products
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductsPage(
              categoryTitle: AppLocalizationsHelper.of(context).allProducts,
            ),
          ),
        );
        break;
      case 3: // Profile
        _showLoginRegisterDialog();
        break;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBarWidget(
        selectedIndex: _bottomNavIndex,
        onNavigationTap: _handleBottomNavigation,
      ),
      body: const HomePage(),
      // FAB is now handled by HomePage, not BasePage
      drawer: DrawerWidget(
        onNavigationTap: _handleDrawerNavigation,
      ),
    );
  }
}
