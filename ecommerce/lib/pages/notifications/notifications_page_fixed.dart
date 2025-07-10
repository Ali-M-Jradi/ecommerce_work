import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce/providers/mock_notification_provider.dart';
import 'package:ecommerce/localization/app_localizations_helper.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> with TickerProviderStateMixin {
  late TabController _tabController;
  
  // Sample notification data - in a real app, this would come from a backend
  final List<NotificationItem> _allNotifications = [
    NotificationItem(
      id: '1',
      title: 'Your order #12345 has been shipped',
      message: 'Your order has been shipped and will arrive in 2-3 business days.',
      time: DateTime.now().subtract(const Duration(hours: 2)),
      type: NotificationType.order,
      isRead: false,
    ),
    NotificationItem(
      id: '2',
      title: 'Special offer just for you!',
      message: 'Get 25% off on all skincare products this weekend. Use code SKIN25.',
      time: DateTime.now().subtract(const Duration(hours: 8)),
      type: NotificationType.promotion,
      isRead: false,
    ),
    NotificationItem(
      id: '3',
      title: 'New arrivals in face care',
      message: 'Check out our new collection of face serums and masks!',
      time: DateTime.now().subtract(const Duration(days: 1)),
      type: NotificationType.newArrival,
      isRead: true,
    ),
    NotificationItem(
      id: '4',
      title: 'Your order #12344 has been delivered',
      message: 'Your order has been delivered. Enjoy your products!',
      time: DateTime.now().subtract(const Duration(days: 3)),
      type: NotificationType.order,
      isRead: true,
    ),
    NotificationItem(
      id: '5',
      title: '20% off on all products!',
      message: 'Enjoy 20% off on all products this month. Limited time offer!',
      time: DateTime.now().subtract(const Duration(days: 4)),
      type: NotificationType.promotion,
      isRead: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _markAsRead() {
    if (mounted) {
      setState(() {
        for (var notification in _allNotifications) {
          notification.isRead = true;
        }
      });
      
      final notificationProvider = Provider.of<MockNotificationProvider>(context, listen: false);
      notificationProvider.markAllAsRead();
    }
  }

  void _removeNotification(String id) {
    setState(() {
      // Remove from the appropriate list based on current tab
      if (_tabController.index == 0) {
        _allNotifications.removeWhere((n) => n.id == id);
      } else if (_tabController.index == 1) {
        _allNotifications.removeWhere((n) => n.id == id && n.type == NotificationType.order);
      } else if (_tabController.index == 2) {
        _allNotifications.removeWhere((n) => n.id == id && n.type == NotificationType.promotion);
      } else if (_tabController.index == 3) {
        _allNotifications.removeWhere((n) => n.id == id && n.type == NotificationType.newArrival);
      }
      
      // Show snackbar with undo option
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizationsHelper.of(context).notificationRemoved),
          action: SnackBarAction(
            label: AppLocalizationsHelper.of(context).undo,
            onPressed: () {
              // Undo the removal (would need to restore from a backup or use a temporary storage)
              setState(() {
                // This is just a placeholder - in a real app, you'd need to restore the actual item
              });
            },
          ),
        ),
      );
    });
  }

  List<NotificationItem> _getFilteredNotifications(NotificationType? type) {
    if (type == null) {
      return _allNotifications;
    }
    return _allNotifications.where((n) => n.type == type).toList();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizationsHelper.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.notificationsPageTitle),
        actions: [
          if (_allNotifications.any((n) => !n.isRead))
            IconButton(
              icon: const Icon(Icons.done_all),
              tooltip: 'Mark all as read',
              onPressed: _markAsRead,
            ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Notification Settings',
            onPressed: () {
              _showNotificationSettingsBottomSheet(context);
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: [
            Tab(text: localizations.all),
            Tab(text: localizations.orders),
            Tab(text: localizations.promotions),
            Tab(text: localizations.newArrivals),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildNotificationList(_getFilteredNotifications(null)),
          _buildNotificationList(_getFilteredNotifications(NotificationType.order)),
          _buildNotificationList(_getFilteredNotifications(NotificationType.promotion)),
          _buildNotificationList(_getFilteredNotifications(NotificationType.newArrival)),
        ],
      ),
    );
  }

  Widget _buildNotificationList(List<NotificationItem> notifications) {
    if (notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.notifications_off, size: 48, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              AppLocalizationsHelper.of(context).noNotifications,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizationsHelper.of(context).checkBackLater,
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return Dismissible(
          key: Key(notification.id),
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            _removeNotification(notification.id);
          },
          child: _buildNotificationItem(notification),
        );
      },
    );
  }

  Widget _buildNotificationItem(NotificationItem notification) {
    final formattedTime = _formatNotificationTime(notification.time);
    final iconData = _getIconForNotificationType(notification.type);
    final iconColor = _getColorForNotificationType(notification.type);

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: iconColor.withOpacity(0.2),
        child: Icon(iconData, color: iconColor),
      ),
      title: Text(
        notification.title,
        style: TextStyle(
          fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text(notification.message),
          const SizedBox(height: 4),
          Text(
            formattedTime,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
      isThreeLine: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      onTap: () {
        setState(() {
          notification.isRead = true;
        });
        // Navigate to appropriate page based on notification type
        // TODO: Implement navigation
      },
    );
  }

  IconData _getIconForNotificationType(NotificationType type) {
    switch (type) {
      case NotificationType.order:
        return Icons.local_shipping;
      case NotificationType.promotion:
        return Icons.discount;
      case NotificationType.newArrival:
        return Icons.new_releases;
    }
  }

  Color _getColorForNotificationType(NotificationType type) {
    switch (type) {
      case NotificationType.order:
        return Colors.blue;
      case NotificationType.promotion:
        return Colors.purple;
      case NotificationType.newArrival:
        return Colors.green;
    }
  }

  String _formatNotificationTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${time.day}/${time.month}/${time.year}';
    }
  }

  void _showNotificationSettingsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return _NotificationSettingsSheet();
      },
    );
  }
}

