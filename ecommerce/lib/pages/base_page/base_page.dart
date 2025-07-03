import 'package:ecommerce/pages/base_page/base_page_widgets/drawer_widget.dart';
import 'package:ecommerce/pages/base_page/base_page_widgets/floating_action_buttons_widget.dart';
import 'package:ecommerce/pages/base_page/base_page_widgets/app_bar.dart';
import 'package:ecommerce/pages/home_page/home_page.dart';
import 'package:ecommerce/pages/products_page/products_page.dart';
import 'package:ecommerce/pages/cart_page/cart_page.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce/localization/app_localizations_helper.dart';

class BasePage extends StatefulWidget {
  const BasePage({super.key, required this.title});

  final String title;

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  bool _showFloatingButtons = true;
  int _bottomNavIndex = -1; // -1 means no bottom nav item is selected (on home)

  void _onFloatingButtonVisibilityChanged(bool visible) {
    if (visible != _showFloatingButtons) {
      setState(() {
        _showFloatingButtons = visible;
      });
    }
  }

  // Handle navigation from drawer
  void _handleDrawerNavigation(String route) {
    Navigator.pop(context); // Close drawer first
    
    switch (route) {
      case 'face_care':
        setState(() {
          _bottomNavIndex = 2; // Products index
        });          Navigator.push(
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
        });          Navigator.push(
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
        });          Navigator.push(
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
        });          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductsPage(
                categoryTitle: AppLocalizationsHelper.of(context).allBrands,
              ),
            ),
          );
        break;
      case 'loyalty_program':
        _showComingSoonDialog(AppLocalizationsHelper.of(context).loyaltyProgram);
        break;
      case 'special_offers':
        _showComingSoonDialog(AppLocalizationsHelper.of(context).specialOffersMenu);
        break;
      case 'contact_us':
        _showComingSoonDialog(AppLocalizationsHelper.of(context).contactUs);
        break;
      case 'about_us':
        _showComingSoonDialog(AppLocalizationsHelper.of(context).aboutUs);
        break;
      case 'account_settings':
        // This should go to Profile page
        setState(() {
          _bottomNavIndex = 3; // Profile index
        });
        _showComingSoonDialog(AppLocalizationsHelper.of(context).accountSettings);
        break;
    }
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
        _showComingSoonDialog(AppLocalizationsHelper.of(context).userProfile);
        break;
    }
  }

  void _showComingSoonDialog(String feature) {
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
                Icons.construction,
                color: Colors.deepPurpleAccent.shade700,
              ),
              const SizedBox(width: 8),
              Text(
                AppLocalizationsHelper.of(context).comingSoon,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: Text(
            AppLocalizationsHelper.of(context).comingSoonMessage(feature),
            style: const TextStyle(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                AppLocalizationsHelper.of(context).okButton,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFBFF), // Purple-tinted white
      appBar: AppBarWidget(
        selectedIndex: _bottomNavIndex,
        onNavigationTap: _handleBottomNavigation,
      ),
      body: HomePage(onFloatingButtonVisibilityChanged: _onFloatingButtonVisibilityChanged),
      floatingActionButton: AnimatedSlide(
        duration: const Duration(milliseconds: 300),
        offset: _showFloatingButtons ? Offset.zero : const Offset(0, 2),
        child: FloatingActionButtonsWidget(
          heroTagPrefix: 'base_page',
        ),
      ),
      drawer: DrawerWidget(
        onNavigationTap: _handleDrawerNavigation,
      ),
    );
  }
}
