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
      ],
      child: Consumer<LanguageProvider>(
        builder: (context, languageProvider, child) {
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
              primarySwatch: Colors.deepPurple,
              fontFamily: 'Roboto',
            ),
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
      ),
    );
  }
}


