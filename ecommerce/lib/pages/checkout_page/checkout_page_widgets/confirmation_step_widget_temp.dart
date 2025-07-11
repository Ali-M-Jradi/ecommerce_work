import 'package:flutter/material.dart';
import '../../../models/order.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/order_service.dart';
import 'package:intl/intl.dart' as intl;

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
                  _buildInfoRow(
                    AppLocalizations.of(context)!.orderNumberLabel, 
                    order!.orderNumber),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    AppLocalizations.of(context)!.orderDateLabel, 
                    _formatDate(order!.createdAt, context)),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    AppLocalizations.of(context)!.statusLabel, 
                    _getLocalizedOrderStatus(context, order!.status)),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    AppLocalizations.of(context)!.totalItemsLabel, 
                    order!.totalItems.toString()),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    AppLocalizations.of(context)!.totalAmountLabel, 
                    _formatCurrency(order!.total, context)),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    AppLocalizations.of(context)!.estimatedDeliveryLabel, 
                    _formatDate(_getEstimatedDeliveryDate(), context)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Order Summary
          _buildOrderSummary(context),
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
                  _buildAddressInfo(context, order!.shippingAddress),
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
          const SizedBox(height: 16),

          // Notifications Info Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(context, AppLocalizations.of(context)!.notificationsTitle),
                  const SizedBox(height: 16),
                  _buildNotificationInfo(
                    context, 
                    Icons.check_circle_outline,
                    AppLocalizations.of(context)!.orderConfirmationNotification,
                    Colors.green,
                  ),
                  const SizedBox(height: 8),
                  _buildNotificationInfo(
                    context,
                    Icons.payment,
                    AppLocalizations.of(context)!.paymentConfirmationNotification,
                    Colors.blue,
                  ),
                  const SizedBox(height: 8),
                  _buildNotificationInfo(
                    context,
                    Icons.local_shipping_outlined,
                    AppLocalizations.of(context)!.shippingNotification,
                    Colors.orange,
                  ),
                  const SizedBox(height: 8),
                  _buildNotificationInfo(
                    context,
                    Icons.inventory_2_outlined,
                    AppLocalizations.of(context)!.deliveryNotification,
                    Colors.purple,
                  ),
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
              
              // Cancel Order Button (only shown for eligible orders)
              if (order != null && order!.canBeCancelled) ...[
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      _showCancelOrderDialog(context);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      _getLocalizedText(AppLocalizations.of(context), 'cancelOrderButton', 'Cancel Order'),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
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

  // Helper method to build info row with label and value
  Widget _buildInfoRow(String label, String value, {bool isTotal = false}) {
    final textStyle = isTotal
        ? const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
        : const TextStyle(fontWeight: FontWeight.w500);
        
    final valueStyle = isTotal
        ? const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
        : const TextStyle(fontWeight: FontWeight.bold);
    
    return Row(
      // This ensures proper spacing in both LTR and RTL modes
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      // Wrapping children in Expanded ensures they take appropriate space in both directions
      children: [
        Expanded(
          flex: 3, // Give more space to the label
          child: Text(
            label,
            style: textStyle,
          ),
        ),
        Expanded(
          flex: 2, // Give less space to the value, but enough to fit comfortably
          child: Text(
            value,
            style: valueStyle,
            textAlign: TextAlign.end, // Always align to the end (right in LTR, left in RTL)
          ),
        ),
      ],
    );
  }

  // Helper method to build address info
  Widget _buildAddressInfo(BuildContext context, dynamic address) {
    if (address == null) {
      debugPrint('Warning: Address is null');
      return Text(
        _getLocalizedText(AppLocalizations.of(context), 'addressNotAvailable', 'Address information not available'),
        style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.grey)
      );
    }
    
    final isRTL = Directionality.of(context) == TextDirection.rtl;
    
    try {
      return Column(
        // In RTL mode, align address fields to end (right side)
        crossAxisAlignment: isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            address.fullName ?? _getLocalizedText(AppLocalizations.of(context), 'noNameProvided', 'No name provided'),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(address.streetAddress ?? 
            _getLocalizedText(AppLocalizations.of(context), 'noStreetAddressProvided', 'No street address provided')),
          if (address.addressLine2 != null && address.addressLine2!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(address.addressLine2!),
          ],
          const SizedBox(height: 4),
          Text(
            _formatAddressLine(context, address.city, address.state, address.zipCode),
          ),
          const SizedBox(height: 4),
          Text(address.country ?? 
            _getLocalizedText(AppLocalizations.of(context), 'noCountryProvided', 'No country provided')),
          if (address.phoneNumber != null && address.phoneNumber!.isNotEmpty) ...[
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
    } catch (e) {
      debugPrint('Error building address info: $e');
      return Text(
        _getLocalizedText(AppLocalizations.of(context), 'errorDisplayingAddress', 'Error displaying address information'),
        style: const TextStyle(color: Colors.red)
      );
    }
  }
  
  // Helper method to safely format city, state, and zip code
  String _formatAddressLine(BuildContext context, String? city, String? state, String? zipCode) {
    final parts = <String>[];
    final isRTL = Directionality.of(context) == TextDirection.rtl;
    
    if (city != null && city.isNotEmpty) {
      parts.add(city);
    }
    
    if (state != null && state.isNotEmpty) {
      parts.add(state);
    }
    
    if (zipCode != null && zipCode.isNotEmpty) {
      parts.add(zipCode);
    }
    
    if (parts.isEmpty) {
      return _getLocalizedText(AppLocalizations.of(context), 'noCityStateZipProvided', 'No city/state/zip information provided');
    }
    
    // For RTL languages like Arabic, the order might need adjustment
    // In some RTL locales, the address format might differ
    if (isRTL) {
      final locale = Localizations.localeOf(context).toString();
      
      // For Arabic and some other RTL languages, might need different separators or order
      if (locale.startsWith('ar')) {
        return parts.reversed.join('، '); // Arabic comma
      }
    }
    
    return parts.join(', ');
  }

  // Helper method to build payment method info
  Widget _buildPaymentMethodInfo(BuildContext context, paymentMethod) {
    final isRTL = Directionality.of(context) == TextDirection.rtl;
    
    final textContent = Expanded(
      child: Column(
        crossAxisAlignment: isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start,
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
    );
    
    final iconContent = _buildPaymentMethodIcon(context, paymentMethod);
    final spacer = const SizedBox(width: 12);
    
    return Row(
      // For RTL, we'll need to adjust the order of children
      children: isRTL 
          ? [textContent, spacer, iconContent]
          : [iconContent, spacer, textContent],
    );
  }

  // Helper method to build payment method icon
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

  // Helper method to get card color based on brand
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

  // Helper method to build notification info
  Widget _buildNotificationInfo(BuildContext context, IconData icon, String text, Color color) {
    final isRTL = Directionality.of(context) == TextDirection.rtl;
    
    // Create the icon container
    final iconContainer = Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        icon,
        color: color,
        size: 20,
      ),
    );
    
    // Create the text widget
    final textWidget = Expanded(
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
    
    return Row(
      children: isRTL 
          ? [textWidget, const SizedBox(width: 12), iconContainer]
          : [iconContainer, const SizedBox(width: 12), textWidget],
    );
  }

  // Helper method to format date based on locale and context
  String _formatDate(DateTime date, BuildContext context) {
    // Handle invalid or default date
    if (date == DateTime.fromMillisecondsSinceEpoch(0)) {
      return _getLocalizedText(AppLocalizations.of(context), 'notApplicable', 'N/A');
    }
    
    // Using intl package for locale-aware date formatting
    final locale = Localizations.localeOf(context).toString();
    
    try {
      // For delivered orders, show more detailed date and time
      if (order?.status == OrderStatus.delivered) {
        // Show date and time for delivered orders
        return intl.DateFormat.yMMMd(locale).add_jm().format(date);
      }
      
      // For Arabic and other RTL languages, consider using a different format
      if (Directionality.of(context) == TextDirection.rtl) {
        // Use a format that's more natural for RTL languages
        return intl.DateFormat.yMMMMd(locale).format(date);
      }
      
      // Default format for most cases
      return intl.DateFormat.yMMMd(locale).format(date);
    } catch (e) {
      debugPrint('Error formatting date: $e');
      // Fallback format that should work in most locales
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  // Helper method to show order details dialog
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
              Text('${AppLocalizations.of(context)!.statusLabel}: ${_getLocalizedOrderStatus(context, order!.status)}'),
              const SizedBox(height: 8),
              Text('${AppLocalizations.of(context)!.totalAmountLabel}: ${_formatCurrency(order!.total, context)}'),
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

  // Helper method to build order summary
  Widget _buildOrderSummary(BuildContext context) {
    if (order == null || order!.items.isEmpty) {
      return const SizedBox.shrink();
    }
    
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(context, _getLocalizedText(AppLocalizations.of(context), 'orderSummaryTitle', 'Order Summary')),
            const Divider(height: 24),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: order!.items.length,
              itemBuilder: (context, index) {
                final item = order!.items[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Item image (placeholder)
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Image.network(item.image),
                      ),
                      const SizedBox(width: 12),
                      // Item details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            if (item.size != null)
                              Text(
                                item.size!,
                                style: TextStyle(color: Colors.grey[600], fontSize: 12),
                              ),
                            Text(
                              'x${item.quantity}',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                      // Item price
                      Text(
                        _formatCurrency(item.price * item.quantity, context),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                );
              },
            ),
            const Divider(height: 24),
            // Order totals
            _buildInfoRow(
              _getLocalizedText(AppLocalizations.of(context), 'subtotalLabel', 'Subtotal'), 
              _formatCurrency(order!.subtotal, context)),
            const SizedBox(height: 8),
            _buildInfoRow(
              _getLocalizedText(AppLocalizations.of(context), 'taxLabel', 'Tax'), 
              _formatCurrency(order!.tax, context)),
            const SizedBox(height: 8),
            _buildInfoRow(
              _getLocalizedText(AppLocalizations.of(context), 'shippingLabel', 'Shipping'), 
              _formatCurrency(order!.shipping, context)),
            if (order!.discount > 0) ...[
              const SizedBox(height: 8),
              _buildInfoRow(
                _getLocalizedText(AppLocalizations.of(context), 'discountLabel', 'Discount'), 
                '-${_formatCurrency(order!.discount, context)}'),
            ],
            const Divider(height: 24),
            _buildInfoRow(
              AppLocalizations.of(context)!.totalAmountLabel, 
              _formatCurrency(order!.total, context),
              isTotal: true),
          ],
        ),
      ),
    );
  }

  // Helper method to show cancel order dialog
  Future<void> _showCancelOrderDialog(BuildContext context) async {
    // Get localized strings with fallbacks
    final localizations = AppLocalizations.of(context);
    final cancelTitle = _getLocalizedText(localizations, 'cancelOrderTitle', 'Cancel Order');
    final cancelMessage = _getLocalizedText(localizations, 'cancelOrderConfirmMessage', 
      'Are you sure you want to cancel this order? This action cannot be undone.');
    final cancelButton = _getLocalizedText(localizations, 'cancelButton', 'Cancel');
    final confirmButton = _getLocalizedText(localizations, 'confirmButton', 'Confirm');
    
    final shouldCancel = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(cancelTitle),
        content: Text(cancelMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(cancelButton),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text(confirmButton),
          ),
        ],
      ),
    );
    
    if (shouldCancel == true) {
      try {
        // Import the order service
        final orderService = OrderService.instance;
        
        // Cancel the order
        final cancelledOrder = await orderService.updateOrderStatus(
          order!.id,
          OrderStatus.cancelled,
        );
        
        if (cancelledOrder != null) {
          // Show success message
          _showSnackBar(
            context, 
            _getLocalizedText(
              AppLocalizations.of(context),
              'orderCancellationSuccess',
              'Your order has been successfully cancelled.'
            ),
            Colors.green,
          );
          
          // Refresh the page or navigate back
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/',
            (Route<dynamic> route) => false,
          );
        } else {
          _showSnackBar(
            context, 
            _getLocalizedText(
              AppLocalizations.of(context),
              'orderCancellationFailed',
              'Unable to cancel your order. Please try again or contact customer support.'
            ),
            Colors.red,
          );
        }
      } catch (e) {
        debugPrint('Error cancelling order: $e');
        _showSnackBar(
          context, 
          _getLocalizedText(
            AppLocalizations.of(context),
            'orderCancellationFailed',
            'Unable to cancel your order. Please try again or contact customer support.'
          ),
          Colors.red,
        );
      }
    }
  }
  
  // Helper method to show snack bar messages
  void _showSnackBar(BuildContext context, String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
  
  // Helper method to format currency based on locale
  String _formatCurrency(double amount, BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    
    try {
      // Format currency based on locale
      final currencyFormatter = intl.NumberFormat.currency(
        locale: locale,
        // Use appropriate currency symbol based on locale
        // This is a simple approach - in a real app you might want to use
        // a lookup based on user preferences or store location
        symbol: _getCurrencySymbol(locale),
      );
      
      return currencyFormatter.format(amount);
    } catch (e) {
      debugPrint('Error formatting currency: $e');
      // Fallback format
      return '\$${amount.toStringAsFixed(2)}';
    }
  }
  
  // Helper method to get currency symbol based on locale
  String _getCurrencySymbol(String locale) {
    if (locale.startsWith('ar')) {
      return 'د.إ'; // UAE Dirham for Arabic
    } else if (locale.startsWith('fr')) {
      return '€'; // Euro for French
    } else if (locale.startsWith('es')) {
      return '€'; // Euro for Spanish
    } else if (locale.startsWith('zh')) {
      return '¥'; // Yuan for Chinese
    } else if (locale.startsWith('ja')) {
      return '¥'; // Yen for Japanese
    } else if (locale.startsWith('ru')) {
      return '₽'; // Ruble for Russian
    } else if (locale.startsWith('de')) {
      return '€'; // Euro for German
    } else if (locale.startsWith('pt')) {
      return 'R\$'; // Real for Brazilian Portuguese
    } else if (locale.startsWith('tr')) {
      return '₺'; // Lira for Turkish
    } else if (locale.startsWith('it')) {
      return '€'; // Euro for Italian
    }
    
    // Default to USD
    return '\$';
  }

  // Helper method to get localized order status
  String _getLocalizedOrderStatus(BuildContext context, OrderStatus? status) {
    final localizations = AppLocalizations.of(context)!;
    
    // Handle null status
    if (status == null) {
      debugPrint('Warning: Order status is null, defaulting to "pending"');
      return localizations.orderStatusPending; // Default to pending if status is null
    }
    
    try {
      switch (status) {
        case OrderStatus.pending:
          return localizations.orderStatusPending;
        case OrderStatus.confirmed:
          return localizations.orderStatusConfirmed;
        case OrderStatus.processing:
          return localizations.orderStatusProcessing;
        case OrderStatus.shipped:
          return localizations.orderStatusShipped;
        case OrderStatus.delivered:
          return localizations.orderStatusDelivered;
        case OrderStatus.cancelled:
          return localizations.orderStatusCancelled;
        case OrderStatus.refunded:
          return localizations.orderStatusRefunded;
      }
    } catch (e) {
      debugPrint('Error getting localized order status: $e');
      return status.toString(); // Fallback to enum string representation
    }
  }

  // Helper method to get estimated delivery date
  DateTime _getEstimatedDeliveryDate() {
    try {
      // If order is null, return a default date
      if (order == null) {
        debugPrint('Warning: Order is null, using current date + 5 days');
        return DateTime.now().add(const Duration(days: 5));
      }
      
      // Use the built-in estimatedDeliveryDate getter from the Order class
      // which already handles different statuses
      return order!.estimatedDeliveryDate;
    } catch (e) {
      // Handle any unexpected errors
      debugPrint('Error calculating estimated delivery date: $e');
      return DateTime.now().add(const Duration(days: 5)); // Fallback
    }
  }

  // Helper method to safely get localized text with a fallback
  String _getLocalizedText(AppLocalizations? localizations, String key, String fallback) {
    if (localizations == null) {
      return fallback;
    }
    
    try {
      // Use dynamic to access properties that might not be defined in the interface
      final dynamic localizationsDynamic = localizations;
      final value = localizationsDynamic[key] as String?;
      return value ?? fallback;
    } catch (e) {
      debugPrint('Warning: Localization key "$key" not found: $e');
      return fallback;
    }
  }
}
