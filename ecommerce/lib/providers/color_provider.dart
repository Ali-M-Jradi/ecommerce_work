import 'package:flutter/material.dart';
import '../services/color_service.dart';

/// Provider to manage app colors from the API
class ColorProvider extends ChangeNotifier {
  List<ColorOption> _availableColors = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<ColorOption> get availableColors => List.unmodifiable(_availableColors);
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasColors => _availableColors.isNotEmpty;

  /// Load available colors from API
  Future<void> loadColors() async {
    if (_isLoading) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _availableColors = await ColorService.getAvailableColors();
      _error = null;
      print('✅ ColorProvider: Loaded ${_availableColors.length} colors');
    } catch (e) {
      _error = e.toString();
      _availableColors = [];
      print('❌ ColorProvider: Error loading colors - $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Refresh colors (force reload)
  Future<void> refreshColors() async {
    _availableColors.clear();
    await loadColors();
  }

  /// Add new color
  @Deprecated('UI no longer exposes direct color creation. Use API or admin console. Kept for backward compatibility.')
  Future<bool> addColor(String name, String hexValue) async {
    try {
      final success = await ColorService.addColor(name, hexValue);
      if (success) {
        await refreshColors(); // Reload to get the new color with proper ID
        return true;
      }
      return false;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Update existing color
  @Deprecated('UI no longer exposes direct color updates. Use API or admin console. Kept for backward compatibility.')
  Future<bool> updateColor(int id, String name, String hexValue) async {
    try {
      final success = await ColorService.updateColor(id, name, hexValue);
      if (success) {
        await refreshColors(); // Reload to get updated data
        return true;
      }
      return false;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Delete color
  @Deprecated('UI no longer exposes direct color deletion. Use API or admin console. Kept for backward compatibility.')
  Future<bool> deleteColor(int id) async {
    try {
      final success = await ColorService.deleteColor(id);
      if (success) {
        _availableColors.removeWhere((color) => color.id == id);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Find color by name
  ColorOption? findColorByName(String name) {
    try {
      return _availableColors.firstWhere(
        (color) => color.name.toLowerCase() == name.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }

  /// Find color by hex value
  ColorOption? findColorByHex(String hexValue) {
    try {
      return _availableColors.firstWhere(
        (color) => color.hexValue.toLowerCase() == hexValue.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }

  /// Get main theme colors (MainColor, SecondaryColor, ThirdColor)
  Map<String, ColorOption?> getMainThemeColors() {
    return {
      'MainColor': findColorByName('MainColor'),
      'SecondaryColor': findColorByName('SecondaryColor'), 
      'ThirdColor': findColorByName('ThirdColor'),
    };
  }

  /// Get colors suitable for primary theme use
  List<ColorOption> getPrimaryColors() {
    return _availableColors.where((color) {
      // Filter for colors that would work well as primary colors
      // Exclude very light colors like white
  final isDarkEnough = _calculateLuminance(color.color) < 0.7;
  // Exclude explicitly purple-named or purple hex colors
  final nameLower = color.name.toLowerCase();
  final hexLower = color.hexValue.toLowerCase();
  final isPurpleName = nameLower.contains('purple') || nameLower.contains('deep purple') || nameLower.contains('violet');
  final isPurpleHex = hexLower == '#673ab7' || hexLower == '#9c27b0' || hexLower.startsWith('#9c') || hexLower.startsWith('#67');
  return isDarkEnough && !isPurpleName && !isPurpleHex;
    }).toList();
  }

  /// Get colors suitable for secondary/accent use
  List<ColorOption> getSecondaryColors() {
    // Allow secondary colors but exclude explicit purple options to match product rule
    return _availableColors.where((c) {
      final nameLower = c.name.toLowerCase();
      final hexLower = c.hexValue.toLowerCase();
      final isPurpleName = nameLower.contains('purple') || nameLower.contains('violet') || nameLower.contains('deep purple');
      final isPurpleHex = hexLower == '#673ab7' || hexLower == '#9c27b0' || hexLower.startsWith('#9c') || hexLower.startsWith('#67');
      return !isPurpleName && !isPurpleHex;
    }).toList();
  }

  /// Calculate luminance to determine if color is dark enough for primary use
  double _calculateLuminance(Color color) {
    final r = color.red / 255;
    final g = color.green / 255;
    final b = color.blue / 255;
    
    return 0.2126 * r + 0.7152 * g + 0.0722 * b;
  }

  /// Clear error state
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
