import 'package:flutter/material.dart';
import '../database_helper.dart';
import '../models/content_item.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  bool _isLoading = true;
  Color? _customPrimaryColor;
  Color? _customSecondaryColor;
  Color? _customTertiaryColor;
  // semantic lock removed - semantic tokens always derive from brand/theme

  ThemeProvider() {
    _loadSavedThemeAndColors();
  }

  // Getters
  bool get isLoading => _isLoading;
  ThemeMode get themeMode => _themeMode;
  Color? get customPrimaryColor => _customPrimaryColor;
  Color? get customSecondaryColor => _customSecondaryColor;
  Color? get customTertiaryColor => _customTertiaryColor;
  // lockSemanticColors removed

  /// Load saved theme and colors from database and API
  Future<void> _loadSavedThemeAndColors() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      // Load theme mode
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

      // Load colors
      await _loadColorsFromDatabase();

  // semantic lock flag removed; semantic tokens will derive dynamically
      
      // If no user preferences, try to load from ContentManager (API)
      if (_customPrimaryColor == null) {
        await _loadColorsFromAPI();
      }
      
    } catch (e) {
      print('[ThemeProvider] Error loading theme: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load colors from database (user preferences)
  Future<void> _loadColorsFromDatabase() async {
    try {
      // Load primary color
      final savedPrimaryHex = await DatabaseHelper().getUserPrimaryColor();
      if (savedPrimaryHex != null && savedPrimaryHex.isNotEmpty && savedPrimaryHex.startsWith('#')) {
        _customPrimaryColor = Color(int.parse(savedPrimaryHex.replaceFirst('#', '0xff')));
        print('[ThemeProvider] Loaded primary color from DB: $savedPrimaryHex');
      }
      
      // Load secondary color
      final savedSecondaryHex = await DatabaseHelper().getUserSecondaryColor();
      if (savedSecondaryHex != null && savedSecondaryHex.isNotEmpty && savedSecondaryHex.startsWith('#')) {
        _customSecondaryColor = Color(int.parse(savedSecondaryHex.replaceFirst('#', '0xff')));
        print('[ThemeProvider] Loaded secondary color from DB: $savedSecondaryHex');
      }
      // Load tertiary color
      final savedTertiaryHex = await DatabaseHelper().getUserTertiaryColor();
      if (savedTertiaryHex != null && savedTertiaryHex.isNotEmpty && savedTertiaryHex.startsWith('#')) {
        _customTertiaryColor = Color(int.parse(savedTertiaryHex.replaceFirst('#', '0xff')));
        print('[ThemeProvider] Loaded tertiary color from DB: $savedTertiaryHex');
      }
    } catch (e) {
      print('[ThemeProvider] Error loading colors from database: $e');
    }
  }

  /// Load colors from API (ContentManager)
  Future<void> _loadColorsFromAPI() async {
    if (!ContentManager.hasContent) return;
    
    try {
      // Load primary color from API
  final apiPrimaryHex = ContentManager.getColor('MainColor', '');
      if (apiPrimaryHex.isNotEmpty && apiPrimaryHex.startsWith('#')) {
        _customPrimaryColor = Color(int.parse(apiPrimaryHex.replaceFirst('#', '0xff')));
        print('[ThemeProvider] Loaded primary color from API: $apiPrimaryHex');
      }
      
      // Load secondary color from API
  final apiSecondaryHex = ContentManager.getColor('SecondaryColor', '');
      if (apiSecondaryHex.isNotEmpty && apiSecondaryHex.startsWith('#')) {
        _customSecondaryColor = Color(int.parse(apiSecondaryHex.replaceFirst('#', '0xff')));
        print('[ThemeProvider] Loaded secondary color from API: $apiSecondaryHex');
      }
      // Load tertiary color from API
  final apiTertiaryHex = ContentManager.getColor('ThirdColor', '');
      if (apiTertiaryHex.isNotEmpty && apiTertiaryHex.startsWith('#')) {
        _customTertiaryColor = Color(int.parse(apiTertiaryHex.replaceFirst('#', '0xff')));
        print('[ThemeProvider] Loaded tertiary color from API: $apiTertiaryHex');
      }
    } catch (e) {
      print('[ThemeProvider] Error loading colors from API: $e');
    }
  }

  /// Load colors from API content (call this when ContentProvider loads)
  void loadColorsFromContent() {
    if (ContentManager.hasContent) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        bool hasUpdates = false;
        
        if (_customPrimaryColor == null) {
          // Prefer API-provided color if available; don't fallback to hard-coded purple
          final apiColorHex = ContentManager.getColor('MainColor', '');
          if (apiColorHex.isNotEmpty && apiColorHex.startsWith('#')) {
            try {
              _customPrimaryColor = Color(int.parse(apiColorHex.replaceFirst('#', '0xff')));
              hasUpdates = true;
            } catch (_) {}
          }
        }
        
        if (_customSecondaryColor == null) {
          // Don't provide a hard-coded pink fallback here; use API value if present
          final apiSecondaryHex = ContentManager.getColor('SecondaryColor', '');
          if (apiSecondaryHex.isNotEmpty && apiSecondaryHex.startsWith('#')) {
            try {
              _customSecondaryColor = Color(int.parse(apiSecondaryHex.replaceFirst('#', '0xff')));
              hasUpdates = true;
            } catch (_) {}
          }
        }
        if (_customTertiaryColor == null) {
          final apiTertiaryHex = ContentManager.getColor('ThirdColor', '');
          if (apiTertiaryHex.isNotEmpty && apiTertiaryHex.startsWith('#')) {
            try {
              _customTertiaryColor = Color(int.parse(apiTertiaryHex.replaceFirst('#', '0xff')));
              hasUpdates = true;
            } catch (_) {}
          }
        }
        
        if (hasUpdates) {
          notifyListeners();
        }
      });
    }
  }

  /// Set theme mode
  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    String modeStr = 'light';
    if (mode == ThemeMode.dark) modeStr = 'dark';
    if (mode == ThemeMode.system) modeStr = 'system';
    await DatabaseHelper().setUserTheme(modeStr);
    notifyListeners();
  }

  /// Set custom primary color
  Future<void> setCustomPrimaryColor(Color? color) async {
    _customPrimaryColor = color;
    String? hex;
    if (color != null) {
      hex = '#${color.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
    }
    await DatabaseHelper().setUserPrimaryColor(hex);
    print('[ThemeProvider] Saved primary color: $hex');
    notifyListeners();
  }

  /// Set custom secondary color
  Future<void> setCustomSecondaryColor(Color? color) async {
    _customSecondaryColor = color;
    String? hex;
    if (color != null) {
      hex = '#${color.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
    }
    await DatabaseHelper().setUserSecondaryColor(hex);
    print('[ThemeProvider] Saved secondary color: $hex');
    notifyListeners();
  }

  /// Set custom tertiary color
  Future<void> setCustomTertiaryColor(Color? color) async {
    _customTertiaryColor = color;
    String? hex;
    if (color != null) {
      hex = '#${color.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
    }
    await DatabaseHelper().setUserTertiaryColor(hex);
    print('[ThemeProvider] Saved tertiary color: $hex');
    notifyListeners();
  }

  /// Set whether semantic colors should be locked to defaults
  // setLockSemanticColors removed - semantic locking is no longer supported

  /// Set both colors at once (for admin settings)
  Future<void> setAllThemeColors({
    Color? primaryColor,
    Color? secondaryColor,
  Color? tertiaryColor,
  }) async {
    bool hasChanges = false;
    
    if (primaryColor != null) {
      _customPrimaryColor = primaryColor;
      final hex = '#${primaryColor.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
      await DatabaseHelper().setUserPrimaryColor(hex);
      hasChanges = true;
    }
    
    if (secondaryColor != null) {
      _customSecondaryColor = secondaryColor;
      final hex = '#${secondaryColor.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
      await DatabaseHelper().setUserSecondaryColor(hex);
      hasChanges = true;
    }

    if (tertiaryColor != null) {
      _customTertiaryColor = tertiaryColor;
      final hex = '#${tertiaryColor.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
      await DatabaseHelper().setUserTertiaryColor(hex);
      hasChanges = true;
    }

    if (hasChanges) {
      print('[ThemeProvider] Updated all theme colors');
      notifyListeners();
    }
  }

  /// Reset colors to defaults
  Future<void> resetColors() async {
    _customPrimaryColor = null;
    _customSecondaryColor = null;
  _customTertiaryColor = null;

    await DatabaseHelper().setUserPrimaryColor(null);
    await DatabaseHelper().setUserSecondaryColor(null);
  await DatabaseHelper().setUserTertiaryColor(null);

    // Try to reload from API
    if (ContentManager.hasContent) {
      await _loadColorsFromAPI();
    }
    
    print('[ThemeProvider] Reset colors to defaults');
    notifyListeners();
  }

  /// Get colors for easy access
  Color getPrimaryColor(BuildContext context) {
    return _customPrimaryColor ?? Theme.of(context).colorScheme.primary;
  }

  Color getSecondaryColor(BuildContext context) {
    return _customSecondaryColor ?? Theme.of(context).colorScheme.secondary;
  }
}
