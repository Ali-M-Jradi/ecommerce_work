import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:math';
import 'dart:ui' as ui;

class LocalNotificationService {
  static final LocalNotificationService _instance = LocalNotificationService._();
  static LocalNotificationService get instance => _instance;
  
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;
  
  // Private constructor
  LocalNotificationService._();
  
  Future<void> initialize() async {
    if (_initialized) return;
    
    // Android initialization settings
    const AndroidInitializationSettings initializationSettingsAndroid = 
        AndroidInitializationSettings('@mipmap/ic_launcher');
        
    // iOS initialization settings
    const DarwinInitializationSettings initializationSettingsIOS = 
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    
    // Initialization settings
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    
    // Initialize
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
    
    // Create notification channel for Android
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
    );
    
    // Register the channel with the system
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    
    _initialized = true;
  }
  
  void _onNotificationTapped(NotificationResponse response) {
    // This will be called when the user taps on a notification
    
    // You can handle navigation here using a global navigator key
    // or by storing the payload and checking it when the app starts
  }
  
  Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    if (!_initialized) {
      await initialize();
    }
    
    // Create Android notification details
    const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      channelDescription: 'This channel is used for important notifications.',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );
    
    // Create general notification details
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: DarwinNotificationDetails(),
    );
    
    // Show notification
    await _flutterLocalNotificationsPlugin.show(
      Random().nextInt(1000), // Random ID to avoid overwriting
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }
  
  Future<void> showOrderNotification(String orderId, String status) async {
    bool isArabic = ui.window.locale.languageCode == 'ar';
    await showNotification(
      title: isArabic ? 'تحديث الطلب' : 'Order Update',
      body: isArabic 
        ? 'طلبك رقم $orderId أصبح $status' 
        : 'Your order #$orderId has been $status',
      payload: '{"type":"order","orderId":"$orderId"}',
    );
  }
  
  Future<void> showPromotionNotification(String promoTitle, String promoDetails) async {
    await showNotification(
      title: promoTitle,
      body: promoDetails,
      payload: '{"type":"promotion"}',
    );
  }
  
  Future<void> showNewArrivalNotification(String productName) async {
    bool isArabic = ui.window.locale.languageCode == 'ar';
    await showNotification(
      title: isArabic ? 'منتج جديد' : 'New Arrival',
      body: isArabic 
        ? 'تحقق من منتجنا الجديد: $productName' 
        : 'Check out our new product: $productName',
      payload: '{"type":"new_arrival","product":"$productName"}',
    );
  }
  
  // To request notification permission on Android 13+ and iOS, use the permission_handler package or platform-specific APIs.
  // This method is a placeholder and always returns true for now.
  Future<bool> requestPermission() async {
    if (!_initialized) {
      await initialize();
    }
    // TODO: Implement permission request using permission_handler or platform channels if needed.
    return true;
  }
}
