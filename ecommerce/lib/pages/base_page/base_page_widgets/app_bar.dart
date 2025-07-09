import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/cart_provider.dart';
import '../../../localization/app_localizations_helper.dart';

class AppBarWidget extends StatefulWidget implements PreferredSizeWidget {
  final int selectedIndex;
  final Function(int) onNavigationTap;
  
  const AppBarWidget({
    super.key,
    this.selectedIndex = -1,
    required this.onNavigationTap,
  });

  @override
  State<AppBarWidget> createState() => _AppBarWidgetState();
  
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 80);
}

class _AppBarWidgetState extends State<AppBarWidget> {
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

  void _onNavigationTap(int index) {
    // Call the parent's navigation handler
    widget.onNavigationTap(index);
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
                  AppLocalizationsHelper.of(context).appTitle,
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
            AppLocalizationsHelper.of(context).appSubtitle,
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
            _showComingSoonDialog(AppLocalizationsHelper.of(context).notifications);
          },
        ),
        const SizedBox(width: 8),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: NavigationBar(
          selectedIndex: widget.selectedIndex >= 0 ? widget.selectedIndex : 0,
          onDestinationSelected: _onNavigationTap,
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.search, color: Colors.deepPurpleAccent.shade700),
              label: AppLocalizationsHelper.of(context).searchLabel,
            ),
            NavigationDestination(
              icon: Consumer<CartProvider>(
                builder: (context, cart, child) {
                  return Badge(
                    label: Text(cart.itemCount.toString()),
                    isLabelVisible: cart.itemCount > 0,
                    child: Icon(
                      Icons.shopping_cart,
                      color: Colors.deepPurpleAccent.shade700,
                    ),
                  );
                },
              ),
              label: AppLocalizationsHelper.of(context).cartLabel,
            ),
            NavigationDestination(
              icon: Icon(
                Icons.shopping_bag,
                color: Colors.deepPurpleAccent.shade700,
              ),
              label: AppLocalizationsHelper.of(context).productsLabel,
            ),
            NavigationDestination(
              icon: Icon(Icons.person, color: Colors.deepPurpleAccent.shade700),
              label: AppLocalizationsHelper.of(context).profileLabel,
            ),
          ],
        ),
      ),
    );
  }
}
