import 'package:flutter/material.dart';
import 'package:ecommerce/models/admin/customization_settings.dart';
import 'package:ecommerce/services/admin/settings_service.dart';

class SettingsProvider extends ChangeNotifier {
  CustomizationSettings? _settings;
  bool _isLoading = false;
  String? _error;

  CustomizationSettings? get settings => _settings;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadSettings() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _settings = await SettingsService.instance.fetchCustomizationSettings();
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> saveSettings(CustomizationSettings newSettings) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await SettingsService.instance.saveCustomizationSettings(newSettings);
      _settings = newSettings;
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }
}
