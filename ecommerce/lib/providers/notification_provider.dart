import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:ecommerce/services/notification_service.dart';

class NotificationProvider with ChangeNotifier {
  final NotificationService _notificationService = NotificationService.instance;
  
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
  NotificationProvider() {
    _initialize();
  }
  
  // Initialize the provider
  Future<void> _initialize() async {
    try {
      // Set up listeners for notifications
      _setupNotificationListeners();
      
      // Load notification settings from storage
      // TODO: Implement loading settings from shared preferences
      
      // Subscribe to relevant topics based on settings with a timeout
      await Future.wait([
        _subscribeToTopics().timeout(
          const Duration(seconds: 5),
          onTimeout: () {
            print('Topic subscription timed out, will retry later');
            return;
          },
        ),
      ]).catchError((e) {
        print('Error during topic subscription: $e');
        // Don't rethrow, allow the app to continue even if subscriptions fail
        return <void>[];
      });
    } catch (e) {
      print('Error initializing NotificationProvider: $e');
      // Don't rethrow, allow the app to continue even if provider initialization fails
    }
  }
  
  // Helper method to subscribe to topics
  Future<void> _subscribeToTopics() async {
    if (_notificationService.notificationsEnabled) {
      try {
        if (_promotionsEnabled) {
          await _notificationService.subscribeToTopic(NotificationTopics.promotions);
        }
        
        if (_orderUpdatesEnabled) {
          await _notificationService.subscribeToTopic(NotificationTopics.orderUpdates);
        }
        
        if (_newArrivalsEnabled) {
          await _notificationService.subscribeToTopic(NotificationTopics.newArrivals);
        }
        
        // Subscribe all users to the all_users topic
        await _notificationService.subscribeToTopic(NotificationTopics.allUsers);
      } catch (e) {
        print('Error subscribing to topics: $e');
        // Continue execution, subscription can be retried later
      }
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

    // Listen for app open from notification
    _notificationService.onMessageOpenedApp.addListener(() {
      final message = _notificationService.onMessageOpenedApp.value;
      if (message != null) {
        _handleNotificationOpen(message);
      }
    });
  }
  
  void _handleIncomingNotification(RemoteMessage message) {
    // Increment unread count
    _unreadCount++;
    notifyListeners();
    
    // Additional handling based on notification type
    // This can be expanded based on your notification schema
    if (message.data.containsKey('type')) {
      switch (message.data['type']) {
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
  
  void _handleNotificationOpen(RemoteMessage message) {
    // Logic for when user taps on a notification
    // This might involve navigation to a specific screen
    
    // Reset unread count when notifications are viewed
    markNotificationsAsRead();
  }
  
  // Method to mark all notifications as read
  void markNotificationsAsRead() {
    _unreadCount = 0;
    notifyListeners();
  }
  
  // Methods to toggle notification settings
  void togglePromotions(bool value) async {
    _promotionsEnabled = value;
    if (_promotionsEnabled) {
      await _notificationService.subscribeToTopic(NotificationTopics.promotions);
    } else {
      await _notificationService.unsubscribeFromTopic(NotificationTopics.promotions);
    }
    notifyListeners();
    // TODO: Save settings to shared preferences
  }
  
  void toggleOrderUpdates(bool value) async {
    _orderUpdatesEnabled = value;
    if (_orderUpdatesEnabled) {
      await _notificationService.subscribeToTopic(NotificationTopics.orderUpdates);
    } else {
      await _notificationService.unsubscribeFromTopic(NotificationTopics.orderUpdates);
    }
    notifyListeners();
    // TODO: Save settings to shared preferences
  }
  
  void toggleNewArrivals(bool value) async {
    _newArrivalsEnabled = value;
    if (_newArrivalsEnabled) {
      await _notificationService.subscribeToTopic(NotificationTopics.newArrivals);
    } else {
      await _notificationService.unsubscribeFromTopic(NotificationTopics.newArrivals);
    }
    notifyListeners();
    // TODO: Save settings to shared preferences
  }
  
  // Method to manually trigger a test notification
  Future<void> sendTestNotification(String title, String body) async {
    await _notificationService.showNotification(
      title: title,
      body: body,
      payload: '{"type": "test"}',
    );
  }
}
