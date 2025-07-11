import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';
import 'package:ecommerce/services/local_notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import 'dart:ui' as ui;

/// A service for scheduling notifications related to orders, promotions, etc.
/// This service leverages the existing notification infrastructure but adds 
/// scheduling capabilities specifically tailored for e-commerce scenarios.
class NotificationSchedulerService {
  static final NotificationSchedulerService _instance = NotificationSchedulerService._();
  static NotificationSchedulerService get instance => _instance;
  
  final LocalNotificationService _notificationService = LocalNotificationService.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  
  // For storing scheduled notifications
  late SharedPreferences _prefs;
  final String _scheduledNotificationsKey = 'scheduled_notifications';
  
  // Private constructor
  NotificationSchedulerService._();
  
  /// Initialize the scheduler service
  Future<void> initialize() async {
    // Initialize shared preferences for storing scheduled notifications
    _prefs = await SharedPreferences.getInstance();
    
    // Initialize timezone data
    tz_data.initializeTimeZones();
    
    // Make sure notification service is initialized
    await _notificationService.initialize();
  }
  
  /// Schedule an order confirmation notification immediately after an order is placed
  Future<void> scheduleOrderConfirmation(String orderId, String customerName, double orderTotal) async {
    // Get the current locale
    final String languageCode = ui.window.locale.languageCode;
    final bool isArabic = languageCode == 'ar';
    
    final String title = isArabic
        ? 'تأكيد الطلب #$orderId'
        : 'Order Confirmation #$orderId';
        
    final String body = isArabic
        ? 'شكراً لك $customerName! تم استلام طلبك بقيمة \$${orderTotal.toStringAsFixed(2)}.'
        : 'Thank you, $customerName! Your order for \$${orderTotal.toStringAsFixed(2)} has been received.';
    
    // Send notification immediately
    await _notificationService.showNotification(
      title: title, 
      body: body,
      payload: jsonEncode({
        'type': 'order',
        'action': 'confirmation',
        'orderId': orderId,
      }),
    );
    
    // Store notification in history
    _storeNotification(title, body, 'order', DateTime.now());
  }

  /// Schedule a payment confirmation notification when payment is processed
  Future<void> schedulePaymentConfirmation(String orderId, double amount) async {
    // Get the current locale
    final String languageCode = ui.window.locale.languageCode;
    final bool isArabic = languageCode == 'ar';
    
    final String title = isArabic
        ? 'تأكيد الدفع'
        : 'Payment Confirmed';
        
    final String body = isArabic
        ? 'تمت عملية الدفع بنجاح بقيمة \$${amount.toStringAsFixed(2)} للطلب رقم #$orderId.'
        : 'Your payment of \$${amount.toStringAsFixed(2)} for order #$orderId was successful.';
    
    // Send notification immediately
    await _notificationService.showNotification(
      title: title, 
      body: body,
      payload: jsonEncode({
        'type': 'order',
        'action': 'payment',
        'orderId': orderId,
      }),
    );
    
    // Store notification in history
    _storeNotification(title, body, 'order', DateTime.now());
  }

  /// Schedule a shipping notification when order is shipped
  Future<void> scheduleShippingNotification(String orderId, DateTime estimatedDelivery) async {
    // Get the current locale
    final String languageCode = ui.window.locale.languageCode;
    final bool isArabic = languageCode == 'ar';
    
    final String title = isArabic
        ? 'تم شحن طلبك رقم #$orderId'
        : 'Your Order #$orderId Has Been Shipped';
        
    final String body = isArabic
        ? 'طلبك في الطريق! موعد التسليم المتوقع: ${_formatDate(estimatedDelivery)}.'
        : 'Your order is on its way! Expected delivery: ${_formatDate(estimatedDelivery)}.';
    
    // Send notification immediately
    await _notificationService.showNotification(
      title: title, 
      body: body,
      payload: jsonEncode({
        'type': 'order',
        'action': 'shipping',
        'orderId': orderId,
      }),
    );
    
    // Store notification in history
    _storeNotification(title, body, 'order', DateTime.now());
    
    // Schedule delivery reminder notification
    await scheduleDeliveryReminder(orderId, estimatedDelivery);
  }
  
  /// Schedule a delivery reminder for the day before estimated delivery
  Future<void> scheduleDeliveryReminder(String orderId, DateTime estimatedDelivery) async {
    // Calculate reminder date (one day before delivery)
    final reminderDate = estimatedDelivery.subtract(const Duration(days: 1));
    
    // If reminder date is in the past, don't schedule
    if (reminderDate.isBefore(DateTime.now())) {
      return;
    }
    
    // Get the current locale
    final String languageCode = ui.window.locale.languageCode;
    final bool isArabic = languageCode == 'ar';
    
    final String title = isArabic
        ? 'طلبك رقم #$orderId يصل غداً'
        : 'Your Order #$orderId Arrives Tomorrow';
        
    final String body = isArabic
        ? 'من المقرر تسليم طلبك غداً. تأكد من وجود شخص ما لاستلامه!'
        : 'Your package is scheduled for delivery tomorrow. Make sure someone is available to receive it!';
    
    // Create notification details
    final androidDetails = const AndroidNotificationDetails(
      'order_delivery_reminders',
      'Order Delivery Reminders',
      channelDescription: 'Notifications about upcoming order deliveries',
      importance: Importance.high,
      priority: Priority.high,
    );
    
    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: const DarwinNotificationDetails(),
    );
    
