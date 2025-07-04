import 'package:flutter/material.dart';
import '../pages/products_page/products_page_widgets/products_page_service.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _currentLocale = const Locale('en');

  Locale get currentLocale => _currentLocale;

  void setLocale(Locale locale) {
    _currentLocale = locale;
    // Clear products cache when language changes
    ProductsPageService().clearCache();
    notifyListeners();
  }

  void toggleLanguage() {
    if (_currentLocale.languageCode == 'en') {
      _currentLocale = const Locale('ar');
    } else {
      _currentLocale = const Locale('en');
    }
    // Clear products cache when language changes
    ProductsPageService().clearCache();
    notifyListeners();
  }
}
