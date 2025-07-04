import 'package:flutter/material.dart';
import 'package:ecommerce/l10n/app_localizations.dart';
import '../models/order.dart';

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

  // Get localized order status text
  static String getLocalizedOrderStatus(BuildContext context, OrderStatus status) {
    final localizations = of(context);
    switch (status) {
      case OrderStatus.pending:
        return localizations.orderStatusPending;
      case OrderStatus.confirmed:
        return localizations.orderStatusConfirmed;
      case OrderStatus.processing:
        return localizations.orderStatusProcessing;
      case OrderStatus.shipped:
        return localizations.orderStatusShipped;
      case OrderStatus.delivered:
        return localizations.orderStatusDelivered;
      case OrderStatus.cancelled:
        return localizations.orderStatusCancelled;
      case OrderStatus.refunded:
        return localizations.orderStatusRefunded;
    }
  }
}
