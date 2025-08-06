
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../localization/app_localizations_helper.dart';
import '../../../providers/language_provider.dart';
import '../../../providers/mock_notification_provider.dart';

import '../../../providers/user_provider.dart';
import '../../../providers/category_provider.dart';

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
          // User Profile Header
          Consumer<UserProvider>(
            builder: (context, userProvider, _) {
              final bool isLoggedIn = userProvider.isLoggedIn;
              final String displayEmail = isLoggedIn 
                ? userProvider.currentUser!.email 
                : AppLocalizationsHelper.of(context).notLoggedIn;
              final colorScheme = Theme.of(context).colorScheme;
              return DrawerHeader(
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: colorScheme.surface,
                      child: Icon(
                        isLoggedIn ? Icons.person : Icons.person_outline,
                        size: 35,
                        color: colorScheme.primary,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      isLoggedIn 
                        ? AppLocalizationsHelper.welcomeUser(context, userProvider.currentUser!.displayName) 
                        : AppLocalizationsHelper.of(context).welcome,
                      style: TextStyle(
                        color: colorScheme.onPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      displayEmail,
                      style: TextStyle(
                        color: colorScheme.onPrimary.withOpacity(0.7),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              );
            }
          ),
          // Currencies
         ListTile(
            leading: Icon(Icons.dashboard, color: Theme.of(context).colorScheme.primary),
            title: Text('Admin Dashboard'),
            onTap: () {
              Navigator.of(context).pushNamed('/admin/dashboard');
            },
          ),
         // Order History
         ListTile(
           leading: Icon(Icons.receipt_long, color: Theme.of(context).colorScheme.primary),
           title: Text('Order History'),
           onTap: () {
             widget.onNavigationTap?.call('order_history');
           },
         ),
          // Shop by Category (Dynamic)
          Consumer<CategoryProvider>(
            builder: (context, categoryProvider, _) {
              return ExpansionTile(
                leading: Icon(Icons.category, color: Theme.of(context).colorScheme.primary),
                title: Text(
                  AppLocalizationsHelper.of(context).shopByCategoryMenu,
                  style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
                ),
                children: [
                  ...categoryProvider.categories.map((cat) => ListTile(
                        leading: Icon(cat.icon, color: Theme.of(context).colorScheme.primary),
                        title: Text(
                          // Show localized name based on current language
                          Localizations.localeOf(context).languageCode == 'ar'
                              ? cat.ar
                              : Localizations.localeOf(context).languageCode == 'fr'
                                  ? cat.fr
                                  : cat.en,
                          style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
                        ),
                        onTap: () {
                          widget.onNavigationTap?.call(cat.id.toString());
                        },
                      ))
                ],
              );
            },
          ),
                 
          // Wishlist / Favorites
          ListTile(
            leading: Icon(Icons.favorite, color: Colors.redAccent),
            title: Text('Wishlist'),
            onTap: () {
              Navigator.of(context).pushNamed('/wishlist');
            },
          ),
          // Special Offers
          ListTile(
            leading: Icon(Icons.local_offer, color: Theme.of(context).colorScheme.primary),
            title: Text(AppLocalizationsHelper.of(context).specialOffersMenu),
            subtitle: Text(AppLocalizationsHelper.of(context).discountsPromotions),
            onTap: () {
              widget.onNavigationTap?.call('special_offers');
            },
          ),
          
          Divider(),
          
          // Contact Us
          ListTile(
            leading: Icon(Icons.contact_support, color: Theme.of(context).colorScheme.primary),
            title: Text(AppLocalizationsHelper.of(context).contactUs),
            onTap: () {
              widget.onNavigationTap?.call('contact_us');
            },
          ),
          
          // About Us
          ListTile(
            leading: Icon(Icons.info, color: Theme.of(context).colorScheme.primary),
            title: Text(AppLocalizationsHelper.of(context).aboutUs),
            onTap: () {
              widget.onNavigationTap?.call('about_us');
            },
          ),

          
          // Notifications
          Consumer<MockNotificationProvider>(
            builder: (context, notificationProvider, _) {
              final unreadCount = notificationProvider.unreadCount;
              return ListTile(
                leading: Icon(Icons.notifications, color: Theme.of(context).colorScheme.primary),
                title: Text(AppLocalizationsHelper.of(context).notifications),
                trailing: unreadCount > 0
                    ? Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            unreadCount > 9 ? '9+' : unreadCount.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    : null,
                onTap: () {
                  Navigator.of(context).pushNamed('/notifications');
                },
              );
            },
          ),
          
          // Account Settings
          ListTile(
            leading: Icon(Icons.settings, color: Theme.of(context).colorScheme.primary),
            title: Text(AppLocalizationsHelper.of(context).accountSettings),
            subtitle: Text(AppLocalizationsHelper.of(context).profilePreferences),
            onTap: () {
              widget.onNavigationTap?.call('account_settings');
            },
          ),
          
          // Profile Page - Only shown when logged in
          Consumer<UserProvider>(
            builder: (context, userProvider, _) {
              return userProvider.isLoggedIn
                ? ListTile(
                    leading: Icon(Icons.person, color: Theme.of(context).colorScheme.primary),
                    title: Text(AppLocalizationsHelper.of(context).myProfile),
                    onTap: () {
                      Navigator.of(context).pushNamed('/profile');
                    },
                  )
                : SizedBox.shrink();
            },
          ),
          
          // Login/Logout based on user status
          Consumer<UserProvider>(
            builder: (context, userProvider, _) {
              return ListTile(
                leading: Icon(
                  userProvider.isLoggedIn ? Icons.logout : Icons.login,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: Text(
                  userProvider.isLoggedIn 
                    ? AppLocalizationsHelper.logout(context) 
                    : AppLocalizationsHelper.loginRegister(context)
                ),
                onTap: () {
                  if (userProvider.isLoggedIn) {
                    // Log the user out
                    userProvider.logout();
                    
                    // Show success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(AppLocalizationsHelper.logoutSuccessful(context)),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  } else {
                    // Navigate to login page
                    Navigator.of(context).pushNamed('/login');
                  }
                },
              );
            },
          ),
          
          Divider(),
          
          // Language Switcher
          Consumer<LanguageProvider>(
            builder: (context, languageProvider, child) {
              final isEnglish = languageProvider.currentLocale.languageCode == 'en';
              
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.language, color: Theme.of(context).colorScheme.primary, size: 24),
                        SizedBox(width: 12),
                        Text(
                          isEnglish ? 'Language' : 'اللغة',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        children: [
                          // English Button
                          Expanded(
                            child: GestureDetector(
                              onTap: !isEnglish ? () {
                                languageProvider.setLocale(const Locale('en'));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Language changed to English'),
                                    duration: const Duration(seconds: 2),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              } : null,
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 200),
                                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                                decoration: BoxDecoration(
                                  color: isEnglish ? Theme.of(context).colorScheme.primary : Colors.transparent,
                                  borderRadius: BorderRadius.circular(25),
                                  boxShadow: isEnglish ? [
                                    BoxShadow(
                                      color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: Offset(0, 2),
                                    ),
                                  ] : [],
                                ),
                                child: Center(
                                  child: Text(
                                    isEnglish ? 'English' : 'الإنجليزية',
                                    style: TextStyle(
                                      color: isEnglish ? Colors.white : Colors.black54,
                                      fontWeight: isEnglish ? FontWeight.w600 : FontWeight.w400,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Arabic Button
                          Expanded(
                            child: GestureDetector(
                              onTap: isEnglish ? () {
                                languageProvider.setLocale(const Locale('ar'));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('تم تغيير اللغة إلى العربية'),
                                    duration: const Duration(seconds: 2),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              } : null,
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 200),
                                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                                decoration: BoxDecoration(
                                  color: !isEnglish ? Theme.of(context).colorScheme.primary : Colors.transparent,
                                  borderRadius: BorderRadius.circular(25),
                                  boxShadow: !isEnglish ? [
                                    BoxShadow(
                                      color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: Offset(0, 2),
                                    ),
                                  ] : [],
                                ),
                                child: Center(
                                  child: Text(
                                    isEnglish ? 'Arabic' : 'العربية',
                                    style: TextStyle(
                                      color: !isEnglish ? Colors.white : Colors.black54,
                                      fontWeight: !isEnglish ? FontWeight.w600 : FontWeight.w400,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 4),
                    Center(
                      child: Text(
                        isEnglish ? 'Arabic / English' : 'العربية / الإنجليزية',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }}