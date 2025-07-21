import 'package:ecommerce/pages/base_page/base_page.dart';
import 'package:ecommerce/pages/checkout_page/checkout_page.dart';
import 'package:ecommerce/pages/auth/login_page.dart';
import 'package:ecommerce/pages/auth/signup_page.dart';
import 'package:ecommerce/pages/notifications/notification_test_page.dart';
import 'package:ecommerce/pages/notifications/notifications_page.dart';
import 'package:ecommerce/pages/profile/profile_page.dart';
import 'package:ecommerce/pages/orders/order_tracking_page.dart';
import 'package:ecommerce/providers/cart_provider.dart';
import 'package:ecommerce/providers/enhanced_notification_provider.dart';
import 'package:ecommerce/providers/language_provider.dart';
import 'package:ecommerce/providers/mock_notification_provider.dart';
import 'package:ecommerce/providers/user_provider.dart';
import 'package:ecommerce/providers/theme_provider.dart';
import 'package:ecommerce/services/notification_scheduler_service.dart';
import 'package:ecommerce/services/order_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ecommerce/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce/localization/app_localizations_helper.dart';

// Global navigator key for reliable navigation
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize the notification scheduler service
  await NotificationSchedulerService.instance.initialize();
  
  // Use OrderService singleton to ensure it's ready
  OrderService.instance;
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProvider(create: (context) => LanguageProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => MockNotificationProvider()),
        ChangeNotifierProvider(create: (context) => EnhancedNotificationProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: Consumer<LanguageProvider>(
        builder: (context, languageProvider, child) {
          return Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return MaterialApp(
                navigatorKey: navigatorKey, // Add the global navigator key
                debugShowCheckedModeBanner: false,
                
                // Internationalization settings
                localizationsDelegates: [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: AppLocalizationsHelper.supportedLocales,
                locale: languageProvider.currentLocale,
                
                title: 'DERMOCOSMETIQUE',
                theme: ThemeData(
                  colorScheme: ColorScheme.light(
                    primary: Colors.deepPurpleAccent.shade700,
                    onPrimary: Colors.white,
                    secondary: Colors.deepPurple,
                    onSecondary: Colors.white,
                    background: Color(0xFFFFFBFF),
                    onBackground: Colors.black,
                    surface: Colors.white,
                    onSurface: Colors.black,
                    error: Colors.red.shade700,
                    onError: Colors.white,
                  ),
                  scaffoldBackgroundColor: Color(0xFFFFFBFF),
                  appBarTheme: AppBarTheme(
                    backgroundColor: Colors.deepPurpleAccent.shade700,
                    foregroundColor: Colors.white,
                    titleTextStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    iconTheme: IconThemeData(color: Colors.white),
                    actionsIconTheme: IconThemeData(color: Colors.white),
                  ),
                  elevatedButtonTheme: ElevatedButtonThemeData(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent.shade700,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  fontFamily: 'Roboto',
                ),
                darkTheme: ThemeData(
                  colorScheme: ColorScheme.dark(
                    primary: Colors.deepPurpleAccent,
                    onPrimary: Colors.white,
                    secondary: Colors.deepPurple,
                    onSecondary: Colors.white,
                    background: Color(0xFF181824),
                    onBackground: Colors.white,
                    surface: Color(0xFF232336),
                    onSurface: Colors.white,
                    error: Colors.red.shade400,
                    onError: Colors.black,
                  ),
                  scaffoldBackgroundColor: Color(0xFF181824),
                  appBarTheme: AppBarTheme(
                    backgroundColor: Colors.deepPurple[900],
                    foregroundColor: Colors.white,
                    titleTextStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    iconTheme: IconThemeData(color: Colors.white),
                    actionsIconTheme: IconThemeData(color: Colors.white),
                  ),
                  elevatedButtonTheme: ElevatedButtonThemeData(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  fontFamily: 'Roboto',
                ),
                themeMode: themeProvider.themeMode,
                home: const BasePage(title: 'DERMOCOSMETIQUE'),
                routes: {
                  '/checkout': (context) => const CheckoutPage(),
                  '/login': (context) => const LoginPage(),
                  '/signup': (context) => const SignUpPage(),
                  '/profile': (context) => const ProfilePage(),
                  '/notifications': (context) => const NotificationsPage(),
                  '/test-notifications': (context) => const NotificationTestPage(),
                  '/order-tracking': (context) {
                    final Map<String, dynamic> args = 
                      ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ?? {};
                    return OrderTrackingPage(
                      orderId: args['orderId'] as String?,
                    );
                  },
                },
              );
            },
          );
        },
      ),
    );
  }
}


