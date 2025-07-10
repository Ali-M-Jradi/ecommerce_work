import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ecommerce/main.dart';

// Define the background message handler outside the class
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Background message: ${message.messageId}");
}

class NotificationService {
  static final NotificationService _instance = NotificationService._();
  static NotificationService get instance => _instance;
  
  late FirebaseMessaging _messaging;
  late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
  late AndroidNotificationChannel _channel;
  
  // Permission status
  bool _notificationsEnabled = false;

  // Stream controllers for notification events
  final _onMessageOpenedAppController = ValueNotifier<RemoteMessage?>(null);
  final _onMessageReceivedController = ValueNotifier<RemoteMessage?>(null);

  // Public getters for notification events
  ValueNotifier<RemoteMessage?> get onMessageOpenedApp => _onMessageOpenedAppController;
  ValueNotifier<RemoteMessage?> get onMessageReceived => _onMessageReceivedController;
  bool get notificationsEnabled => _notificationsEnabled;
  
  // Private constructor
  NotificationService._();
  
  Future<void> initialize() async {
    try {
      // Set up Firebase Messaging
      _messaging = FirebaseMessaging.instance;

      // Set up background message handler
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
      
      // Set up notification permissions
      await _requestPermissions().timeout(
        const Duration(seconds: 3),
        onTimeout: () {
          print('Permission request timed out, continuing with default permissions');
          _notificationsEnabled = Platform.isAndroid; // Default for Android is true
          return;
        },
      );
      
      // For iOS, set foreground notification presentation options
      if (Platform.isIOS) {
        try {
          await _messaging.setForegroundNotificationPresentationOptions(
            alert: true,
            badge: true,
            sound: true,
          );
        } catch (e) {
          print('Error setting iOS notification presentation options: $e');
          // Continue execution, this is not critical
        }
      }
      
      // Set up local notifications
      await _setupLocalNotifications();
      
      // Set up notification handlers
      _setupNotificationHandlers();
      
      print('NotificationService initialized successfully');
    } catch (e) {
      print('Error initializing NotificationService: $e');
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
  
  Future<void> _requestPermissions() async {
    // Request permission from iOS or macOS
    if (Platform.isIOS || Platform.isMacOS) {
      NotificationSettings settings = await _messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      
      _notificationsEnabled = settings.authorizationStatus == AuthorizationStatus.authorized ||
                             settings.authorizationStatus == AuthorizationStatus.provisional;
      
      print('User granted permission: ${_notificationsEnabled}');
    } else {
      // On Android, permissions are granted by default
      _notificationsEnabled = true;
    }
  }
  
  void _setupNotificationHandlers() {
    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');
      
      // Update the controller with the received message
      _onMessageReceivedController.value = message;
      
      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
        _showLocalNotification(message);
      }
    });
    
    // Handle app open from terminated state
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        print('App opened from terminated state with message: ${message.data}');
        _onMessageOpenedAppController.value = message;
      }
    });
    
    // Handle app open from background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('App opened from background state with message: ${message.data}');
      _onMessageOpenedAppController.value = message;
    });
  }
  
  void _showLocalNotification(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    
    // If `onMessage` is triggered with a notification, construct our own
    // local notification to show to users using the created channel.
    if (notification != null && android != null && !kIsWeb) {
      _flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _channel.id,
            _channel.name,
            channelDescription: _channel.description,
            icon: 'launch_background',
            // other properties...
          ),
          iOS: const DarwinNotificationDetails(),
        ),
        payload: json.encode(message.data),
      );
    }
  }
  
  // Renamed to public method so it can be called directly when needed
  void handleNotificationTap(String? payload) {
    if (payload != null) {
      try {
        final Map<String, dynamic> data = json.decode(payload);
        print('Handling notification tap with data: $data');
        
        // Use global navigator key from main.dart
        
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
  
  // Method to get FCM token
  Future<String?> getToken() async {
    return await _messaging.getToken();
  }
  
  // Method to subscribe to topics
  Future<void> subscribeToTopic(String topic) async {
    await _messaging.subscribeToTopic(topic);
  }
  
  // Method to unsubscribe from topics
  Future<void> unsubscribeFromTopic(String topic) async {
    await _messaging.unsubscribeFromTopic(topic);
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
  }
}

// Helper class for notification topics
class NotificationTopics {
  static const String promotions = 'promotions';
  static const String newArrivals = 'new_arrivals';
  static const String orderUpdates = 'order_updates';
  static const String allUsers = 'all_users';
}
