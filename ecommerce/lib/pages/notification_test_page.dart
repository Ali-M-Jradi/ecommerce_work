import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce/providers/enhanced_notification_provider.dart';
import 'package:ecommerce/localization/app_localizations_helper.dart';

class NotificationTestPage extends StatefulWidget {
  const NotificationTestPage({Key? key}) : super(key: key);

  @override
  State<NotificationTestPage> createState() => _NotificationTestPageState();
}

class _NotificationTestPageState extends State<NotificationTestPage> {
  final _titleController = TextEditingController(text: "Test Notification");
  final _bodyController = TextEditingController(text: "This is a test notification");
  final _orderIdController = TextEditingController(text: "12345");
  String _selectedOrderStatus = "shipped";

  final List<String> _orderStatuses = [
    "processing",
    "shipped",
    "delivered",
    "cancelled",
  ];
  
  String _getArabicStatus(String status) {
    switch (status) {
      case "processing":
        return "قيد المعالجة";
      case "shipped":
        return "تم الشحن";
      case "delivered":
        return "تم التوصيل";
      case "cancelled":
        return "ملغي";
      default:
        return status;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    _orderIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Directionality.of(context) == TextDirection.ltr 
            ? "Test Notifications"
            : "اختبار الإشعارات"
        ),
        centerTitle: true,
      ),
      body: Consumer<EnhancedNotificationProvider>(
        builder: (context, notificationProvider, _) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // General notification
              Card(
                margin: const EdgeInsets.only(bottom: 16),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Directionality.of(context) == TextDirection.ltr 
                          ? "Custom Notification"
                          : "إشعار مخصص",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          labelText: Directionality.of(context) == TextDirection.ltr 
                            ? "Title"
                            : "العنوان",
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _bodyController,
                        decoration: InputDecoration(
                          labelText: Directionality.of(context) == TextDirection.ltr 
                            ? "Message"
                            : "الرسالة",
                          border: const OutlineInputBorder(),
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            notificationProvider.sendTestNotification(
                              _titleController.text,
                              _bodyController.text,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  Directionality.of(context) == TextDirection.ltr 
                                    ? "Notification sent!"
                                    : "تم إرسال الإشعار!"
                                )
                              ),
                            );
                          },
                          child: Text(
                            Directionality.of(context) == TextDirection.ltr 
                              ? "Send Notification"
                              : "إرسال الإشعار"
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Order notification
              Card(
                margin: const EdgeInsets.only(bottom: 16),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Directionality.of(context) == TextDirection.ltr 
                          ? "Order Notification"
                          : "إشعار الطلب",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _orderIdController,
                        decoration: InputDecoration(
                          labelText: Directionality.of(context) == TextDirection.ltr 
                            ? "Order ID"
                            : "رقم الطلب",
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _selectedOrderStatus,
                        decoration: InputDecoration(
                          labelText: Directionality.of(context) == TextDirection.ltr 
                            ? "Status"
                            : "الحالة",
                          border: const OutlineInputBorder(),
                        ),
                        items: _orderStatuses.map((status) {
                          return DropdownMenuItem(
                            value: status,
                            child: Text(
                            Directionality.of(context) == TextDirection.ltr 
                              ? status 
                              : _getArabicStatus(status)
                          ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedOrderStatus = value;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: notificationProvider.orderUpdatesEnabled
                              ? () {
                                  notificationProvider.sendOrderNotification(
                                    _orderIdController.text,
                                    _selectedOrderStatus,
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        Directionality.of(context) == TextDirection.ltr 
                                          ? "Order notification sent!"
                                          : "تم إرسال إشعار الطلب!"
                                      ),
                                    ),
                                  );
                                }
                              : null,
                          child: Text(
                            Directionality.of(context) == TextDirection.ltr 
                              ? "Send Order Notification"
                              : "إرسال إشعار الطلب"
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Quick notification buttons
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Directionality.of(context) == TextDirection.ltr 
                          ? "Quick Notifications"
                          : "إشعارات سريعة",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: notificationProvider.promotionsEnabled
                                  ? () {
                                      notificationProvider
                                          .sendPromotionNotification(
                                        Directionality.of(context) == TextDirection.ltr
                                          ? "Weekend Sale!"
                                          : "تخفيضات نهاية الأسبوع!",
                                        Directionality.of(context) == TextDirection.ltr
                                          ? "Get 30% off on all products this weekend."
                                          : "احصل على خصم 30٪ على جميع المنتجات هذا الأسبوع.",
                                      );
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            Directionality.of(context) == TextDirection.ltr 
                                              ? "Promotion notification sent!"
                                              : "تم إرسال إشعار العرض!"
                                          ),
                                        ),
                                      );
                                    }
                                  : null,
                              child: Text(
                                Directionality.of(context) == TextDirection.ltr 
                                  ? "Send Promotion"
                                  : "إرسال عرض خاص"
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: notificationProvider.newArrivalsEnabled
                                  ? () {
                                      notificationProvider
                                          .sendNewArrivalNotification(
                                        Directionality.of(context) == TextDirection.ltr
                                          ? "Hydrating Face Serum"
                                          : "سيروم مرطب للوجه",
                                      );
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            Directionality.of(context) == TextDirection.ltr 
                                              ? "New arrival notification sent!"
                                              : "تم إرسال إشعار المنتج الجديد!"
                                          ),
                                        ),
                                      );
                                    }
                                  : null,
                              child: Text(
                                Directionality.of(context) == TextDirection.ltr 
                                  ? "Send New Arrival"
                                  : "إرسال منتج جديد"
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
