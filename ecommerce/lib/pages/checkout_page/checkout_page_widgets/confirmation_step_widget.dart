import 'package:flutter/material.dart';
import '../../../models/order.dart';
import '../../../l10n/app_localizations.dart';
import '../../../localization/app_localizations_helper.dart';

class ConfirmationStepWidget extends StatelessWidget {
  final Order? order;

  const ConfirmationStepWidget({
    Key? key,
    this.order,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (order == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Success Icon
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(50),
            ),
            child: const Icon(
              Icons.check,
              color: Colors.white,
              size: 60,
            ),
          ),
          const SizedBox(height: 24),

          // Success Message
          Text(
            AppLocalizations.of(context)!.orderConfirmedTitle,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.orderConfirmedMessage,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),

          // Order Info Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(context, AppLocalizations.of(context)!.orderDetailsTitle),
                  const SizedBox(height: 16),
                  _buildInfoRow(AppLocalizations.of(context)!.orderNumberLabel, order!.orderNumber),
                  const SizedBox(height: 8),
                  _buildInfoRow(AppLocalizations.of(context)!.orderDateLabel, _formatDate(order!.createdAt)),
                  const SizedBox(height: 8),
                  _buildInfoRow(AppLocalizations.of(context)!.statusLabel, AppLocalizationsHelper.getLocalizedOrderStatus(context, order!.status)),
                  const SizedBox(height: 8),
                  _buildInfoRow(AppLocalizations.of(context)!.totalItemsLabel, order!.totalItems.toString()),
                  const SizedBox(height: 8),
                  _buildInfoRow(AppLocalizations.of(context)!.totalAmountLabel, '\$${order!.total.toStringAsFixed(2)}'),
                  const SizedBox(height: 8),
                  _buildInfoRow(AppLocalizations.of(context)!.estimatedDeliveryLabel, _formatDate(order!.estimatedDeliveryDate)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Shipping Address Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(context, AppLocalizations.of(context)!.shippingAddressTitle),
                  const SizedBox(height: 16),
                  _buildAddressInfo(order!.shippingAddress),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Payment Method Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(context, AppLocalizations.of(context)!.paymentStep),
                  const SizedBox(height: 16),
                  _buildPaymentMethodInfo(context, order!.paymentMethod),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Action Buttons
          Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to order tracking or order details
                    _showOrderDetails(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.viewOrderDetailsButton,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    // Navigate back to home
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      '/',
                      (Route<dynamic> route) => false,
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.continueShoppingButton,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Additional Info
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Colors.blue[600],
                  size: 24,
                ),
                const SizedBox(height: 8),
                Text(
                  AppLocalizations.of(context)!.orderUpdatesTitle,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  AppLocalizations.of(context)!.orderUpdatesMessage,
                  style: TextStyle(
                    color: Colors.blue[700],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildAddressInfo(address) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          address.fullName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(address.streetAddress),
        if (address.addressLine2 != null) ...[
          const SizedBox(height: 4),
          Text(address.addressLine2!),
        ],
        const SizedBox(height: 4),
        Text('${address.city}, ${address.state} ${address.zipCode}'),
        const SizedBox(height: 4),
        Text(address.country),
        if (address.phoneNumber != null) ...[
          const SizedBox(height: 4),
          Text(
            address.phoneNumber!,
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPaymentMethodInfo(BuildContext context, paymentMethod) {
    return Row(
      children: [
        _buildPaymentMethodIcon(context, paymentMethod),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                paymentMethod.formattedDisplay,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (paymentMethod.type == 'card' && 
                  paymentMethod.expiryMonth != null &&
                  paymentMethod.expiryYear != null) ...[
                const SizedBox(height: 4),
                Text(
                  '${AppLocalizations.of(context)!.expiresLabel}'
                    .replaceAll('{month}', paymentMethod.expiryMonth.toString())
                    .replaceAll('{year}', paymentMethod.expiryYear.toString()),
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodIcon(BuildContext context, paymentMethod) {
    switch (paymentMethod.type) {
      case 'card':
        return Container(
          width: 40,
          height: 24,
          decoration: BoxDecoration(
            color: _getCardColor(paymentMethod.cardBrand),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: Text(
              paymentMethod.cardBrand?.toUpperCase() ?? AppLocalizations.of(context)!.cardLabel,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 8,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      case 'paypal':
        return Container(
          width: 40,
          height: 24,
          decoration: BoxDecoration(
            color: const Color(0xFF0070BA),
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Center(
            child: Icon(
              Icons.paypal,
              color: Colors.white,
              size: 16,
            ),
          ),
        );
      case 'apple_pay':
        return Container(
          width: 40,
          height: 24,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Center(
            child: Icon(
              Icons.apple,
              color: Colors.white,
              size: 16,
            ),
          ),
        );
      case 'google_pay':
        return Container(
          width: 40,
          height: 24,
          decoration: BoxDecoration(
            color: const Color(0xFF4285F4),
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Center(
            child: Text(
              'G',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      default:
        return Container(
          width: 40,
          height: 24,
          decoration: BoxDecoration(
            color: Colors.grey[600],
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Center(
            child: Icon(
              Icons.payment,
              color: Colors.white,
              size: 16,
            ),
          ),
        );
    }
  }

  Color _getCardColor(String? cardBrand) {
    switch (cardBrand?.toLowerCase()) {
      case 'visa':
        return const Color(0xFF1A1F71);
      case 'mastercard':
        return const Color(0xFFEB001B);
      case 'amex':
      case 'american_express':
        return const Color(0xFF006FCF);
      case 'discover':
        return const Color(0xFFFF6000);
      default:
        return Colors.grey[600]!;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showOrderDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.orderDetailsDialogTitle),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${AppLocalizations.of(context)!.orderNumberLabel}: ${order!.orderNumber}'),
              const SizedBox(height: 8),
              Text('${AppLocalizations.of(context)!.statusLabel}: ${AppLocalizationsHelper.getLocalizedOrderStatus(context, order!.status)}'),
              const SizedBox(height: 8),
              Text('${AppLocalizations.of(context)!.totalAmountLabel}: \$${order!.total.toStringAsFixed(2)}'),
              const SizedBox(height: 8),
              Text('${AppLocalizations.of(context)!.totalItemsLabel}: ${order!.totalItems}'),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context)!.orderEmailUpdatesMessage,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.closeButton),
          ),
        ],
      ),
    );
  }
}
