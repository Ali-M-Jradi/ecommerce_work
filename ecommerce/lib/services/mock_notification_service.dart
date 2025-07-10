import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ecommerce/main.dart';

/// A mock notification service that doesn't rely on Firebase
/// This can be used until Firebase is properly set up
class MockNotificationService {
  static final MockNotificationService _instance = MockNotificationService._();
  static MockNotificationService get instance => _instance;
  
  late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
  late AndroidNotificationChannel _channel;
  
  // Permission status
  bool _notificationsEnabled = false;

  // Notification events (simplified without Firebase)
  final _onMessageReceivedController = ValueNotifier<Map<String, dynamic>?>(null);

  // Public getters
  ValueNotifier<Map<String, dynamic>?> get onMessageReceived => _onMessageReceivedController;
  bool get notificationsEnabled => _notificationsEnabled;
  
  // Private constructor
  MockNotificationService._();
  
  Future<void> initialize() async {
    try {
      // Set up notification permissions - simplified for mock version
      _notificationsEnabled = true;
      
      // Set up local notifications
      await _setupLocalNotifications();
      
      print('MockNotificationService initialized successfully');
    } catch (e) {
      print('Error initializing MockNotificationService: $e');
      // Don't rethrow, allow app to continue even if notifications fail
    }
  }
  
  Future<void> _setupLocalNotifications() async {
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    
    // Android initialization settings
    final AndroidInitializationSettings initializationSettingsAndroid = 
        AndroidInitializationSettings('@mipmap/ic_launcher');
        
    // iOS initialization settings
    final DarwinInitializationSettings initializationSettingsIOS = 
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    
    // Initialization settings
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    
    // Simple initialization for version 14.1.4
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        handleNotificationTap(response.payload);
      },
    );
    
    // Create notification channel for Android
    _channel = const AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
    );
    
    // Register the channel with the system
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);
  }
  
  // Method to show a local notification
  Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      channelDescription: 'This channel is used for important notifications.',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );
    
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    
    await _flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
    
    // Update the controller with the received message
    final Map<String, dynamic> data = payload != null 
        ? json.decode(payload) 
        : {'title': title, 'body': body};
    
    _onMessageReceivedController.value = data;
  }
  
  // Handle notification taps
  void handleNotificationTap(String? payload) {
    if (payload != null) {
      try {
        final Map<String, dynamic> data = json.decode(payload);
        print('Handling notification tap with data: $data');
        
        // Navigate based on notification type
        if (data.containsKey('type')) {
          String type = data['type'];
          switch (type) {
            case 'order':
              final orderId = data['orderId'];
              navigatorKey.currentState?.pushNamed('/order-details', arguments: {'orderId': orderId});
              break;
            case 'promotion':
              navigatorKey.currentState?.pushNamed('/special_offers');
              break;
            case 'new_arrival':
              navigatorKey.currentState?.pushNamed('/new-arrivals');
              break;
            default:
              // Default to notifications page
              navigatorKey.currentState?.pushNamed('/notifications');
              break;
          }
        } else {
          // If no type, just open notifications page
          navigatorKey.currentState?.pushNamed('/notifications');
        }
      } catch (e) {
        print('Error parsing notification payload: $e');
      }
    }
  }
}

// Helper class for notification topics (for API compatibility)
class MockNotificationTopics {
  static const String promotions = 'promotions';
  static const String newArrivals = 'new_arrivals';
  static const String orderUpdates = 'order_updates';
  static const String allUsers = 'all_users';
}
