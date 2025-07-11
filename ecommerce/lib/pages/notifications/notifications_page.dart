import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce/providers/mock_notification_provider.dart';
import 'package:ecommerce/localization/app_localizations_helper.dart';
import 'package:ecommerce/services/order_service.dart';

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
      isRead: false,
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
      title: 'Flash Sale Alert!',
      message: 'Flash sale starts in 1 hour. Get ready for amazing discounts!',
      time: DateTime.now().subtract(const Duration(days: 5)),
      type: NotificationType.promotion,
      isRead: true,
    ),
  ];
  
  List<NotificationItem> _filteredNotifications = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_handleTabChange);
    
    // Initialize with all notifications
    _filteredNotifications = List.from(_allNotifications);
    
    // Mark notifications as read when this page is opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notificationProvider = Provider.of<MockNotificationProvider>(context, listen: false);
      notificationProvider.markNotificationsAsRead();
    });
  }

  void _handleTabChange() {
    if (!_tabController.indexIsChanging) {
      setState(() {
        switch (_tabController.index) {
          case 0: // All
            _filteredNotifications = List.from(_allNotifications);
            break;
          case 1: // Orders
            _filteredNotifications = _allNotifications
                .where((notification) => notification.type == NotificationType.order)
                .toList();
            break;
          case 2: // Promotions
            _filteredNotifications = _allNotifications
                .where((notification) => notification.type == NotificationType.promotion)
                .toList();
            break;
          case 3: // New Arrivals
            _filteredNotifications = _allNotifications
                .where((notification) => notification.type == NotificationType.newArrival)
                .toList();
            break;
        }
      });
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final localizations = AppLocalizationsHelper.of(context);
    final isRTL = Directionality.of(context) == TextDirection.rtl;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizationsHelper.of(context).notifications),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.push(
              context, 
              MaterialPageRoute(builder: (_) => const NotificationSettingsPage()),
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: [
            Tab(text: AppLocalizationsHelper.of(context).all),
            Tab(text: AppLocalizationsHelper.of(context).orders),
            Tab(text: AppLocalizationsHelper.of(context).promotions),
            Tab(text: AppLocalizationsHelper.of(context).newArrivals),
          ],
        ),
      ),
      body: _filteredNotifications.isEmpty 
        ? _buildEmptyState()
        : ListView.builder(
            itemCount: _filteredNotifications.length,
            itemBuilder: (context, index) {
              return _buildNotificationItem(_filteredNotifications[index], isRTL);
            },
          ),
    );
  }
  
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),            Text(
            AppLocalizationsHelper.of(context).noNotifications,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizationsHelper.of(context).checkBackLater,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildNotificationItem(NotificationItem notification, bool isRTL) {
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: isRTL ? Alignment.centerLeft : Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        color: Colors.red,
        child: const Icon(
          Icons.delete_outline,
          color: Colors.white,
        ),
      ),
      onDismissed: (direction) {
        setState(() {
          _allNotifications.removeWhere((item) => item.id == notification.id);
          _filteredNotifications.removeWhere((item) => item.id == notification.id);
        });
        
        // Show a snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizationsHelper.of(context).notificationRemoved),
            action: SnackBarAction(
              label: AppLocalizationsHelper.of(context).undo,
              onPressed: () {
                setState(() {
                  _allNotifications.add(notification);
                  _handleTabChange(); // Re-filter based on current tab
                });
              },
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: notification.isRead ? null : Colors.deepPurple.shade50,
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade200),
          ),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          leading: _buildNotificationIcon(notification.type),
          title: Text(
            notification.title,
            style: TextStyle(
              fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 6),
              Text(
                notification.message,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Text(
                _formatTime(notification.time),
                style: const TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          isThreeLine: true,
          onTap: () {
            setState(() {
              notification.isRead = true;
            });
            
            // Show notification detail or take action based on notification type
            _handleNotificationTap(notification);
          },
          trailing: notification.isRead
              ? null
              : Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.deepPurple.shade700,
                  ),
                ),
        ),
      ),
    );
  }
  
  Widget _buildNotificationIcon(NotificationType type) {
    IconData iconData;
    Color iconColor;
    
    switch (type) {
      case NotificationType.order:
        iconData = Icons.local_shipping_outlined;
        iconColor = Colors.blue;
        break;
      case NotificationType.promotion:
        iconData = Icons.discount_outlined;
        iconColor = Colors.deepPurple;
        break;
      case NotificationType.newArrival:
        iconData = Icons.new_releases_outlined;
        iconColor = Colors.amber.shade800;
        break;
    }
    
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        iconData,
        color: iconColor,
      ),
    );
  }
  
  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${time.day}/${time.month}/${time.year}';
    }
  }
  
  void _handleNotificationTap(NotificationItem notification) {
    switch (notification.type) {
      case NotificationType.order:
        // Extract order ID from notification title or message
        final RegExp regExp = RegExp(r'#(\d+)');
        final match = regExp.firstMatch(notification.title);
        final orderId = match?.group(1) ?? '';
        
        // Try to fetch the order from OrderService
        final order = OrderService.instance.getOrderById(orderId);
        
        if (order != null) {
          // Navigate to order details
          final message = Directionality.of(context) == TextDirection.ltr
              ? "Navigating to order #$orderId details"
              : "الانتقال إلى تفاصيل الطلب رقم #$orderId";
              
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
          // TODO: Implement and navigate to actual order details page
          // Navigator.push(context, MaterialPageRoute(builder: (_) => OrderDetailPage(order: order)));
        } else {
          final message = Directionality.of(context) == TextDirection.ltr
              ? "Order #$orderId not found"
              : "الطلب رقم #$orderId غير موجود";
              
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
        }
        break;
      case NotificationType.promotion:
        // Navigate to promotions
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Navigating to promotions page')),
        );
        // In production: Navigator.push(context, MaterialPageRoute(builder: (_) => PromotionsPage()));
        break;
      case NotificationType.newArrival:
        // Navigate to new arrivals
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Navigating to new arrivals')),
        );
        // In production: Navigator.push(context, MaterialPageRoute(builder: (_) => NewArrivalsPage()));
        break;
    }
  }
}

