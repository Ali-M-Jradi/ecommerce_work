import 'package:flutter/material.dart';
import 'package:ecommerce/pages/products_page/products_page.dart';

class AppBarWidget extends StatefulWidget implements PreferredSizeWidget {
  const AppBarWidget({super.key});

  @override
  State<AppBarWidget> createState() => _AppBarWidgetState();
  
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 80);
}

class _AppBarWidgetState extends State<AppBarWidget> {
  int _selectedIndex = 0;

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
              const Text(
                'Coming Soon',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: Text(
            '$feature is under development and will be available soon!',
            style: const TextStyle(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'OK',
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

  void _onNavigationTap(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        // Home - Stay on current page (already on home)
        break;
      case 1:
        // Cart - Coming soon
        _showComingSoonDialog('Shopping Cart');
        break;
      case 2:
        // Products - Navigate to products page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ProductsPage(),
          ),
        );
        break;
      case 3:
        // Profile - Coming soon
        _showComingSoonDialog('User Profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      leading: IconButton(
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
        icon: Icon(Icons.list, color: const Color(0xFF6200EA)),
      ),
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/three_leaves.png',
                height: 24,
                width: 24,
                color: Colors.deepPurpleAccent.shade700,
              ),
              SizedBox(width: 6),
              Flexible(
                child: Text(
                  'DERMOCOSMETIQUE',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: Colors.deepPurpleAccent.shade700,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Text(
            'BY PH.MARIAM',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w300,
              color: Colors.deepPurpleAccent.shade700,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.notifications,
            color: Colors.deepPurpleAccent.shade700,
          ),
          onPressed: () {
            _showComingSoonDialog('Notifications');
          },
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: _onNavigationTap,
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.home, color: Colors.deepPurpleAccent.shade700),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.shopping_cart,
                color: Colors.deepPurpleAccent.shade700,
              ),
              label: 'Cart',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.business_center,
                color: Colors.deepPurpleAccent.shade700,
              ),
              label: 'Products',
            ),
            NavigationDestination(
              icon: Icon(Icons.person, color: Colors.deepPurpleAccent.shade700),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
