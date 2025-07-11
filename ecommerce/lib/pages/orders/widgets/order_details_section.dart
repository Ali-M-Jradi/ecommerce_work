import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/order.dart';
import '../../../models/cart_item.dart';
import '../../../l10n/app_localizations.dart';

class OrderDetailsSection extends StatelessWidget {
  final Order order;

  const OrderDetailsSection({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final currencyFormat = NumberFormat.currency(symbol: _getCurrencySymbol(context));
    
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Order Items
        _buildSectionTitle(context, localizations?.orderItems ?? 'Order Items'),
        const SizedBox(height: 12),
        _buildOrderItems(context, currencyFormat),
        
        const SizedBox(height: 24),
        
        // Payment Summary
        _buildSectionTitle(context, localizations?.paymentSummary ?? 'Payment Summary'),
        const SizedBox(height: 12),
        _buildPaymentSummary(context, currencyFormat, localizations),
        
        const SizedBox(height: 24),
        
        // Payment Method
        _buildSectionTitle(context, 'Payment Method'),
        const SizedBox(height: 12),
        _buildPaymentMethod(context),
        
        // Order Notes (if any)
        if (order.notes != null && order.notes!.isNotEmpty) ...[
          const SizedBox(height: 24),
          _buildSectionTitle(context, 'Order Notes'),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              order.notes!,
              style: TextStyle(color: Colors.grey[800]),
            ),
          ),
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

  Widget _buildOrderItems(BuildContext context, NumberFormat currencyFormat) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: order.items.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final item = order.items[index];
        return _buildOrderItem(context, item, currencyFormat);
      },
    );
  }

  Widget _buildOrderItem(BuildContext context, CartItem item, NumberFormat currencyFormat) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Product Image
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey[200],
            image: item.image.isNotEmpty
                ? DecorationImage(
                    image: NetworkImage(item.image),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: item.image.isEmpty
              ? const Icon(Icons.spa, size: 30, color: Colors.grey)
              : null,
        ),
        const SizedBox(width: 12),
        // Product Details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.name,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              if (item.size != null && item.size!.isNotEmpty)
                Text(
                  '${AppLocalizations.of(context)?.sizeLabel ?? 'Size'}: ${item.size}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    currencyFormat.format(item.price),
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${AppLocalizations.of(context)?.quantityLabel ?? 'Qty'}: ${item.quantity}',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentSummary(BuildContext context, NumberFormat currencyFormat, AppLocalizations? localizations) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          _buildSummaryRow(
            localizations?.subtotalLabel ?? 'Subtotal',
            currencyFormat.format(order.subtotal),
          ),
          const SizedBox(height: 8),
          _buildSummaryRow(
            localizations?.taxLabel ?? 'Tax',
            currencyFormat.format(order.tax),
          ),
          const SizedBox(height: 8),
          _buildSummaryRow(
            localizations?.shippingLabel ?? 'Shipping',
            currencyFormat.format(order.shipping),
          ),
          if (order.discount > 0) ...[
            const SizedBox(height: 8),
            _buildSummaryRow(
              localizations?.discountLabel ?? 'Discount',
              '- ${currencyFormat.format(order.discount)}',
              valueColor: Colors.green,
            ),
          ],
          const Divider(height: 24),
          _buildSummaryRow(
            localizations?.totalLabel ?? 'Total',
            currencyFormat.format(order.total),
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false, Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? Colors.black : Colors.grey[700],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: valueColor ?? (isTotal ? Colors.black : Colors.grey[700]),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethod(BuildContext context) {
    final method = order.paymentMethod;
    final paymentIcon = _getPaymentMethodIcon(method.type);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(paymentIcon, size: 24, color: Colors.black87),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  method.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                if (method.details != null && method.details!.isNotEmpty)
                  Text(
                    method.details!,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getPaymentMethodIcon(String type) {
    switch (type.toLowerCase()) {
      case 'credit_card':
      case 'credit card':
      case 'debit_card':
      case 'debit card':
        return Icons.credit_card;
      case 'paypal':
        return Icons.account_balance_wallet;
      case 'apple_pay':
      case 'apple pay':
        return Icons.apple;
      case 'google_pay':
      case 'google pay':
        return Icons.g_mobiledata;
      case 'cash_on_delivery':
      case 'cash on delivery':
      case 'cod':
        return Icons.money;
      default:
        return Icons.payment;
    }
  }

  String _getCurrencySymbol(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    
    if (locale.startsWith('ar')) {
      return 'د.إ'; // AED for Arabic
    } else if (locale.startsWith('en')) {
      return '\$'; // USD for English
    }
    
    return '\$'; // Default to USD
  }
}
