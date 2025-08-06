import 'package:flutter/material.dart';
import '../../../models/payment_method.dart';
import '../../../l10n/app_localizations.dart';

class PaymentStepWidget extends StatefulWidget {
  final PaymentMethod? selectedPaymentMethod;
  final Function(PaymentMethod) onPaymentMethodChanged;

  const PaymentStepWidget({
    super.key,
    this.selectedPaymentMethod,
    required this.onPaymentMethodChanged,
  });

  @override
  State<PaymentStepWidget> createState() => _PaymentStepWidgetState();
}

class _PaymentStepWidgetState extends State<PaymentStepWidget> {
  final List<PaymentMethod> _savedPaymentMethods = [
    PaymentMethod.card(
      id: '1',
      cardNumber: '1234567890123456',
      cardBrand: 'visa',
      expiryMonth: '12',
      expiryYear: '2025',
      cardholderName: 'John Doe',
      isDefault: true,
    ),
    PaymentMethod.paypal(
      id: '2',
      email: 'john.doe@example.com',
    ),
    PaymentMethod.applePay(
      id: '3',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(AppLocalizations.of(context)!.paymentMethodsTitle),
          const SizedBox(height: 16),
          _buildPaymentMethodsList(colorScheme, isDark),
          const SizedBox(height: 32),
          // Add New Payment Method Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                _showAddPaymentMethodDialog();
              },
              icon: Icon(Icons.add, color: colorScheme.primary),
              label: Text(
                AppLocalizations.of(context)!.addNewPaymentMethodButton,
                style: TextStyle(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: BorderSide(color: colorScheme.primary, width: 2),
                foregroundColor: colorScheme.primary,
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildPaymentMethodsList(ColorScheme colorScheme, bool isDark) {
    return Column(
      children: _savedPaymentMethods.map((method) {
        final isSelected = widget.selectedPaymentMethod?.id == method.id;
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected
                  ? colorScheme.primary
                  : colorScheme.outlineVariant,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(12),
            color: isSelected
                ? colorScheme.primary.withOpacity(isDark ? 0.10 : 0.05)
                : (isDark ? colorScheme.surfaceContainerHighest : colorScheme.surface),
          ),
          child: InkWell(
            onTap: () {
              widget.onPaymentMethodChanged(method);
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Radio button
                  Radio<PaymentMethod>(
                    value: method,
                    groupValue: widget.selectedPaymentMethod,
                    onChanged: (PaymentMethod? value) {
                      if (value != null) {
                        widget.onPaymentMethodChanged(value);
                      }
                    },
                    activeColor: colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  // Payment method icon
                  _buildPaymentMethodIcon(method),
                  const SizedBox(width: 12),
                  // Payment method details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                method.formattedDisplay,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: colorScheme.onSurface,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (method.isDefault) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: colorScheme.secondary,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  AppLocalizations.of(context)!.defaultLabel,
                                  style: TextStyle(
                                    color: colorScheme.onSecondary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        if (method.type == 'card' && method.expiryMonth != null && method.expiryYear != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            AppLocalizations.of(context)!.expiresLabel(method.expiryMonth!, method.expiryYear!),
                            style: TextStyle(
                              color: colorScheme.outlineVariant,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  // More options menu
                  PopupMenuButton<String>(
                    icon: Icon(Icons.more_vert, color: colorScheme.onSurface),
                    onSelected: (String action) {
                      switch (action) {
                        case 'edit':
                          _showEditPaymentMethodDialog(method);
                          break;
                        case 'delete':
                          _showDeletePaymentMethodDialog(method);
                          break;
                      }
                    },
                    itemBuilder: (BuildContext context) => [
                      PopupMenuItem(
                        value: 'edit',
                        child: ListTile(
                          leading: Icon(Icons.edit, color: colorScheme.primary),
                          title: Text(AppLocalizations.of(context)!.editAction),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: ListTile(
                          leading: Icon(Icons.delete, color: colorScheme.error),
                          title: Text(AppLocalizations.of(context)!.deleteAction),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPaymentMethodIcon(PaymentMethod method) {
    switch (method.type) {
      case 'card':
        // Show only the card brand name for all cards
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

  void _showAddPaymentMethodDialog() {
    showDialog(
      context: context,
      builder: (context) => PaymentMethodFormDialog(
        onPaymentMethodAdded: (method) {
          setState(() {
            _savedPaymentMethods.add(method);
          });
        },
      ),
    );
  }

  void _showEditPaymentMethodDialog(PaymentMethod method) {
    showDialog(
      context: context,
      builder: (context) => PaymentMethodFormDialog(
        paymentMethod: method,
        onPaymentMethodAdded: (updatedMethod) {
          setState(() {
            final index = _savedPaymentMethods.indexWhere((m) => m.id == method.id);
            if (index != -1) {
              _savedPaymentMethods[index] = updatedMethod;
            }
          });
        },
      ),
    );
  }

  void _showDeletePaymentMethodDialog(PaymentMethod method) {
    final localizations = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations.deletePaymentMethodTitle),
        content: Text(localizations.deletePaymentMethodMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localizations.cancelButton),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _savedPaymentMethods.removeWhere((m) => m.id == method.id);
              });
              Navigator.pop(context);
            },
            child: Text(localizations.deleteAction),
          ),
        ],
      ),
    );
  }
}

class PaymentMethodFormDialog extends StatefulWidget {
  final PaymentMethod? paymentMethod;
  final Function(PaymentMethod) onPaymentMethodAdded;

  const PaymentMethodFormDialog({
    super.key,
    this.paymentMethod,
    required this.onPaymentMethodAdded,
  });

  @override
  State<PaymentMethodFormDialog> createState() => _PaymentMethodFormDialogState();
}

class _PaymentMethodFormDialogState extends State<PaymentMethodFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _cardholderNameController = TextEditingController();
  final _expiryMonthController = TextEditingController();
  final _expiryYearController = TextEditingController();
  final _cvvController = TextEditingController();
  final _emailController = TextEditingController();
  
  String _selectedPaymentType = 'card';
  String _selectedCardBrand = 'visa';
  bool _isDefault = false;

  @override
  void initState() {
    super.initState();
    if (widget.paymentMethod != null) {
      _selectedPaymentType = widget.paymentMethod!.type;
      _isDefault = widget.paymentMethod!.isDefault;
      
      if (widget.paymentMethod!.type == 'card') {
        _cardNumberController.text = widget.paymentMethod!.cardNumber ?? '';
        _cardholderNameController.text = widget.paymentMethod!.cardholderName ?? '';
        _expiryMonthController.text = widget.paymentMethod!.expiryMonth ?? '';
        _expiryYearController.text = widget.paymentMethod!.expiryYear ?? '';
        _selectedCardBrand = widget.paymentMethod!.cardBrand ?? 'visa';
      } else if (widget.paymentMethod!.type == 'paypal') {
        _emailController.text = widget.paymentMethod!.email ?? '';
      }
    }
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardholderNameController.dispose();
    _expiryMonthController.dispose();
    _expiryYearController.dispose();
    _cvvController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(widget.paymentMethod == null ? localizations.addPaymentMethodTitle : localizations.editPaymentMethodTitle),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Payment Type Selection
              DropdownButtonFormField<String>(
                value: _selectedPaymentType,
                decoration: InputDecoration(
                  labelText: localizations.paymentTypeLabel,
                  border: const OutlineInputBorder(),
                ),
                items: [
                  DropdownMenuItem(value: 'card', child: Text(localizations.creditDebitCardOption)),
                  DropdownMenuItem(value: 'paypal', child: Text(localizations.paypalOption)),
                  DropdownMenuItem(value: 'apple_pay', child: Text(localizations.applePayOption)),
                  DropdownMenuItem(value: 'google_pay', child: Text(localizations.googlePayOption)),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedPaymentType = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              
              // Card-specific fields
              if (_selectedPaymentType == 'card') ...[
                TextFormField(
                  controller: _cardNumberController,
                  decoration: InputDecoration(
                    labelText: localizations.cardNumberLabel,
                    border: const OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return localizations.pleaseEnterCardNumber;
                    }
                    if (value.length < 16) {
                      return localizations.cardNumberMinLength;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _cardholderNameController,
                  decoration: InputDecoration(
                    labelText: localizations.cardholderNameLabel,
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return localizations.pleaseEnterCardholderName;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _expiryMonthController,
                        decoration: InputDecoration(
                          labelText: localizations.expiryMonthLabel,
                          border: const OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return localizations.requiredField;
                          }
                          final month = int.tryParse(value);
                          if (month == null || month < 1 || month > 12) {
                            return localizations.invalidMonth;
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _expiryYearController,
                        decoration: InputDecoration(
                          labelText: localizations.expiryYearLabel,
                          border: const OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return localizations.requiredField;
                          }
                          final year = int.tryParse(value);
                          if (year == null || year < DateTime.now().year) {
                            return localizations.invalidYear;
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _cvvController,
                        decoration: InputDecoration(
                          labelText: localizations.cvvLabel,
                          border: const OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return localizations.requiredField;
                          }
                          if (value.length < 3) {
                            return localizations.invalidCVV;
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedCardBrand,
                  decoration: InputDecoration(
                    labelText: localizations.cardBrandLabel,
                    border: const OutlineInputBorder(),
                  ),
                  items: [
                    DropdownMenuItem(value: 'visa', child: Text(localizations.visaOption)),
                    DropdownMenuItem(value: 'mastercard', child: Text(localizations.mastercardOption)),
                    DropdownMenuItem(value: 'amex', child: Text(localizations.amexOption)),
                    DropdownMenuItem(value: 'discover', child: Text(localizations.discoverOption)),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedCardBrand = value!;
                    });
                  },
                ),
              ],
              
              // PayPal-specific fields
              if (_selectedPaymentType == 'paypal') ...[
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: localizations.paypalEmailLabel,
                    border: const OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return localizations.pleaseEnterPaypalEmail;
                    }
                    if (!value.contains('@')) {
                      return localizations.pleaseEnterValidEmail;
                    }
                    return null;
                  },
                ),
              ],
              
              const SizedBox(height: 16),
              CheckboxListTile(
                title: Text(localizations.defaultPaymentMethodLabel),
                value: _isDefault,
                onChanged: (value) {
                  setState(() {
                    _isDefault = value ?? false;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(localizations.cancelButton),
        ),
        ElevatedButton(
          onPressed: _savePaymentMethod,
          child: Text(localizations.saveButton),
        ),
      ],
    );
  }

  void _savePaymentMethod() {
    if (_formKey.currentState!.validate()) {
      PaymentMethod paymentMethod;
      
      switch (_selectedPaymentType) {
        case 'card':
          paymentMethod = PaymentMethod.card(
            id: widget.paymentMethod?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
            cardNumber: _cardNumberController.text,
            cardBrand: _selectedCardBrand,
            expiryMonth: _expiryMonthController.text,
            expiryYear: _expiryYearController.text,
            cardholderName: _cardholderNameController.text,
            isDefault: _isDefault,
          );
          break;
        case 'paypal':
          paymentMethod = PaymentMethod.paypal(
            id: widget.paymentMethod?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
            email: _emailController.text,
            isDefault: _isDefault,
          );
          break;
        case 'apple_pay':
          paymentMethod = PaymentMethod.applePay(
            id: widget.paymentMethod?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
            isDefault: _isDefault,
          );
          break;
        case 'google_pay':
          paymentMethod = PaymentMethod.googlePay(
            id: widget.paymentMethod?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
            isDefault: _isDefault,
          );
          break;
        default:
          return;
      }

      widget.onPaymentMethodAdded(paymentMethod);
      Navigator.pop(context);
    }
  }
}
