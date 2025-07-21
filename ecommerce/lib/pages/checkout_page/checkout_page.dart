import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../models/address.dart';
import '../../models/payment_method.dart';
import '../../models/order.dart';
import '../../services/address_service.dart';
import '../../services/order_service.dart';
import '../../l10n/app_localizations.dart';
import 'checkout_page_widgets/address_step_widget.dart';
import 'checkout_page_widgets/payment_step_widget.dart';
import 'checkout_page_widgets/review_step_widget.dart';
import 'checkout_page_widgets/confirmation_step_widget.dart';

enum CheckoutStep {
  address,
  payment,
  review,
  confirmation,
}

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({Key? key}) : super(key: key);

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  CheckoutStep currentStep = CheckoutStep.address;
  final PageController _pageController = PageController();
  final AddressService _addressService = AddressService();
  
  Address? selectedShippingAddress;
  Address? selectedBillingAddress;
  PaymentMethod? selectedPaymentMethod;
  Order? completedOrder;
  String? orderNotes;
  bool useSameAddressForBilling = true;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (!_canProceedFromCurrentStep()) {
      _showValidationError();
      return;
    }

    if (currentStep.index < CheckoutStep.values.length - 1) {
      setState(() {
        currentStep = CheckoutStep.values[currentStep.index + 1];
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _showValidationError() {
    String message;
    final localizations = AppLocalizations.of(context)!;
    
    switch (currentStep) {
      case CheckoutStep.address:
        if (!_addressService.hasAddresses) {
          message = localizations.noAddressesMessage;
        } else if (selectedShippingAddress == null) {
          message = localizations.selectShippingMessage;
        } else if (!useSameAddressForBilling && selectedBillingAddress == null) {
          message = localizations.selectBillingMessage;
        }          else {
            message = localizations.completeAddressMessage;
          }
          break;
        case CheckoutStep.payment:
          message = localizations.selectPaymentMethodMessage;
          break;
        case CheckoutStep.review:
          message = localizations.completeOrderInformationMessage;
        break;
      case CheckoutStep.confirmation:
        message = '';
        break;
    }

    if (message.isNotEmpty) {
      final theme = Theme.of(context);
      final colorScheme = theme.colorScheme;
      final isDark = theme.brightness == Brightness.dark;
      final snackBgColor = isDark ? colorScheme.surfaceVariant : colorScheme.surface;
      final snackTextColor = colorScheme.onSurface;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: TextStyle(color: snackTextColor),
          ),
          backgroundColor: snackBgColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 6,
          action: SnackBarAction(
            label: localizations.okButton,
            textColor: colorScheme.primary,
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ),
      );
    }
  }

  void _previousStep() {
    if (currentStep.index > 0) {
      setState(() {
        currentStep = CheckoutStep.values[currentStep.index - 1];
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToStep(CheckoutStep step) {
    setState(() {
      currentStep = step;
    });
    _pageController.animateToPage(
      step.index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  bool _canProceedFromCurrentStep() {
    switch (currentStep) {
      case CheckoutStep.address:
        // Check if there are any addresses available
        if (!_addressService.hasAddresses) {
          return false;
        }
        final hasShippingAddress = selectedShippingAddress != null;
        final hasBillingAddress = useSameAddressForBilling || selectedBillingAddress != null;
        return hasShippingAddress && hasBillingAddress;
      case CheckoutStep.payment:
        return selectedPaymentMethod != null;
      case CheckoutStep.review:
        return selectedShippingAddress != null && 
               selectedPaymentMethod != null &&
               (useSameAddressForBilling || selectedBillingAddress != null);
      case CheckoutStep.confirmation:
        return false;
    }
  }

  void _placeOrder() async {
    if (!_canProceedFromCurrentStep()) {
      _showValidationError();
      return;
    }

    final cart = context.read<CartProvider>();
    if (cart.items.isEmpty || 
        selectedShippingAddress == null || 
        selectedPaymentMethod == null) {
      _showValidationError();
      return;
    }

    // Create the order
    final orderId = DateTime.now().millisecondsSinceEpoch.toString();
    final order = Order.fromCart(
      id: orderId,
      userId: 'user123', // TODO: Replace with actual user ID
      cartItems: cart.items,
      shippingAddress: selectedShippingAddress!,
      billingAddress: useSameAddressForBilling ? selectedShippingAddress : selectedBillingAddress,
      paymentMethod: selectedPaymentMethod!,
      notes: orderNotes,
    );

    // Save the order with the order service
    await OrderService.instance.addOrder(order);

    setState(() {
      completedOrder = order;
    });

    // Clear cart after successful order
    cart.clearCart();
    
    // Move to confirmation step
    setState(() {
      currentStep = CheckoutStep.confirmation;
    });
    _pageController.animateToPage(
      CheckoutStep.confirmation.index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    
    // For demo purposes, simulate order processing flow
    // In a real app, this would happen through admin actions or backend processes
    // We use a slight delay to ensure UI updates complete first
    Future.delayed(const Duration(seconds: 2), () {
      OrderService.instance.simulateOrderFlow(orderId);
    });
  }

  String _getStepTitle() {
    final localizations = AppLocalizations.of(context)!;
    
    switch (currentStep) {
      case CheckoutStep.address:
        return localizations.addressStep;
      case CheckoutStep.payment:
        return localizations.paymentStep;
      case CheckoutStep.review:
        return localizations.reviewStep;
      case CheckoutStep.confirmation:
        return localizations.confirmationStep;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text(_getStepTitle()),
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Step indicator
          Container(
            padding: const EdgeInsets.all(16),
            color: isDark ? colorScheme.surfaceVariant : colorScheme.surface,
            child: Row(
              children: CheckoutStep.values.map((step) {
                final isActive = step == currentStep;
                final isCompleted = step.index < currentStep.index;
                final stepNumber = step.index + 1;

                return Expanded(
                  child: Row(
                    children: [
                      // Step circle
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isCompleted 
                              ? Colors.green
                              : isActive 
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey[300],
                        ),
                        child: Center(
                          child: isCompleted
                              ? const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 18,
                                )
                              : Text(
                                  stepNumber.toString(),
                                  style: TextStyle(
                                    color: isActive ? Colors.white : Colors.grey[600],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                        ),
                      ),
                      // Step line
                      if (step.index < CheckoutStep.values.length - 1)
                        Expanded(
                          child: Container(
                            height: 2,
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            color: isCompleted
                                ? Colors.green
                                : Colors.grey[300],
                          ),
                        ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          // Step content
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(), // Disable swipe navigation
              onPageChanged: (index) {
                setState(() {
                  currentStep = CheckoutStep.values[index];
                });
              },
              children: [
                AddressStepWidget(
                  selectedShippingAddress: selectedShippingAddress,
                  selectedBillingAddress: selectedBillingAddress,
                  useSameAddressForBilling: useSameAddressForBilling,
                  onShippingAddressChanged: (address) {
                    setState(() {
                      selectedShippingAddress = address;
                    });
                  },
                  onBillingAddressChanged: (address) {
                    setState(() {
                      selectedBillingAddress = address;
                    });
                  },
                  onUseSameAddressChanged: (value) {
                    setState(() {
                      useSameAddressForBilling = value;
                    });
                  },
                ),
                PaymentStepWidget(
                  selectedPaymentMethod: selectedPaymentMethod,
                  onPaymentMethodChanged: (method) {
                    setState(() {
                      selectedPaymentMethod = method;
                    });
                  },
                ),
                ReviewStepWidget(
                  shippingAddress: selectedShippingAddress,
                  billingAddress: useSameAddressForBilling ? selectedShippingAddress : selectedBillingAddress,
                  paymentMethod: selectedPaymentMethod,
                  notes: orderNotes,
                  onNotesChanged: (notes) {
                    setState(() {
                      orderNotes = notes;
                    });
                  },
                  onEditAddress: () => _goToStep(CheckoutStep.address),
                  onEditPayment: () => _goToStep(CheckoutStep.payment),
                ),
                ConfirmationStepWidget(
                  order: completedOrder,
                ),
              ],
            ),
          ),
          // Navigation buttons
          if (currentStep != CheckoutStep.confirmation)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Back button
                  if (currentStep != CheckoutStep.address)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _previousStep,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(AppLocalizations.of(context)!.backButton),
                      ),
                    ),
                  if (currentStep != CheckoutStep.address)
                    const SizedBox(width: 16),
                  // Next/Place Order button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: currentStep == CheckoutStep.review ? _placeOrder : _nextStep,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: _canProceedFromCurrentStep()
                            ? colorScheme.primary
                            : colorScheme.surfaceVariant,
                        foregroundColor: colorScheme.onPrimary,
                        textStyle: const TextStyle(fontWeight: FontWeight.bold),
                        elevation: 2,
                      ),
                      child: Text(
                        currentStep == CheckoutStep.review 
                            ? AppLocalizations.of(context)!.placeOrderButton 
                            : AppLocalizations.of(context)!.continueButton,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
