import 'package:flutter/material.dart';
import '../pages/products_page/products_page_widgets/products_page_service.dart';
import '../database_helper.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _currentLocale = const Locale('en');
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  LanguageProvider() {
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    final savedLang = await DatabaseHelper().getUserLanguage();
    print('[LanguageProvider] Loaded language from DB: $savedLang');
    if (savedLang != null && (savedLang == 'en' || savedLang == 'ar')) {
      _currentLocale = Locale(savedLang);
    } else {
      _currentLocale = const Locale('en');
    }
    ProductsPageService().clearCache();
    _isLoading = false;
    notifyListeners();
  }

  Locale get currentLocale => _currentLocale;

  void setLocale(Locale locale) async {
    _currentLocale = locale;
    print('[LanguageProvider] Saving language to DB: ${locale.languageCode}');
    // Save language to DB
    await DatabaseHelper().setUserLanguage(locale.languageCode);
    // Clear products cache when language changes
    ProductsPageService().clearCache();
    notifyListeners();
  }

  void toggleLanguage() async {
    if (_currentLocale.languageCode == 'en') {
      _currentLocale = const Locale('ar');
    } else {
      _currentLocale = const Locale('en');
    }
    print('[LanguageProvider] Saving language to DB (toggle): ${_currentLocale.languageCode}');
    // Save language to DB
    await DatabaseHelper().setUserLanguage(_currentLocale.languageCode);
    // Clear products cache when language changes
    ProductsPageService().clearCache();
    notifyListeners();
  }
}
