import 'package:flutter/material.dart';
import '../models/order.dart';
import '../models/cart_item.dart';
import '../models/address.dart';
import '../models/payment_method.dart';

class OrderProvider extends ChangeNotifier {
  final List<Order> _orders = [
    Order(
      id: 'ORD123456',
      userId: 'user1',
      items: [
        CartItem(
          id: 'cart1',
          productId: '5287002102122',
          name: 'Thermal Spring Water Face Mist',
          brand: 'Avène',
          price: 12.99,
          image: '',
          quantity: 1,
        ),
        CartItem(
          id: 'cart2',
          productId: 'face_cleanser_1',
          name: 'Gentle Milk Cleanser',
          brand: 'Avène',
          price: 16.99,
          image: '',
          quantity: 2,
        ),
      ],
      shippingAddress: Address(
        id: 'addr1',
        fullName: 'John Doe',
        streetAddress: '123 Main St',
        city: 'City',
        state: 'State',
        zipCode: '12345',
        country: 'Country',
      ),
      paymentMethod: PaymentMethod(
        id: 'pm1',
        type: 'card',
        displayName: 'Visa',
        cardNumber: '1234',
        cardBrand: 'visa',
        isDefault: true,
        isEnabled: true,
      ),
      status: OrderStatus.shipped,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      subtotal: 46.97,
      tax: 0.0,
      shipping: 0.0,
      discount: 0.0,
      total: 46.97,
      trackingNumber: 'TRACK123456',
      statusHistory: ['Processing', 'Shipped'],
    ),
    Order(
      id: 'ORD654321',
      userId: 'user1',
      items: [
        CartItem(
          id: 'cart3',
          productId: 'hair_shampoo_1',
          name: 'Dercos Anti-Dandruff Shampoo',
          brand: 'Vichy',
          price: 18.99,
          image: '',
          quantity: 1,
        ),
      ],
      shippingAddress: Address(
        id: 'addr1',
        fullName: 'John Doe',
        streetAddress: '123 Main St',
        city: 'City',
        state: 'State',
        zipCode: '12345',
        country: 'Country',
      ),
      paymentMethod: PaymentMethod(
        id: 'pm1',
        type: 'card',
        displayName: 'Visa',
        cardNumber: '1234',
        cardBrand: 'visa',
        isDefault: true,
        isEnabled: true,
      ),
      status: OrderStatus.delivered,
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      subtotal: 18.99,
      tax: 0.0,
      shipping: 0.0,
      discount: 0.0,
      total: 18.99,
      trackingNumber: 'TRACK654321',
      statusHistory: ['Processing', 'Shipped', 'Delivered'],
    ),
  ];

  List<Order> get orders => List.unmodifiable(_orders);

  Order? getOrderById(String id) {
    try {
      return _orders.firstWhere((o) => o.id == id);
    } catch (_) {
      return null;
    }
  }
}
