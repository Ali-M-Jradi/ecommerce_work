import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/cart_provider.dart';
import '../../../pages/auth/auth_provider.dart'; // Use AuthProvider instead of UserProvider
import '../../../providers/mock_notification_provider.dart';
import '../../../localization/app_localizations_helper.dart';
// Make sure this import points to the file where NotificationsPage is defined
import '../../../pages/notifications/notifications_page.dart';

class AppBarWidget extends StatefulWidget implements PreferredSizeWidget {
  final GlobalKey<_AppBarWidgetState>? widgetKey;
  final int selectedIndex;
  final Function(int) onNavigationTap;

  const AppBarWidget({
    super.key,
    this.widgetKey,
    this.selectedIndex = -1,
    required this.onNavigationTap,
  });

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
            borderRadius: BorderRadius.circular(20),
          ),
          title: Column(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person_outline,
                  color: Theme.of(context).colorScheme.primary,
                  size: 30,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                AppLocalizationsHelper.of(context).accessProfile,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppLocalizationsHelper.of(context).loginRegisterPrompt,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              // Login button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed('/login');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    AppLocalizationsHelper.of(context).loginButton,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Register button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed('/signup');
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    AppLocalizationsHelper.of(context).register,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
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
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (authProvider.isLoggedIn) {
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
                const SizedBox(width: 6),
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
              icon: Consumer<AuthProvider>(
                builder: (context, authProvider, child) {
                  return Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: authProvider.isLoggedIn 
                        ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                        : Colors.transparent,
                      border: authProvider.isLoggedIn 
                        ? Border.all(
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                            width: 2,
                          )
                        : null,
                    ),
                    child: Icon(
                      authProvider.isLoggedIn 
                        ? Icons.person 
                        : Icons.person_add_outlined,
                      color: authProvider.isLoggedIn 
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.primary.withOpacity(0.7),
                      size: authProvider.isLoggedIn ? 24 : 26,
                    ),
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
