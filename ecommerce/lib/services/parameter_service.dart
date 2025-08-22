import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/parameter_provider.dart';
import '../models/parameter.dart';

/// Service that connects admin parameters to actual app behavior
/// This ensures that changes made in the admin panel immediately affect the app
class ParameterService {
  static final ParameterService _instance = ParameterService._internal();
  factory ParameterService() => _instance;
  ParameterService._internal();

  static ParameterService get instance => _instance;

  /// Get parameter value with fallback
  static String getParameterValue(BuildContext context, String key, {String fallback = ''}) {
    try {
      final paramProvider = Provider.of<ParameterProvider>(context, listen: false);
      final param = paramProvider.parameters.firstWhere(
        (p) => p.key == key,
        orElse: () => Parameter(key: key, value: fallback),
      );
      return param.value;
    } catch (e) {
      return fallback;
    }
  }

  /// Get parameter value as boolean
  static bool getParameterBool(BuildContext context, String key, {bool fallback = false}) {
    final value = getParameterValue(context, key, fallback: fallback.toString());
    return value.toLowerCase() == 'true';
  }

  /// Get parameter value as double
  static double getParameterDouble(BuildContext context, String key, {double fallback = 0.0}) {
    final value = getParameterValue(context, key, fallback: fallback.toString());
    return double.tryParse(value) ?? fallback;
  }

  /// Get parameter value as int
  static int getParameterInt(BuildContext context, String key, {int fallback = 0}) {
    final value = getParameterValue(context, key, fallback: fallback.toString());
    return int.tryParse(value) ?? fallback;
  }

  // =============================================
  // SPECIFIC PARAMETER GETTERS FOR APP BEHAVIOR
  // =============================================

  /// Check if maintenance mode is enabled
  static bool isMaintenanceModeEnabled(BuildContext context) {
    return getParameterBool(context, 'maintenance_mode', fallback: false);
  }

  /// Get free shipping threshold
  static double getFreeShippingThreshold(BuildContext context) {
    return getParameterDouble(context, 'free_shipping_threshold', fallback: 50.0);
  }

  /// Get shipping tax percentage
  static double getShippingTax(BuildContext context) {
    return getParameterDouble(context, 'shipping_tax', fallback: 5.0);
  }

  /// Get support email
  static String getSupportEmail(BuildContext context) {
    return getParameterValue(context, 'support_email', fallback: 'support@dermocosmetique.com');
  }

  /// Get support phone
  static String getSupportPhone(BuildContext context) {
    return getParameterValue(context, 'support_phone', fallback: '+1234567890');
  }

  /// Get app version message
  static String getAppVersionMessage(BuildContext context) {
    return getParameterValue(context, 'app_version_message', fallback: '');
  }

  /// Get default currency
  static String getDefaultCurrency(BuildContext context) {
    return getParameterValue(context, 'default_currency', fallback: 'USD');
  }

  /// Get welcome message
  static String getWelcomeMessage(BuildContext context) {
    return getParameterValue(context, 'welcome_message', fallback: 'Welcome to Dermocosmetique');
  }

  /// Get global discount rate
  static double getDiscountRate(BuildContext context) {
    return getParameterDouble(context, 'discount_rate', fallback: 0.0);
  }

  /// Get maximum cart items allowed
  static int getMaxCartItems(BuildContext context) {
    return getParameterInt(context, 'max_cart_items', fallback: 99);
  }

  /// Get minimum order value
  static double getMinOrderValue(BuildContext context) {
    return getParameterDouble(context, 'min_order_value', fallback: 1.0);
  }

  /// Get loyalty points earning rate (points per dollar spent)
  static double getLoyaltyPointsRate(BuildContext context) {
    return getParameterDouble(context, 'loyalty_points_rate', fallback: 1.0);
  }

  /// Get contact WhatsApp number
  static String getWhatsAppNumber(BuildContext context) {
    return getParameterValue(context, 'whatsapp_number', fallback: '');
  }

  /// Get Instagram handle
  static String getInstagramHandle(BuildContext context) {
    return getParameterValue(context, 'instagram_handle', fallback: '');
  }

  /// Get Facebook page URL
  static String getFacebookUrl(BuildContext context) {
    return getParameterValue(context, 'facebook_url', fallback: '');
  }

  // =============================================
  // LIVE PARAMETER UPDATE METHODS
  // =============================================

  /// Set parameter value and save immediately
  static Future<void> setParameter(BuildContext context, String key, String value) async {
    final paramProvider = Provider.of<ParameterProvider>(context, listen: false);
    final existingIndex = paramProvider.parameters.indexWhere((p) => p.key == key);
    
    if (existingIndex >= 0) {
      paramProvider.updateParameter(existingIndex, Parameter(key: key, value: value));
    } else {
      paramProvider.addParameter(Parameter(key: key, value: value));
    }
  }

  /// Toggle boolean parameter
  static Future<void> toggleBoolParameter(BuildContext context, String key) async {
    final currentValue = getParameterBool(context, key);
    await setParameter(context, key, (!currentValue).toString());
  }

  // =============================================
  // PARAMETER-DRIVEN UI HELPERS
  // =============================================

  /// Get maintenance banner widget if maintenance mode is on
  static Widget? getMaintenanceBanner(BuildContext context) {
    if (!isMaintenanceModeEnabled(context)) return null;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      color: Colors.orange,
      child: const Text(
        'Maintenance Mode: Some features may be temporarily unavailable',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }

  /// Calculate shipping cost based on parameters
  static double calculateShipping(BuildContext context, double orderValue) {
    final threshold = getFreeShippingThreshold(context);
    final tax = getShippingTax(context);
    
    if (orderValue >= threshold) {
      return 0.0; // Free shipping
    }
    
    // Basic shipping cost with tax
    const baseShipping = 5.99;
    return baseShipping + (baseShipping * tax / 100);
  }

  /// Apply global discount if configured
  static double applyGlobalDiscount(BuildContext context, double price) {
    final discountRate = getDiscountRate(context);
    if (discountRate > 0) {
      return price * (1 - discountRate / 100);
    }
    return price;
  }

  /// Validate cart size against parameter limits
  static bool isCartSizeValid(BuildContext context, int itemCount) {
    final maxItems = getMaxCartItems(context);
    return itemCount <= maxItems;
  }

  /// Get cart size error message
  static String getCartSizeErrorMessage(BuildContext context) {
    final maxItems = getMaxCartItems(context);
    return 'Maximum $maxItems items allowed in cart';
  }

  /// Validate minimum order value
  static bool isOrderValueValid(BuildContext context, double orderValue) {
    final minValue = getMinOrderValue(context);
    return orderValue >= minValue;
  }

  /// Get minimum order error message
  static String getMinOrderErrorMessage(BuildContext context) {
    final minValue = getMinOrderValue(context);
    return 'Minimum order value is \$${minValue.toStringAsFixed(2)}';
  }
}
