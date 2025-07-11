import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/order.dart';
import '../../../l10n/app_localizations.dart';

class OrderStatusTimeline extends StatelessWidget {
  final Order order;

  const OrderStatusTimeline({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    
    // Define all possible statuses in order
    final allStatuses = OrderStatus.values;
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localizations?.orderStatus ?? 'Order Status',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildStatusTimeline(context, allStatuses),
        ],
      ),
    );
  }

  Widget _buildStatusTimeline(BuildContext context, List<OrderStatus> statuses) {
    // Filter out statuses that aren't relevant to the normal flow (like refunded)
    final relevantStatuses = statuses.where((s) => 
      s != OrderStatus.cancelled && s != OrderStatus.refunded).toList();
    
    // If order is cancelled or refunded, add that at the end instead
    if (order.status == OrderStatus.cancelled || order.status == OrderStatus.refunded) {
      relevantStatuses.add(order.status);
    }
    
    return Column(
      children: List.generate(relevantStatuses.length, (index) {
        final status = relevantStatuses[index];
        final isActive = order.status.index >= status.index || 
                         order.status == status;
        final isCurrentStatus = order.status == status;
        
        // Find when this status was reached in status history
        final statusText = _getStatusTextForEnum(status);
        final statusIndex = order.statusHistory.indexWhere(
            (hist) => hist.toLowerCase().contains(statusText.toLowerCase()));
        
        // Only show datetime for statuses that have been reached
        DateTime? statusDate;
        if (statusIndex != -1 && statusIndex < order.statusHistory.length) {
          if (status == OrderStatus.delivered && order.deliveredAt != null) {
            statusDate = order.deliveredAt;
          } else if (order.statusHistory.length > 1 && 
                    statusIndex > 0 && 
                    statusIndex < order.statusHistory.length) {
            // For other statuses, use the updatedAt time if available
            statusDate = order.updatedAt;
          } else if (status == OrderStatus.pending) {
            // For pending (initial) status, use the createdAt time
            statusDate = order.createdAt;
          }
        }

        return Column(
          children: [
            Row(
              children: [
                // Status circle indicator
                _buildStatusCircle(isActive, isCurrentStatus),
                
                const SizedBox(width: 16),
                
                // Status text and date
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getLocalizedStatus(context, status),
                        style: TextStyle(
                          fontWeight: isCurrentStatus 
                              ? FontWeight.bold 
                              : FontWeight.normal,
                          fontSize: 16,
                          color: isActive ? Colors.black : Colors.grey,
                        ),
                      ),
                      if (statusDate != null)
                        Text(
                          DateFormat.yMMMd().add_Hm().format(statusDate),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            
            // Connecting line to next status
            if (index < relevantStatuses.length - 1)
              Container(
                margin: const EdgeInsets.only(left: 12),
                height: 30,
                width: 2,
                color: isActive ? Theme.of(context).primaryColor : Colors.grey[300],
              ),
          ],
        );
      }),
    );
  }

  Widget _buildStatusCircle(bool isActive, bool isCurrentStatus) {
    return Builder(
      builder: (context) {
        return Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive 
                ? (isCurrentStatus ? Colors.green : Theme.of(context).primaryColor) 
                : Colors.grey[300],
            border: isCurrentStatus 
                ? Border.all(color: Colors.green, width: 3) 
                : null,
          ),
          child: isActive 
              ? Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 16,
                )
              : null,
        );
      }
    );
  }

  String _getLocalizedStatus(BuildContext context, OrderStatus status) {
    final localizations = AppLocalizations.of(context);
    
    switch (status) {
      case OrderStatus.pending:
        return localizations?.orderStatusPending ?? 'Pending';
      case OrderStatus.confirmed:
        return localizations?.orderStatusConfirmed ?? 'Confirmed';
      case OrderStatus.processing:
        return localizations?.orderStatusProcessing ?? 'Processing';
      case OrderStatus.shipped:
        return localizations?.orderStatusShipped ?? 'Shipped';
      case OrderStatus.delivered:
        return localizations?.orderStatusDelivered ?? 'Delivered';
      case OrderStatus.cancelled:
        return localizations?.orderStatusCancelled ?? 'Cancelled';
      case OrderStatus.refunded:
        return localizations?.orderStatusRefunded ?? 'Refunded';
    }
  }

  String _getStatusTextForEnum(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'placed';
      case OrderStatus.confirmed:
        return 'confirmed';
      case OrderStatus.processing:
        return 'processed';
      case OrderStatus.shipped:
        return 'shipped';
      case OrderStatus.delivered:
        return 'delivered';
      case OrderStatus.cancelled:
        return 'cancelled';
      case OrderStatus.refunded:
        return 'refunded';
    }
  }
}
