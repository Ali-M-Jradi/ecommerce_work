import 'package:flutter/material.dart';
import 'package:ecommerce/l10n/app_localizations.dart';

class AppLocalizationsHelper {
  // Private constructor
  AppLocalizationsHelper._();

  // Singleton instance
  static final AppLocalizationsHelper _instance = AppLocalizationsHelper._();

  // Factory constructor to return the singleton instance
  factory AppLocalizationsHelper() => _instance;

  // Get the current localization for the given context
  static AppLocalizations of(BuildContext context) {
    return AppLocalizations.of(context)!;
  }

  // List of supported locales
  static const List<Locale> supportedLocales = [
    Locale('en'), // English
    Locale('ar'), // Arabic
  ];

  // Get the delegate for localization
  static const LocalizationsDelegate<AppLocalizations> delegate =
      AppLocalizations.delegate;
}
