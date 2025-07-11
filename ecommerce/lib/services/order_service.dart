import 'package:ecommerce/models/order.dart';
import 'package:ecommerce/services/notification_scheduler_service.dart';
import 'package:ecommerce/main.dart';
import 'dart:async';

class OrderService {
  static final OrderService _instance = OrderService._();
  static OrderService get instance => _instance;
  
  // Private constructor
  OrderService._();
  
  // Map to store orders
  final Map<String, Order> _orders = {};
  
  // Notification scheduler service
  final NotificationSchedulerService _notificationService = NotificationSchedulerService.instance;
  
  // Stream controllers for order updates
  final _orderStreamController = StreamController<Order>.broadcast();
  Stream<Order> get orderStream => _orderStreamController.stream;
  
  // Add a new order
  Future<Order> addOrder(Order order) async {
    _orders[order.id] = order;
    _orderStreamController.add(order);
    
    // Send order confirmation notification
    await _notificationService.scheduleOrderConfirmation(
      order.id,
      'Customer', // TODO: Replace with actual customer name
      order.total,
    );
    
    return order;
  }
  
  // Get an order by ID
  Order? getOrderById(String orderId) {
    return _orders[orderId];
  }
  
  // Get all orders
  List<Order> getAllOrders() {
    return _orders.values.toList();
  }
  
  // Update order status
  Future<Order?> updateOrderStatus(String orderId, OrderStatus newStatus) async {
    final order = _orders[orderId];
    if (order == null) {
      return null;
    }
    
    // Create a new order with updated status
    final updatedOrder = Order(
      id: order.id,
      userId: order.userId,
      items: order.items,
      shippingAddress: order.shippingAddress,
      billingAddress: order.billingAddress,
      paymentMethod: order.paymentMethod,
      status: newStatus,
      createdAt: order.createdAt,
      updatedAt: DateTime.now(),
      deliveredAt: newStatus == OrderStatus.delivered ? DateTime.now() : order.deliveredAt,
      subtotal: order.subtotal,
      tax: order.tax,
      shipping: order.shipping,
      discount: order.discount,
      total: order.total,
      notes: order.notes,
      trackingNumber: order.trackingNumber,
      statusHistory: [...order.statusHistory, newStatus.toString().split('.').last],
    );
    
    // Update the order in the map
    _orders[orderId] = updatedOrder;
    
    // Notify listeners
    _orderStreamController.add(updatedOrder);
    
    // Send notifications based on new status
    await _sendStatusNotification(updatedOrder, newStatus);
    
    return updatedOrder;
  }
  
  // Send notifications based on order status
  Future<void> _sendStatusNotification(Order order, OrderStatus status) async {
    final orderId = order.id;
    
    switch (status) {
      case OrderStatus.confirmed:
        // Order is confirmed after payment is processed
        await _notificationService.schedulePaymentConfirmation(
          orderId,
          order.total,
        );
        break;
        
      case OrderStatus.shipped:
        // Order is shipped
        // Calculate estimated delivery date (5 days from now)
        final estimatedDelivery = DateTime.now().add(const Duration(days: 5));
        await _notificationService.scheduleShippingNotification(
          orderId,
          estimatedDelivery,
        );
        break;
        
      case OrderStatus.delivered:
        // Order is delivered
        await _notificationService.scheduleDeliveryConfirmation(orderId);
        break;
        
      default:
        // No notification for other statuses
        break;
    }
  }
  
  // Simulate order processing flow (for testing or demo purposes)
  Future<void> simulateOrderFlow(String orderId) async {
    // Confirm the order
    await Future.delayed(const Duration(seconds: 5));
    await updateOrderStatus(orderId, OrderStatus.confirmed);
    
    // Process the order
    await Future.delayed(const Duration(seconds: 10));
    await updateOrderStatus(orderId, OrderStatus.processing);
    
    // Ship the order
    await Future.delayed(const Duration(seconds: 15));
    await updateOrderStatus(orderId, OrderStatus.shipped);
    
    // Deliver the order
    await Future.delayed(const Duration(seconds: 20));
    await updateOrderStatus(orderId, OrderStatus.delivered);
  }
  
  // Dispose resources
  void dispose() {
    _orderStreamController.close();
  }
  
  // Navigate to order tracking page
  void navigateToOrderTracking(String orderId) {
    navigatorKey.currentState?.pushNamed(
      '/order-tracking',
      arguments: {'orderId': orderId},
    );
  }
}
