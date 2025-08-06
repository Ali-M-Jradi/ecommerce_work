import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../providers/order_provider.dart';
import '../../models/order.dart';

class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = context.watch<OrderProvider>().orders;
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Order History & Tracking')),
      body: orders.isEmpty
          ? Center(
              child: Text(
                'No orders found.',
                style: TextStyle(color: colorScheme.onSurface.withOpacity(0.7)),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              itemCount: orders.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, i) {
                final order = orders[i];
                final textColor = colorScheme.onSurface;
                return Material(
                  color: colorScheme.surfaceContainerHighest,
                  elevation: 2,
                  borderRadius: BorderRadius.circular(16),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => _showOrderDetails(context, order),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.receipt_long, color: colorScheme.primary, size: 32),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text('Order #${order.id}', style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 16)),
                                    const SizedBox(width: 8),
                                    _buildStatusChip(order.status, colorScheme),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text('Date: ${order.createdAt.toLocal().toString().split(' ')[0]}', style: TextStyle(color: textColor.withOpacity(0.7), fontSize: 13)),
                                Text('Total: \$${order.total.toStringAsFixed(2)}', style: TextStyle(color: textColor, fontWeight: FontWeight.w500)),
                                if ((order.trackingNumber ?? '').isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: TextButton.icon(
                                      style: TextButton.styleFrom(
                                        foregroundColor: colorScheme.primary,
                                        padding: EdgeInsets.zero,
                                        minimumSize: const Size(0, 32),
                                      ),
                                      icon: const Icon(Icons.local_shipping, size: 18),
                                      label: const Text('Track Shipment'),
                                      onPressed: () => _launchTracking(context, order.trackingNumber!),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(Icons.chevron_right, color: colorScheme.primary),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildStatusChip(dynamic status, ColorScheme colorScheme) {
    final statusStr = status.name[0].toUpperCase() + status.name.substring(1);
    Color bgColor;
    switch (statusStr.toLowerCase()) {
      case 'pending':
        bgColor = colorScheme.secondary.withOpacity(0.15);
        break;
      case 'shipped':
        bgColor = Colors.blue.withOpacity(0.15);
        break;
      case 'delivered':
        bgColor = Colors.green.withOpacity(0.15);
        break;
      case 'cancelled':
        bgColor = Colors.red.withOpacity(0.15);
        break;
      default:
        bgColor = colorScheme.primary.withOpacity(0.12);
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        statusStr,
        style: TextStyle(
          color: colorScheme.primary,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  void _showOrderDetails(BuildContext context, Order order) {
    final colorScheme = Theme.of(context).colorScheme;
    final textColor = colorScheme.onSurface;
    showModalBottomSheet(
      context: context,
      backgroundColor: colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.receipt_long, color: colorScheme.primary),
                const SizedBox(width: 8),
                Text('Order #${order.id}', style: TextStyle(fontWeight: FontWeight.bold, color: textColor, fontSize: 18)),
              ],
            ),
            const SizedBox(height: 8),
            Text('Date: ${order.createdAt.toLocal().toString().split(' ')[0]}', style: TextStyle(color: textColor.withOpacity(0.8))),
            Text('Status: ${order.status.name[0].toUpperCase()}${order.status.name.substring(1)}', style: TextStyle(color: textColor.withOpacity(0.8))),
            const SizedBox(height: 12),
            const Text('Items:', style: TextStyle(fontWeight: FontWeight.bold)),
            ...order.items.map((item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Row(
                    children: [
                      Icon(Icons.shopping_bag, size: 16, color: colorScheme.primary),
                      const SizedBox(width: 6),
                      Expanded(child: Text('${item.quantity} x ${item.name}', style: TextStyle(color: textColor))),
                      Text('4${item.price}', style: TextStyle(color: textColor.withOpacity(0.8))),
                    ],
                  ),
                )),
            const SizedBox(height: 12),
            Text('Total: \$${order.total.toStringAsFixed(2)}', style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
            if ((order.trackingNumber ?? '').isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: [
                    Icon(Icons.local_shipping, color: colorScheme.primary, size: 18),
                    const SizedBox(width: 6),
                    Expanded(child: Text('Tracking #: ${order.trackingNumber}', style: TextStyle(color: textColor))),
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: colorScheme.primary,
                      ),
                      onPressed: () => _launchTracking(context, order.trackingNumber!),
                      child: const Text('Track Shipment'),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _launchTracking(BuildContext context, String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open tracking link: $url')),
      );
    }
  }
}
