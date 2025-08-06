import 'package:flutter/material.dart';

import '../database_helper.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  bool _isLoading = true;
  Color? _customPrimaryColor;

  ThemeProvider() {
    _loadSavedThemeAndColor();
  }

  bool get isLoading => _isLoading;
  ThemeMode get themeMode => _themeMode;
  Color? get customPrimaryColor => _customPrimaryColor;

  Future<void> _loadSavedThemeAndColor() async {
    final savedTheme = await DatabaseHelper().getUserTheme();
    final savedColorHex = await DatabaseHelper().getUserPrimaryColor();
    print('[ThemeProvider] Loaded theme from DB: $savedTheme, color: $savedColorHex');
    if (savedTheme == 'dark') {
      _themeMode = ThemeMode.dark;
    } else if (savedTheme == 'light') {
      _themeMode = ThemeMode.light;
    } else if (savedTheme == 'system') {
      _themeMode = ThemeMode.system;
    } else {
      _themeMode = ThemeMode.light;
    }
    if (savedColorHex != null && savedColorHex.isNotEmpty && savedColorHex.startsWith('#')) {
      try {
        _customPrimaryColor = Color(int.parse(savedColorHex.replaceFirst('#', '0xff')));
      } catch (_) {
        _customPrimaryColor = null;
      }
    } else {
      _customPrimaryColor = null;
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

  Future<void> setCustomPrimaryColor(Color? color) async {
    _customPrimaryColor = color;
    String? hex;
    if (color != null) {
      hex = '#${color.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
    }
    await DatabaseHelper().setUserPrimaryColor(hex);
    notifyListeners();
  }
}