// Notification Settings Page
class NotificationSettingsPage extends StatelessWidget {
  const NotificationSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final localizations = AppLocalizationsHelper.of(context);
    
    return Consumer<MockNotificationProvider>(
      builder: (context, notificationProvider, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizationsHelper.of(context).notificationSettings),
            centerTitle: true,
          ),
          body: ListView(
            children: [
              const SizedBox(height: 16),
              
              // Main switch for all notifications
              ListTile(
                title: Text(
                  AppLocalizationsHelper.of(context).enableNotifications,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(AppLocalizationsHelper.of(context).receiveAllNotifications),
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.notifications_active,
                    color: Colors.deepPurple.shade700,
                  ),
                ),
                trailing: Switch(
                  value: notificationProvider.notificationsEnabled,
                  onChanged: (value) {
                    // Cannot be changed here, must be done in system settings
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(AppLocalizationsHelper.of(context).changeNotificationPermissionsInSettings),
                      ),
                    );
                  },
                ),
              ),
              
              const Divider(),
              
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Text(
                  AppLocalizationsHelper.of(context).notificationTypes,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
              
              // Order updates
              SwitchListTile(
                title: Text(AppLocalizationsHelper.of(context).orderUpdatesNotification),
                subtitle: Text(AppLocalizationsHelper.of(context).notificationsAboutYourOrders),
                value: notificationProvider.orderUpdatesEnabled,
                onChanged: notificationProvider.notificationsEnabled
                  ? (value) => notificationProvider.toggleOrderUpdates(value)
                  : null,
              ),
              
              // Promotions
              SwitchListTile(
                title: Text(AppLocalizationsHelper.of(context).promotions),
                subtitle: Text(AppLocalizationsHelper.of(context).specialOffersAndDiscounts),
                value: notificationProvider.promotionsEnabled,
                onChanged: notificationProvider.notificationsEnabled
                  ? (value) => notificationProvider.togglePromotions(value)
                  : null,
              ),
              
              // New arrivals
              SwitchListTile(
                title: Text(AppLocalizationsHelper.of(context).newArrivals),
                subtitle: Text(AppLocalizationsHelper.of(context).newProductAnnouncements),
                value: notificationProvider.newArrivalsEnabled,
                onChanged: notificationProvider.notificationsEnabled
                  ? (value) => notificationProvider.toggleNewArrivals(value)
                  : null,
              ),
              
              const Divider(),
              
              // Test notification button
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/test-notifications');
                    },
                    child: Text(
                      Directionality.of(context) == TextDirection.ltr 
                        ? 'Test Real Notifications'
                        : 'اختبار الإشعارات الحقيقية'
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Model for notification items
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

// Enum for notification types
enum NotificationType {
  order,
  promotion,
  newArrival,
}
