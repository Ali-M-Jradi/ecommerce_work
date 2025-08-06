
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce/l10n/app_localizations.dart';
import 'package:ecommerce/localization/app_localizations_helper.dart';
import 'package:ecommerce/pages/base_page/base_page.dart';
import 'package:ecommerce/pages/checkout_page/checkout_page.dart';
import 'package:ecommerce/pages/auth/login_page.dart';
import 'package:ecommerce/pages/auth/signup_page.dart';
import 'package:ecommerce/pages/notifications/notification_test_page.dart';
import 'package:ecommerce/pages/notifications/notifications_page.dart';
import 'package:ecommerce/pages/profile/profile_page.dart';
import 'package:ecommerce/pages/orders/order_tracking_page.dart';
import 'package:ecommerce/pages/products_page/products_page_widgets/wishlist_page.dart';
import 'package:ecommerce/pages/admin/admin_dashboard_page.dart';
import 'package:ecommerce/pages/admin/admin_settings_page.dart';
import 'package:ecommerce/pages/admin/parameters_page.dart';
import 'package:ecommerce/pages/admin/attributes_page.dart';
import 'package:ecommerce/pages/admin/categories_page.dart';
import 'package:ecommerce/pages/admin/products_page.dart';
import 'package:ecommerce/pages/admin/users_page.dart';
import 'package:ecommerce/pages/admin/brands_page.dart';
import 'package:ecommerce/pages/admin/prices_page.dart';
import 'package:ecommerce/pages/admin/orders_page.dart';
import 'package:ecommerce/pages/admin/currencies_page.dart';
import 'package:ecommerce/pages/loyalty_program_page.dart';
import 'package:ecommerce/services/notification_scheduler_service.dart';
import 'package:ecommerce/services/order_service.dart';
import 'package:ecommerce/providers/cart_provider.dart';
import 'package:ecommerce/providers/enhanced_notification_provider.dart';
import 'package:ecommerce/providers/language_provider.dart';
import 'package:ecommerce/providers/mock_notification_provider.dart';
import 'package:ecommerce/providers/user_provider.dart';
import 'package:ecommerce/providers/theme_provider.dart';
import 'package:ecommerce/providers/admin/settings_provider.dart';
import 'package:ecommerce/providers/category_provider.dart';
import 'package:ecommerce/providers/wishlist_provider.dart';
import 'package:ecommerce/providers/order_provider.dart';
import 'package:ecommerce/providers/parameter_provider.dart';
import 'package:ecommerce/providers/currency_provider.dart';
import 'package:ecommerce/providers/brand_provider.dart';
import 'package:ecommerce/providers/admin_user_provider.dart';

// Global navigator key for reliable navigation

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// Main theme variables for easy access and extension
final ColorScheme lightColorScheme = ColorScheme.light(
  primary: Colors.deepPurpleAccent.shade700,
  onPrimary: Colors.white,
  secondary: Colors.deepPurple,
  onSecondary: Colors.white,
  surface: Colors.white,
  onSurface: Colors.black,
  error: Colors.red.shade700,
  onError: Colors.white,
);

final ColorScheme darkColorScheme = ColorScheme.dark(
  primary: Colors.deepPurpleAccent,
  onPrimary: Colors.white,
  secondary: Colors.deepPurple,
  onSecondary: Colors.white,
  surface: const Color(0xFF232336),
  onSurface: Colors.white,
  error: Colors.red.shade400,
  onError: Colors.black,
);

