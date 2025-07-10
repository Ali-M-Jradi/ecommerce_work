import 'package:flutter/material.dart';
import 'package:ecommerce/services/mock_notification_service.dart';

class MockNotificationProvider with ChangeNotifier {
  final MockNotificationService _notificationService = MockNotificationService.instance;
  
  // Notification counters
  int _unreadCount = 0;
  
  // Notification settings
  bool _promotionsEnabled = true;
  bool _orderUpdatesEnabled = true;
  bool _newArrivalsEnabled = true;
  
  // Getters
  int get unreadCount => _unreadCount;
  bool get promotionsEnabled => _promotionsEnabled;
  bool get orderUpdatesEnabled => _orderUpdatesEnabled;
  bool get newArrivalsEnabled => _newArrivalsEnabled;
  bool get notificationsEnabled => _notificationService.notificationsEnabled;
  
  // Constructor
  MockNotificationProvider() {
    _initialize();
    
    // Add some unread notifications for demo purposes
    _unreadCount = 3;
  }
  
  // Initialize the provider
  Future<void> _initialize() async {
    try {
      // Initialize the notification service
      await _notificationService.initialize();
      
      // Set up listeners for notifications
      _setupNotificationListeners();
      
    } catch (e) {
      print('Error initializing MockNotificationProvider: $e');
    }
  }
  
  void _setupNotificationListeners() {
    // Listen for new messages while app is in foreground
    _notificationService.onMessageReceived.addListener(() {
      final message = _notificationService.onMessageReceived.value;
      if (message != null) {
        _handleIncomingNotification(message);
      }
    });
  }
  
  // Alias for markAllAsRead to match the method name used in the notifications page
  void markNotificationsAsRead() {
    markAllAsRead();
  }
  
  // If this method doesn't exist already
  void sendTestNotification(String title, String body) {
    // In a real implementation, this would show a local notification
    print('Mock notification: $title - $body');
    _unreadCount++;
    notifyListeners();
  }
  
  void _handleIncomingNotification(Map<String, dynamic> message) {
    // Increment unread count
    _unreadCount++;
    notifyListeners();
    
    // Additional handling based on notification type
    if (message.containsKey('type')) {
      switch (message['type']) {
        case 'order_update':
          // Handle order update notification
          break;
        case 'promotion':
          // Handle promotion notification
          break;
        case 'new_arrival':
          // Handle new arrival notification
          break;
        default:
          // Handle other notification types
          break;
      }
    }
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
  
  // Method to show a test notification
  Future<void> showTestNotification({
    required String title,
    required String body,
    String? type,
  }) async {
    final Map<String, dynamic> data = {
      'type': type ?? 'general',
      'timestamp': DateTime.now().toIso8601String(),
    };
    
    await _notificationService.showNotification(
      title: title,
      body: body,
      payload: data.toString(),
    );
  }
}
