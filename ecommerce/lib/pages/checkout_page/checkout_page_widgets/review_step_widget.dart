import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/address.dart';
import '../../../models/payment_method.dart';
import '../../../providers/cart_provider.dart';
import '../../../l10n/app_localizations.dart';

class ReviewStepWidget extends StatefulWidget {
  final Address? shippingAddress;
  final Address? billingAddress;
  final PaymentMethod? paymentMethod;
  final String? notes;
  final Function(String) onNotesChanged;
  final VoidCallback onEditAddress;
  final VoidCallback onEditPayment;

  const ReviewStepWidget({
    Key? key,
    this.shippingAddress,
    this.billingAddress,
    this.paymentMethod,
    this.notes,
    required this.onNotesChanged,
    required this.onEditAddress,
    required this.onEditPayment,
  }) : super(key: key);

  @override
  State<ReviewStepWidget> createState() => _ReviewStepWidgetState();
}

class _ReviewStepWidgetState extends State<ReviewStepWidget> {
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _notesController.text = widget.notes ?? '';
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order Items
          _buildSectionTitle(AppLocalizations.of(context)!.orderItemsTitle),
          const SizedBox(height: 16),
          _buildOrderItemsList(),
          const SizedBox(height: 24),

          // Shipping Address
          _buildSectionTitle(AppLocalizations.of(context)!.shippingAddressTitle),
          const SizedBox(height: 16),
          _buildAddressCard(
            widget.shippingAddress,
            AppLocalizations.of(context)!.noShippingAddress,
            widget.onEditAddress,
          ),
          const SizedBox(height: 24),

          // Billing Address
          _buildSectionTitle(AppLocalizations.of(context)!.billingAddressTitle),
          const SizedBox(height: 16),
          _buildAddressCard(
            widget.billingAddress,
            AppLocalizations.of(context)!.sameAsShippingAddress,
            widget.onEditAddress,
          ),
          const SizedBox(height: 24),

          // Payment Method
          _buildSectionTitle(AppLocalizations.of(context)!.paymentStep),
          const SizedBox(height: 16),
          _buildPaymentMethodCard(),
          const SizedBox(height: 24),

          // Order Notes
          _buildSectionTitle(AppLocalizations.of(context)!.orderNotesLabel),
          const SizedBox(height: 16),
          _buildNotesField(),
          const SizedBox(height: 24),

          // Order Summary
          _buildSectionTitle(AppLocalizations.of(context)!.orderSummaryTitle),
          const SizedBox(height: 16),
          _buildOrderSummary(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildOrderItemsList() {
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        if (cart.items.isEmpty) {
          return Center(
            child: Text(AppLocalizations.of(context)!.noItemsInCart),
          );
        }

        return Card(
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: cart.items.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final item = cart.items[index];
              return ListTile(
                leading: item.image.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          item.image,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.image,
                                color: Colors.grey,
                              ),
                            );
                          },
                        ),
                      )
                    : Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.image,
                          color: Colors.grey,
                        ),
                      ),
                title: Text(
                  item.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  AppLocalizations.of(context)!.quantityLabel(item.quantity),
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
                trailing: Text(
                  '\$${(item.price * item.quantity).toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildAddressCard(Address? address, String fallbackText, VoidCallback onEdit) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: address != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    address.fullName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
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
              )
            : Text(
                fallbackText,
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
        trailing: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: onEdit,
        ),
      ),
    );
  }

  Widget _buildPaymentMethodCard() {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: widget.paymentMethod != null
            ? _buildPaymentMethodIcon(widget.paymentMethod!)
            : null,
        title: widget.paymentMethod != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.paymentMethod!.formattedDisplay,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (widget.paymentMethod!.type == 'card' && 
                      widget.paymentMethod!.expiryMonth != null &&
                      widget.paymentMethod!.expiryYear != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Expires ${widget.paymentMethod!.expiryMonth}/${widget.paymentMethod!.expiryYear}',
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ],
              )
            : Text(
                AppLocalizations.of(context)!.noPaymentMethod,
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
        trailing: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: widget.onEditPayment,
        ),
      ),
    );
  }

  Widget _buildPaymentMethodIcon(PaymentMethod method) {
    switch (method.type) {
      case 'card':
        return Container(
          width: 40,
          height: 24,
          decoration: BoxDecoration(
            color: _getCardColor(method.cardBrand),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: Text(
              method.cardBrand?.toUpperCase() ?? 'CARD',
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

  Widget _buildNotesField() {
    return TextField(
      controller: _notesController,
      decoration: InputDecoration(
        hintText: AppLocalizations.of(context)!.orderNotesHint,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.all(16),
      ),
      maxLines: 3,
      onChanged: widget.onNotesChanged,
    );
  }

  Widget _buildOrderSummary() {
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        final subtotal = cart.totalAmount;
        const tax = 0.08; // 8% tax
        const shipping = 9.99;
        const discount = 0.0;
        final taxAmount = subtotal * tax;
        final total = subtotal + taxAmount + shipping - discount;

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildSummaryRow(AppLocalizations.of(context)!.subtotalLabel, '\$${subtotal.toStringAsFixed(2)}'),
                const SizedBox(height: 8),
                _buildSummaryRow(AppLocalizations.of(context)!.taxLabel, '\$${taxAmount.toStringAsFixed(2)}'),
                const SizedBox(height: 8),
                _buildSummaryRow(AppLocalizations.of(context)!.shippingLabel, '\$${shipping.toStringAsFixed(2)}'),
                if (discount > 0) ...[
                  const SizedBox(height: 8),
                  _buildSummaryRow(AppLocalizations.of(context)!.discountLabel, '-\$${discount.toStringAsFixed(2)}'),
                ],
                const Divider(),
                _buildSummaryRow(
                  AppLocalizations.of(context)!.totalLabel,
                  '\$${total.toStringAsFixed(2)}',
                  isTotal: true,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSummaryRow(String label, String amount, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 18 : 16,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            fontSize: isTotal ? 18 : 16,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
