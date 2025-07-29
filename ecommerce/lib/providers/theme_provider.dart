import 'package:flutter/material.dart';

import '../database_helper.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  bool _isLoading = true;

  ThemeProvider() {
    _loadSavedTheme();
  }

  bool get isLoading => _isLoading;
  ThemeMode get themeMode => _themeMode;

  Future<void> _loadSavedTheme() async {
    final savedTheme = await DatabaseHelper().getUserTheme();
    print('[ThemeProvider] Loaded theme from DB: $savedTheme');
    if (savedTheme == 'dark') {
      _themeMode = ThemeMode.dark;
    } else if (savedTheme == 'light') {
      _themeMode = ThemeMode.light;
    } else if (savedTheme == 'system') {
      _themeMode = ThemeMode.system;
    } else {
      _themeMode = ThemeMode.light;
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    String modeStr = 'light';
    if (mode == ThemeMode.dark) modeStr = 'dark';
    if (mode == ThemeMode.system) modeStr = 'system';
    await DatabaseHelper().setUserTheme(modeStr);
    notifyListeners();
  }
}
