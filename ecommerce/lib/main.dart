
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
import 'package:ecommerce/pages/admin/content_management_page.dart';
import 'package:ecommerce/pages/admin/content_test_widget.dart';
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
import 'package:ecommerce/providers/product_provider.dart';
import 'package:ecommerce/providers/content_provider.dart';
import 'package:ecommerce/pages/auth/auth_provider.dart';
import 'package:ecommerce/pages/debug_image_page.dart';

// Global navigator key for reliable navigation
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

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
        ChangeNotifierProvider(create: (context) => ProductProvider()), // <-- Added for product sync
        ChangeNotifierProvider(create: (context) => ContentProvider()), // <-- Added for content management
        ChangeNotifierProvider(create: (context) => AuthProvider()), // <-- Added for API authentication
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
                theme: _buildTheme(themeProvider, false),
                darkTheme: _buildTheme(themeProvider, true),
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
                  '/admin/content': (context) => const AdminContentManagementPage(),
                  '/admin/content-test': (context) => const ContentTestWidget(),
                  '/debug/images': (context) => const ImageDebugPage(),
                },
              );
            },
          );
        },
      ),
    );
  }

  /// Build theme data with custom colors
  ThemeData _buildTheme(ThemeProvider themeProvider, bool isDark) {
    final primaryColor = themeProvider.customPrimaryColor ?? 
        (isDark ? Colors.deepPurpleAccent : Colors.deepPurpleAccent.shade700);
    final secondaryColor = themeProvider.customSecondaryColor ?? 
        (isDark ? Colors.deepPurple : Colors.deepPurple);

    final colorScheme = isDark 
        ? ColorScheme.dark(
            primary: primaryColor,
            secondary: secondaryColor,
          )
        : ColorScheme.light(
            primary: primaryColor,
            secondary: secondaryColor,
          );

    return ThemeData(
      colorScheme: colorScheme,
      fontFamily: mainFontFamily,
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: colorScheme.onPrimary,
        elevation: 4,
        shadowColor: primaryColor.withOpacity(0.3),
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: colorScheme.onPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 20,
          fontFamily: mainFontFamily,
          letterSpacing: 0.5,
        ),
        iconTheme: IconThemeData(color: colorScheme.onPrimary, size: 24),
        actionsIconTheme: IconThemeData(color: colorScheme.onPrimary, size: 24),
        toolbarHeight: 64,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(16),
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: colorScheme.onPrimary,
          elevation: 4,
          shadowColor: primaryColor.withOpacity(0.3),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            letterSpacing: 0.5,
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: colorScheme.onPrimary,
        elevation: 8,
        highlightElevation: 12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        sizeConstraints: BoxConstraints.tightFor(
          width: 56,
          height: 56,
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: primaryColor,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.selected) ? primaryColor : null;
        }),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.selected) ? primaryColor : null;
        }),
      ),
      cardTheme: CardThemeData(
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
}

