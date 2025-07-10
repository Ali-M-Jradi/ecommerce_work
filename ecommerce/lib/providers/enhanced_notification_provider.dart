import 'package:flutter/material.dart';
import 'package:ecommerce/services/local_notification_service.dart';

class EnhancedNotificationProvider with ChangeNotifier {
  final LocalNotificationService _notificationService = LocalNotificationService.instance;
  
  // Notification counters
  int _unreadCount = 0;
  
  // Notification settings
  bool _notificationsEnabled = true;
  bool _promotionsEnabled = true;
  bool _orderUpdatesEnabled = true;
  bool _newArrivalsEnabled = true;
  
  // Getters
  int get unreadCount => _unreadCount;
  bool get promotionsEnabled => _promotionsEnabled;
  bool get orderUpdatesEnabled => _orderUpdatesEnabled;
  bool get newArrivalsEnabled => _newArrivalsEnabled;
  bool get notificationsEnabled => _notificationsEnabled;
  
  // Constructor
  EnhancedNotificationProvider() {
    _initialize();
  }
  
  // Initialize the provider
  Future<void> _initialize() async {
    try {
      // Initialize the notification service
      await _notificationService.initialize();
      
      // Request permissions for notifications
      _notificationsEnabled = await _notificationService.requestPermission();
      notifyListeners();
      
    } catch (e) {
      print('Error initializing EnhancedNotificationProvider: $e');
    }
  }
  
  // Alias for markAllAsRead to match the method name used in the notifications page
  void markNotificationsAsRead() {
    _unreadCount = 0;
    notifyListeners();
  }
  
  // Method to mark all notifications as read
  void markAllAsRead() {
    _unreadCount = 0;
    notifyListeners();
  }
  
  // Method to toggle notification settings
  void togglePromotions(bool value) {
    _promotionsEnabled = value;
    notifyListeners();
  }
  
  void toggleOrderUpdates(bool value) {
    _orderUpdatesEnabled = value;
    notifyListeners();
  }
  
  void toggleNewArrivals(bool value) {
    _newArrivalsEnabled = value;
    notifyListeners();
  }
  
  // Method to send a real system notification
  Future<void> sendTestNotification(String title, String body) async {
    await _notificationService.showNotification(
      title: title,
      body: body,
      payload: '{"type": "test"}',
    );
    _unreadCount++;
    notifyListeners();
  }
  
  // Order notification
  Future<void> sendOrderNotification(String orderId, String status) async {
    if (!_orderUpdatesEnabled) return;
    
    await _notificationService.showOrderNotification(orderId, status);
    _unreadCount++;
    notifyListeners();
  }
  
  // Promotion notification
  Future<void> sendPromotionNotification(String title, String details) async {
    if (!_promotionsEnabled) return;
    
    await _notificationService.showPromotionNotification(title, details);
    _unreadCount++;
    notifyListeners();
  }
  
  // New arrival notification
  Future<void> sendNewArrivalNotification(String productName) async {
    if (!_newArrivalsEnabled) return;
    
    await _notificationService.showNewArrivalNotification(productName);
    _unreadCount++;
    notifyListeners();
  }
}