    // Schedule the notification
    final id = _generateNotificationId();
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      _nextInstanceOfTime(reminderDate.hour, reminderDate.minute, reminderDate.day, reminderDate.month, reminderDate.year),
      notificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      payload: jsonEncode({
        'type': 'order',
        'action': 'delivery_reminder',
        'orderId': orderId,
      }),
    );
    
    // Store scheduled notification
    _storeScheduledNotification(id, title, body, 'order', reminderDate);
  }
  
  /// Schedule a delivery confirmation notification
  Future<void> scheduleDeliveryConfirmation(String orderId) async {
    // Get the current locale
    final String languageCode = ui.window.locale.languageCode;
    final bool isArabic = languageCode == 'ar';
    
    final String title = isArabic
        ? 'تم تسليم الطلب رقم #$orderId'
        : 'Order #$orderId Delivered';
        
    final String body = isArabic
        ? 'تم تسليم طلبك. استمتع بمنتجاتك!'
        : 'Your order has been delivered. Enjoy your products!';
    
    // Send notification immediately
    await _notificationService.showNotification(
      title: title, 
      body: body,
      payload: jsonEncode({
        'type': 'order',
        'action': 'delivered',
        'orderId': orderId,
      }),
    );
    
    // Store notification in history
    _storeNotification(title, body, 'order', DateTime.now());
    
    // Schedule review request for 3 days later
    await scheduleReviewRequest(orderId);
  }
  
  /// Schedule a review request notification a few days after delivery
  Future<void> scheduleReviewRequest(String orderId) async {
    // Schedule review request for 3 days after delivery
    final reviewRequestDate = DateTime.now().add(const Duration(days: 3));
    
    // Get the current locale
    final String languageCode = ui.window.locale.languageCode;
    final bool isArabic = languageCode == 'ar';
    
    final String title = isArabic
        ? 'كيف كان طلبك؟'
        : 'How Was Your Order?';
        
    final String body = isArabic
        ? 'نأمل أن تستمتع بمنتجاتك! يرجى أخذ لحظة لمشاركة رأيك.'
        : 'We hope you\'re enjoying your products! Please take a moment to share your thoughts.';
    
    // Create notification details
    final androidDetails = const AndroidNotificationDetails(
      'review_requests',
      'Review Requests',
      channelDescription: 'Requests for product reviews after purchase',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    );
    
    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: const DarwinNotificationDetails(),
    );
    
    // Schedule the notification
    final id = _generateNotificationId();
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      _nextInstanceOfTime(reviewRequestDate.hour, reviewRequestDate.minute, reviewRequestDate.day, reviewRequestDate.month, reviewRequestDate.year),
      notificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      payload: jsonEncode({
        'type': 'order',
        'action': 'review_request',
        'orderId': orderId,
      }),
    );
    
    // Store scheduled notification
    _storeScheduledNotification(id, title, body, 'order', reviewRequestDate);
  }
  
  // Helper method to generate a notification ID
  int _generateNotificationId() {
    return DateTime.now().millisecondsSinceEpoch.remainder(100000);
  }
  
  // Helper method to format a date
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
  
  // Store a notification in the history
  Future<void> _storeNotification(String title, String body, String type, DateTime time) async {
    final notifications = _prefs.getStringList('notification_history') ?? [];
    
    notifications.add(jsonEncode({
      'title': title,
      'body': body,
      'type': type,
      'time': time.millisecondsSinceEpoch,
    }));
    
    // Keep only the last 50 notifications
    if (notifications.length > 50) {
      notifications.removeAt(0);
    }
    
    await _prefs.setStringList('notification_history', notifications);
  }
  
  // Store a scheduled notification
  Future<void> _storeScheduledNotification(int id, String title, String body, String type, DateTime scheduledTime) async {
    final scheduledNotifications = _getScheduledNotifications();
    
    scheduledNotifications.add({
      'id': id,
      'title': title,
      'body': body,
      'type': type,
      'scheduledTime': scheduledTime.millisecondsSinceEpoch,
    });
    
    await _prefs.setString(_scheduledNotificationsKey, jsonEncode(scheduledNotifications));
  }
  
  // Get all scheduled notifications
  List<Map<String, dynamic>> _getScheduledNotifications() {
    final storedData = _prefs.getString(_scheduledNotificationsKey);
    if (storedData == null) return [];
    
    try {
      final List<dynamic> decoded = jsonDecode(storedData);
      return List<Map<String, dynamic>>.from(decoded);
    } catch (e) {
      print('Error decoding scheduled notifications: $e');
      return [];
    }
  }
  
  // Helper for scheduling notifications at a specific time
  tz.TZDateTime _nextInstanceOfTime(int hour, int minute, int day, int month, int year) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, year, month, day, hour, minute);
    if (scheduledDate.isBefore(now)) {
      // If the scheduled date is in the past, schedule for the next day at the same time
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
}
