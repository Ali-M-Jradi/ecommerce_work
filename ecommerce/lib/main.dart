import 'package:ecommerce/pages/base_page/base_page.dart';
import 'package:ecommerce/providers/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Global navigator key for reliable navigation
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CartProvider(),
      child: MaterialApp(
        navigatorKey: navigatorKey, // Add the global navigator key
        debugShowCheckedModeBanner: false,
        title: 'DERMOCOSMETIQUE',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          fontFamily: 'Roboto',
        ),
        home: const BasePage(title: 'DERMOCOSMETIQUE'),
      ),
    );
  }
}
