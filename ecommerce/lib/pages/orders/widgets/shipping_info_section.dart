import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/order.dart';
import '../../../l10n/app_localizations.dart';

class ShippingInfoSection extends StatelessWidget {
  final Order order;

  const ShippingInfoSection({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    // Get theme context for colors
    
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Delivery Address
        _buildSectionTitle(context, localizations?.deliveryAddressTitle ?? 'Delivery Address'),
        const SizedBox(height: 12),
        _buildAddressCard(context, order.shippingAddress),
        
        const SizedBox(height: 24),
        
        // Estimated Delivery
        _buildSectionTitle(context, localizations?.estimatedDeliveryTitle ?? 'Estimated Delivery'),
        const SizedBox(height: 12),
        _buildDeliveryInfo(context),

        const SizedBox(height: 24),
        
        // Carrier Information (if available)
        if (order.trackingNumber != null && 
            (order.status == OrderStatus.shipped || order.status == OrderStatus.delivered))
          ...[
            _buildSectionTitle(context, localizations?.carrierInformationTitle ?? 'Carrier Information'),
            const SizedBox(height: 12),
            _buildCarrierInfo(context),
          ],
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
    );
  }

  Widget _buildAddressCard(BuildContext context, address) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            address.fullName,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(address.streetAddress),
          if (address.addressLine2 != null && address.addressLine2!.isNotEmpty)
            Text(address.addressLine2!),
          Text('${address.city}, ${address.state} ${address.zipCode}'),
          Text(address.country),
          if (address.phoneNumber != null && address.phoneNumber!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(address.phoneNumber!),
          ],
        ],
      ),
    );
  }

  Widget _buildDeliveryInfo(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    
    // Calculate days remaining for delivery
    final now = DateTime.now();
    final estimatedDate = order.estimatedDeliveryDate;
    final daysRemaining = estimatedDate.difference(now).inDays;
    
    String deliveryMessage;
    Color messageColor;
    
    if (order.status == OrderStatus.delivered) {
      deliveryMessage = 'Delivered on ${DateFormat.yMMMd().format(order.deliveredAt!)}';
      messageColor = Colors.green;
    } else if (daysRemaining < 0) {
      deliveryMessage = 'Delivery may be delayed';
      messageColor = Colors.orange;
    } else if (daysRemaining == 0) {
      deliveryMessage = 'Delivering today!';
      messageColor = Colors.green;
    } else if (daysRemaining == 1) {
      deliveryMessage = 'Delivering tomorrow';
      messageColor = Theme.of(context).primaryColor;
    } else {
      deliveryMessage = 'Delivering in ${daysRemaining.toString()} days';
      messageColor = Theme.of(context).primaryColor;
    }
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: messageColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                order.status == OrderStatus.delivered ? Icons.check_circle : Icons.local_shipping,
                color: messageColor,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  deliveryMessage,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: messageColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                localizations?.estimatedDate ?? 'Estimated Date',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              Text(
                DateFormat.yMMMd().format(estimatedDate),
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCarrierInfo(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    // In a real app, you would have actual carrier information
    // For this example, we'll use simulated data
    const carrierName = 'Express Delivery';
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                localizations?.carrierLabel ?? 'Carrier',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              const Text(
                carrierName,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                localizations?.trackingNumberLabel ?? 'Tracking Number',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              Text(
                order.trackingNumber ?? 'N/A',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          if (order.status == OrderStatus.shipped) ...[
            const Divider(height: 24),
            Text(
              localizations?.lastUpdateLabel ?? 'Last Update',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${localizations?.packageInTransit ?? 'Package in transit'} - ${DateFormat.yMMMd().add_Hm().format(order.updatedAt ?? DateTime.now())}',
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