class _NotificationSettingsSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizationsHelper.of(context);
    
    return Consumer<MockNotificationProvider>(
      builder: (context, notificationProvider, _) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      localizations.notificationSettings,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      localizations.notificationTypes,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      title: Text(localizations.enableNotifications),
                      subtitle: Text(localizations.receiveAllNotifications),
                      value: notificationProvider.notificationsEnabled,
                      onChanged: (value) {
                        // In a real app, this would call a method to request permissions
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(localizations.changeNotificationPermissionsInSettings),
                            action: SnackBarAction(
                              label: 'Settings',
                              onPressed: () {
                                // Open app settings
                              },
                            ),
                          ),
                        );
                      },
                    ),
                    const Divider(),
                    SwitchListTile(
                      title: Text(localizations.orderUpdatesNotification),
                      subtitle: Text(localizations.notificationsAboutYourOrders),
                      value: notificationProvider.orderUpdatesEnabled,
                      onChanged: notificationProvider.notificationsEnabled
                        ? (value) => notificationProvider.toggleOrderUpdates(value)
                        : null,
                    ),
                    const Divider(),
                    SwitchListTile(
                      title: Text(localizations.promotions),
                      subtitle: Text(localizations.specialOffersAndDiscounts),
                      value: notificationProvider.promotionsEnabled,
                      onChanged: notificationProvider.notificationsEnabled
                        ? (value) => notificationProvider.togglePromotions(value)
                        : null,
                    ),
                    const Divider(),
                    SwitchListTile(
                      title: Text(localizations.newArrivals),
                      subtitle: Text(localizations.newProductAnnouncements),
                      value: notificationProvider.newArrivalsEnabled,
                      onChanged: notificationProvider.notificationsEnabled
                        ? (value) => notificationProvider.toggleNewArrivals(value)
                        : null,
                    ),
                    const Divider(),
                    const SizedBox(height: 24),
                    if (notificationProvider.notificationsEnabled)
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            notificationProvider.showTestNotification(
                              title: 'Test Notification',
                              body: 'This is a test notification from settings.',
                              type: 'test',
                            );
                            Navigator.pop(context);
                          },
                          child: const Text('Send Test Notification'),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

enum NotificationType {
  order,
  promotion,
  newArrival,
}

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final DateTime time;
  final NotificationType type;
  bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    required this.type,
    this.isRead = false,
  });
}