const String mainFontFamily = 'Roboto';

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
        ChangeNotifierProvider(create: (context) => SettingsProvider()),
        ChangeNotifierProvider(create: (context) => CategoryProvider()),
        ChangeNotifierProvider(create: (context) => WishlistProvider()),
        ChangeNotifierProvider(create: (context) => OrderProvider()),
        ChangeNotifierProvider(create: (context) => ParameterProvider()),
        ChangeNotifierProvider(create: (context) => CurrencyProvider()),
        ChangeNotifierProvider(create: (context) => BrandProvider()),
        ChangeNotifierProvider(create: (context) => AdminUserProvider()),
      ],
      child: Consumer<LanguageProvider>(
        builder: (context, languageProvider, child) {
          if (languageProvider.isLoading) {
            // Show a loading indicator until language is loaded
            return const MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                body: Center(child: CircularProgressIndicator()),
              ),
            );
          }
          return Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              if (themeProvider.isLoading) {
                // Show a loading indicator until theme is loaded
                return const MaterialApp(
                  debugShowCheckedModeBanner: false,
                  home: Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  ),
                );
              }
              return MaterialApp(
                navigatorKey: navigatorKey,
                debugShowCheckedModeBanner: false,
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
                  colorScheme: lightColorScheme.copyWith(
                    primary: themeProvider.customPrimaryColor ?? lightColorScheme.primary,
                  ),
                  scaffoldBackgroundColor: lightColorScheme.surface,
                  appBarTheme: AppBarTheme(
                    backgroundColor: themeProvider.customPrimaryColor ?? lightColorScheme.primary,
                    foregroundColor: lightColorScheme.onPrimary,
                    titleTextStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    iconTheme: const IconThemeData(color: Colors.white),
                    actionsIconTheme: const IconThemeData(color: Colors.white),
                  ),
                  elevatedButtonTheme: ElevatedButtonThemeData(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeProvider.customPrimaryColor ?? lightColorScheme.primary,
                      foregroundColor: lightColorScheme.onPrimary,
                    ),
                  ),
                  snackBarTheme: SnackBarThemeData(
                    actionTextColor: themeProvider.customPrimaryColor ?? lightColorScheme.primary,
                  ),
                  fontFamily: mainFontFamily,
                ),
                darkTheme: ThemeData(
                  colorScheme: darkColorScheme.copyWith(
                    primary: themeProvider.customPrimaryColor ?? darkColorScheme.primary,
                  ),
                  scaffoldBackgroundColor: darkColorScheme.surface,
                  appBarTheme: AppBarTheme(
                    backgroundColor: themeProvider.customPrimaryColor ?? darkColorScheme.primary,
                    foregroundColor: darkColorScheme.onPrimary,
                    titleTextStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    iconTheme: const IconThemeData(color: Colors.white),
                    actionsIconTheme: const IconThemeData(color: Colors.white),
                  ),
                  elevatedButtonTheme: ElevatedButtonThemeData(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeProvider.customPrimaryColor ?? darkColorScheme.primary,
                      foregroundColor: darkColorScheme.onPrimary,
                    ),
                  ),
                  snackBarTheme: SnackBarThemeData(
                    actionTextColor: themeProvider.customPrimaryColor ?? darkColorScheme.primary,
                  ),
                  fontFamily: mainFontFamily,
                ),
                themeMode: themeProvider.themeMode,
                home: const BasePage(title: 'DERMOCOSMETIQUE'),
                routes: {
                  '/wishlist': (context) => const WishlistPage(),
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
                  // Admin dashboard
                  '/admin/dashboard': (context) => const AdminDashboardPage(),
                  // '/admin/customization': (context) => const CustomizationPage(),
                  '/admin/currencies': (context) => const CurrenciesPage(),
                  '/admin/loyalty': (context) => const LoyaltyProgramPage(),
                  '/admin/parameters': (context) => const ParametersPage(),
                  '/admin/settings': (context) => const AdminSettingsPage(),
                  '/admin/attributes': (context) => const AttributesPage(),
                  '/admin/categories': (context) => const CategoriesPage(),
                  '/admin/products': (context) => const ProductsPage(),
                  '/admin/users': (context) => const UsersPage(),
                  '/admin/brands': (context) => const BrandsPage(),
                  '/admin/prices': (context) => const PricesPage(),
                  '/admin/orders': (context) => const OrdersPage(),
                },
              );
            },
          );
        },
      ),
    );
  }
}

