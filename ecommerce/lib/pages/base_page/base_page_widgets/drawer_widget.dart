import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../localization/app_localizations_helper.dart';
import '../../../providers/language_provider.dart';
import '../../../providers/user_provider.dart';

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
          Consumer<UserProvider>(
            builder: (context, userProvider, _) {
              final bool isLoggedIn = userProvider.isLoggedIn;
              final String displayEmail = isLoggedIn 
                ? userProvider.currentUser!.email 
                : AppLocalizationsHelper.of(context).notLoggedIn;
              
              return DrawerHeader(
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
                        isLoggedIn ? Icons.person : Icons.person_outline,
                        size: 35,
                        color: Colors.deepPurpleAccent.shade700,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      isLoggedIn 
                        ? AppLocalizationsHelper.welcomeUser(context, userProvider.currentUser!.displayName) 
                        : AppLocalizationsHelper.of(context).welcome,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      displayEmail,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              );
            }
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
            leading: Icon(Icons.settings, color: Colors.deepPurpleAccent.shade700),
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
                    leading: Icon(Icons.person, color: Colors.deepPurpleAccent.shade700),
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
                  color: Colors.deepPurpleAccent.shade700,
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
                        Icon(Icons.language, color: Colors.deepPurpleAccent.shade700, size: 24),
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
                                  color: isEnglish ? Colors.deepPurpleAccent.shade700 : Colors.transparent,
                                  borderRadius: BorderRadius.circular(25),
                                  boxShadow: isEnglish ? [
                                    BoxShadow(
                                      color: Colors.deepPurpleAccent.shade700.withOpacity(0.3),
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
                                  color: !isEnglish ? Colors.deepPurpleAccent.shade700 : Colors.transparent,
                                  borderRadius: BorderRadius.circular(25),
                                  boxShadow: !isEnglish ? [
                                    BoxShadow(
                                      color: Colors.deepPurpleAccent.shade700.withOpacity(0.3),
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
  }
}