# 🔔 Notifications Page

The NotificationsPage module manages all user notifications, alerts, and notification settings for the DERMOCOSMETIQUE ecommerce application.

## 📋 **Overview**

NotificationsPage provides:
- Real-time and scheduled notifications
- Order status, promotions, and system alerts
- Notification center with read/unread management
- Multi-language support (Arabic/English, RTL)
- Notification settings and preferences
- Provider-based state management
- Integration with order and profile modules

## 🏗️ **File Structure**

```
notifications/
├── notifications_page.dart         # Main notifications center
├── notification_test_page.dart     # Development/testing tool
├── notification_provider.dart      # State management
├── notification_service.dart       # Scheduling and delivery
└── README.md                      # This documentation
```

## 🎯 **Key Components**

### **NotificationsPage (notifications_page.dart)**
```dart
class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});
}
```
**Features:**
- Tabbed interface (All, Orders, Promotions, Alerts)
- Real-time notification display
- Mark as read/unread
- Notification history and filtering
- Notification settings shortcut

### **NotificationProvider (notification_provider.dart)**
```dart
class NotificationProvider with ChangeNotifier {
  List<NotificationItem> notifications = [];
  int unreadCount = 0;
  // ...methods for add, mark as read, clear, etc.
}
```
**Features:**
- State management for notifications
- Unread badge count
- Add, remove, mark as read

### **NotificationService (notification_service.dart)**
```dart
class NotificationService {
  Future<void> scheduleNotification(...);
  Future<void> showNotification(...);
}
```
**Features:**
- Schedules and delivers notifications
- Integrates with order and system events

### **NotificationTestPage (notification_test_page.dart)**
**Features:**
- Simulate and test notification flows
- Developer tool for notification scenarios

## 🏗️ **Architecture & State Management**

### **Provider Integration**
```dart
Provider.of<NotificationProvider>(context)
```

### **Notification Data Model**
```dart
class NotificationItem {
  final String id;
  final String title;
  final String message;
  final DateTime time;
  final NotificationType type;
  final bool isRead;
  final Map<String, dynamic>? data;
}
```

### **Notification Types**
```dart
enum NotificationType {
  order, promotion, system, alert
}
```

## 🎨 **UI/UX Features**

- Tabbed notification center
- Visual indicators for unread/read
- Swipe to delete or mark as read
- Notification settings page
- Multi-language and RTL support

## 🔒 **Settings & Preferences**

- Enable/disable notification categories
- Set quiet hours
- Control sound/vibration

## 🌍 **Multi-Language & RTL Support**

- All notification content localized
- RTL layout for Arabic

## 🚀 **Notification Flow**

```
Order/Promo/System Event → NotificationService → NotificationProvider → NotificationsPage UI
```

## 🧪 **Testing & Quality Assurance**

- Unit tests for NotificationProvider logic
- Widget tests for notification display
- Integration tests for notification flows

## 🔮 **Future Enhancements**

- [ ] Push notification integration (FCM/APNs)
- [ ] Rich media notifications
- [ ] Notification grouping and channels
- [ ] Notification analytics

---

For implementation details, see the respective Dart files in this directory.
