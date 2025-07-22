import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/cart_provider.dart';
import '../../../providers/user_provider.dart';
import '../../../providers/mock_notification_provider.dart';
import '../../../localization/app_localizations_helper.dart';
// Make sure this import points to the file where NotificationsPage is defined
import '../../../pages/notifications/notifications_page.dart';

class AppBarWidget extends StatefulWidget implements PreferredSizeWidget {
  final GlobalKey<_AppBarWidgetState>? widgetKey;
  final int selectedIndex;
  final Function(int) onNavigationTap;

  const AppBarWidget({
    Key? key,
    this.widgetKey,
    this.selectedIndex = -1,
    required this.onNavigationTap,
  }) : super(key: key);

  // Expose a public method to show the login/register dialog from outside
  void showLoginRegisterDialog() {
    final state = widgetKey?.currentState;
    if (state is _AppBarWidgetState) {
      state._showLoginRegisterDialog();
    }
  }

  @override
  State<AppBarWidget> createState() => _AppBarWidgetState();
  
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 80);
}

class _AppBarWidgetState extends State<AppBarWidget> {
  // This method is kept for other features that might need it
  // ignore: unused_element
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
                color: Theme.of(context).colorScheme.primary,
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
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
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
                color: Theme.of(context).colorScheme.primary,
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
                  color: Theme.of(context).colorScheme.primary,
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
                  color: Theme.of(context).colorScheme.primary,
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
    // Handle profile navigation specially
    if (index == 3) { // Profile tab
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      if (userProvider.isLoggedIn) {
        // Navigate to profile page
        Navigator.of(context).pushNamed('/profile');
      } else {
        // Show login/register dialog
        _showLoginRegisterDialog();
      }
    } else {
      // Call the parent's navigation handler for other tabs
      widget.onNavigationTap(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor ?? Theme.of(context).colorScheme.primary,
      centerTitle: true,
      leading: IconButton(
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
        icon: Icon(Icons.list, color: Theme.of(context).colorScheme.onPrimary),
      ),
      title: DefaultTextStyle(
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ) ?? TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontWeight: FontWeight.bold, fontSize: 20),
        child: Column(
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
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                SizedBox(width: 6),
                Flexible(
                  child: Text(
                    AppLocalizationsHelper.of(context).appTitle,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).colorScheme.onPrimary,
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
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ],
        ),
      ),
      actions: [
        Consumer<MockNotificationProvider>(
          builder: (context, notificationProvider, child) {
            return Badge(
              label: Text((notificationProvider.unreadCount).toString()),
              isLabelVisible: (notificationProvider.unreadCount) > 0,
              child: IconButton(
                icon: Icon(
                  Icons.notifications,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const NotificationsPage()),
                  );
                },
              ),
            );
          },
        ),
        const SizedBox(width: 8),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: NavigationBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          selectedIndex: widget.selectedIndex >= 0 ? widget.selectedIndex : 0,
          onDestinationSelected: _onNavigationTap,
          indicatorColor: Color.alphaBlend(
            Theme.of(context).colorScheme.primary.withAlpha((0.1 * 255).round()),
            Theme.of(context).colorScheme.surface,
          ),
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.search, color: Theme.of(context).colorScheme.primary),
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
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  );
                },
              ),
              label: AppLocalizationsHelper.of(context).cartLabel,
            ),
            NavigationDestination(
              icon: Icon(
                Icons.shopping_bag,
                color: Theme.of(context).colorScheme.primary,
              ),
              label: AppLocalizationsHelper.of(context).productsLabel,
            ),
            NavigationDestination(
              icon: Consumer<UserProvider>(
                builder: (context, userProvider, child) {
                  return Icon(
                    userProvider.isLoggedIn ? Icons.person : Icons.person_outline,
                    color: Theme.of(context).colorScheme.primary,
                  );
                },
              ),
              label: AppLocalizationsHelper.of(context).profileLabel,
            ),
          ],
        ),
      ),
    );
  }
}
