import 'cart_item.dart';
import 'address.dart';
import 'payment_method.dart';

enum OrderStatus {
  pending,
  confirmed,
  processing,
  shipped,
  delivered,
  cancelled,
  refunded,
}

class Order {
  final String id;
  final String userId;
  final List<CartItem> items;
  final Address shippingAddress;
  final Address? billingAddress;
  final PaymentMethod paymentMethod;
  final OrderStatus status;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? deliveredAt;
  final double subtotal;
  final double tax;
  final double shipping;
  final double discount;
  final double total;
  final String? notes;
  final String? trackingNumber;
  final List<String> statusHistory;

  Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.shippingAddress,
    this.billingAddress,
    required this.paymentMethod,
    required this.status,
    required this.createdAt,
    this.updatedAt,
    this.deliveredAt,
    required this.subtotal,
    required this.tax,
    required this.shipping,
    required this.discount,
    required this.total,
    this.notes,
    this.trackingNumber,
    this.statusHistory = const [],
  });

  // Factory constructor to create order from cart
  factory Order.fromCart({
    required String id,
    required String userId,
    required List<CartItem> cartItems,
    required Address shippingAddress,
    Address? billingAddress,
    required PaymentMethod paymentMethod,
    String? notes,
    double taxRate = 0.08, // 8% tax
    double shippingCost = 9.99,
    double discountAmount = 0.0,
  }) {
    final subtotal = cartItems.fold(
      0.0,
      (sum, item) => sum + (item.price * item.quantity),
    );
    
    final tax = subtotal * taxRate;
    final total = subtotal + tax + shippingCost - discountAmount;

    return Order(
      id: id,
      userId: userId,
      items: cartItems,
      shippingAddress: shippingAddress,
      billingAddress: billingAddress,
      paymentMethod: paymentMethod,
      status: OrderStatus.pending,
      createdAt: DateTime.now(),
      subtotal: subtotal,
      tax: tax,
      shipping: shippingCost,
      discount: discountAmount,
      total: total,
      notes: notes,
      statusHistory: ['Order placed'],
    );
  }

  // Get total item count
  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  // Get formatted status
  String get statusText {
    switch (status) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.shipped:
        return 'Shipped';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
      case OrderStatus.refunded:
        return 'Refunded';
    }
  }

  // Get status color
  String get statusColor {
    switch (status) {
      case OrderStatus.pending:
        return '#FF9800'; // Orange
      case OrderStatus.confirmed:
        return '#2196F3'; // Blue
      case OrderStatus.processing:
        return '#9C27B0'; // Purple
      case OrderStatus.shipped:
        return '#00BCD4'; // Cyan
      case OrderStatus.delivered:
        return '#4CAF50'; // Green
      case OrderStatus.cancelled:
        return '#F44336'; // Red
      case OrderStatus.refunded:
        return '#607D8B'; // Blue Grey
    }
  }

  // Check if order can be cancelled
  bool get canBeCancelled {
    return status == OrderStatus.pending || 
           status == OrderStatus.confirmed;
  }

  // Check if order can be returned
  bool get canBeReturned {
    return status == OrderStatus.delivered && 
           deliveredAt != null &&
           DateTime.now().difference(deliveredAt!).inDays <= 30;
  }

  // Get estimated delivery date
  DateTime get estimatedDeliveryDate {
    switch (status) {
      case OrderStatus.pending:
      case OrderStatus.confirmed:
        return createdAt.add(const Duration(days: 7));
      case OrderStatus.processing:
        return createdAt.add(const Duration(days: 5));
      case OrderStatus.shipped:
        return createdAt.add(const Duration(days: 3));
      case OrderStatus.delivered:
        return deliveredAt ?? createdAt;
      case OrderStatus.cancelled:
      case OrderStatus.refunded:
        return createdAt;
    }
  }

  // Get formatted order number
  String get orderNumber => 'ORD-${id.substring(0, 8).toUpperCase()}';

  // Update order status
  Order updateStatus(OrderStatus newStatus, {String? trackingNumber}) {
    final statusMessage = _getStatusMessage(newStatus);
    final updatedHistory = [...statusHistory, statusMessage];
    
    return copyWith(
      status: newStatus,
      updatedAt: DateTime.now(),
      trackingNumber: trackingNumber ?? this.trackingNumber,
      statusHistory: updatedHistory,
      deliveredAt: newStatus == OrderStatus.delivered ? DateTime.now() : deliveredAt,
    );
  }

  String _getStatusMessage(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'Order placed';
      case OrderStatus.confirmed:
        return 'Order confirmed';
      case OrderStatus.processing:
        return 'Order is being processed';
      case OrderStatus.shipped:
        return 'Order shipped';
      case OrderStatus.delivered:
        return 'Order delivered';
      case OrderStatus.cancelled:
        return 'Order cancelled';
      case OrderStatus.refunded:
        return 'Order refunded';
    }
  }

  // Copy with method for updates
  Order copyWith({
    String? id,
    String? userId,
    List<CartItem>? items,
    Address? shippingAddress,
    Address? billingAddress,
    PaymentMethod? paymentMethod,
    OrderStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deliveredAt,
    double? subtotal,
    double? tax,
    double? shipping,
    double? discount,
    double? total,
    String? notes,
    String? trackingNumber,
    List<String>? statusHistory,
  }) {
    return Order(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      items: items ?? this.items,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      billingAddress: billingAddress ?? this.billingAddress,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deliveredAt: deliveredAt ?? this.deliveredAt,
      subtotal: subtotal ?? this.subtotal,
      tax: tax ?? this.tax,
      shipping: shipping ?? this.shipping,
      discount: discount ?? this.discount,
      total: total ?? this.total,
      notes: notes ?? this.notes,
      trackingNumber: trackingNumber ?? this.trackingNumber,
      statusHistory: statusHistory ?? this.statusHistory,
    );
  }

  // Convert to map for storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'items': items.map((item) => item.toMap()).toList(),
      'shippingAddress': shippingAddress.toMap(),
      'billingAddress': billingAddress?.toMap(),
      'paymentMethod': paymentMethod.toMap(),
      'status': status.index,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'deliveredAt': deliveredAt?.toIso8601String(),
      'subtotal': subtotal,
      'tax': tax,
      'shipping': shipping,
      'discount': discount,
      'total': total,
      'notes': notes,
      'trackingNumber': trackingNumber,
      'statusHistory': statusHistory,
    };
  }

  // Create from map
  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      items: (map['items'] as List<dynamic>?)
          ?.map((item) => CartItem.fromMap(item))
          .toList() ?? [],
      shippingAddress: Address.fromMap(map['shippingAddress']),
      billingAddress: map['billingAddress'] != null 
          ? Address.fromMap(map['billingAddress'])
          : null,
      paymentMethod: PaymentMethod.fromMap(map['paymentMethod']),
      status: OrderStatus.values[map['status'] ?? 0],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: map['updatedAt'] != null 
          ? DateTime.parse(map['updatedAt'])
          : null,
      deliveredAt: map['deliveredAt'] != null 
          ? DateTime.parse(map['deliveredAt'])
          : null,
      subtotal: map['subtotal']?.toDouble() ?? 0.0,
      tax: map['tax']?.toDouble() ?? 0.0,
      shipping: map['shipping']?.toDouble() ?? 0.0,
      discount: map['discount']?.toDouble() ?? 0.0,
      total: map['total']?.toDouble() ?? 0.0,
      notes: map['notes'],
      trackingNumber: map['trackingNumber'],
      statusHistory: (map['statusHistory'] as List<dynamic>?)
          ?.map((item) => item.toString())
          .toList() ?? [],
    );
  }

  @override
  String toString() {
    return 'Order{id: $id, orderNumber: $orderNumber, status: $statusText, total: \$${total.toStringAsFixed(2)}}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Order && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
