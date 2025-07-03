// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get ecommerceAppTitle => 'E-Commerce App';

  @override
  String get checkoutTitle => 'Checkout';

  @override
  String get addressStep => 'Shipping Address';

  @override
  String get paymentStep => 'Payment Method';

  @override
  String get reviewStep => 'Review Order';

  @override
  String get confirmationStep => 'Order Confirmed';

  @override
  String get backButton => 'Back';

  @override
  String get continueButton => 'Continue';

  @override
  String get placeOrderButton => 'Place Order';

  @override
  String get shippingAddressTitle => 'Shipping Address';

  @override
  String get billingAddressTitle => 'Billing Address';

  @override
  String get noAddressesMessage =>
      'No addresses available. Please add an address to continue.';

  @override
  String get selectShippingMessage =>
      'Please select a shipping address to continue';

  @override
  String get selectBillingMessage =>
      'Please select a billing address to continue';

  @override
  String get useSameAddressLabel => 'Use shipping address for billing';

  @override
  String get addAddressButton => 'Add Address';

  @override
  String get editAddressButton => 'Edit Address';

  @override
  String get fullNameLabel => 'Full Name';

  @override
  String get streetAddressLabel => 'Street Address';

  @override
  String get addressLine2Label => 'Address Line 2 (Optional)';

  @override
  String get cityLabel => 'City';

  @override
  String get stateLabel => 'State';

  @override
  String get stateProvinceLabel => 'State/Province/Region';

  @override
  String get zipCodeLabel => 'ZIP Code';

  @override
  String get countryLabel => 'Country';

  @override
  String get phoneNumberLabel => 'Phone Number (Optional)';

  @override
  String get defaultAddressLabel => 'Set as default address';

  @override
  String get saveButton => 'Save';

  @override
  String get cancelButton => 'Cancel';

  @override
  String get paymentMethodsTitle => 'Payment Methods';

  @override
  String get addNewPaymentMethodButton => 'Add New Payment Method';

  @override
  String get defaultLabel => 'Default';

  @override
  String expiresLabel(String month, String year) {
    return 'Expires $month/$year';
  }

  @override
  String get editAction => 'Edit';

  @override
  String get deleteAction => 'Delete';

  @override
  String get deletePaymentMethodTitle => 'Delete Payment Method';

  @override
  String get deletePaymentMethodMessage =>
      'Are you sure you want to delete this payment method?';

  @override
  String get addPaymentMethodTitle => 'Add Payment Method';

  @override
  String get editPaymentMethodTitle => 'Edit Payment Method';

  @override
  String get paymentTypeLabel => 'Payment Type';

  @override
  String get creditDebitCardOption => 'Credit/Debit Card';

  @override
  String get paypalOption => 'PayPal';

  @override
  String get applePayOption => 'Apple Pay';

  @override
  String get googlePayOption => 'Google Pay';

  @override
  String get cardNumberLabel => 'Card Number';

  @override
  String get cardholderNameLabel => 'Cardholder Name';

  @override
  String get expiryMonthLabel => 'MM';

  @override
  String get expiryYearLabel => 'YYYY';

  @override
  String get cvvLabel => 'CVV';

  @override
  String get cardBrandLabel => 'Card Brand';

  @override
  String get visaOption => 'Visa';

  @override
  String get mastercardOption => 'Mastercard';

  @override
  String get amexOption => 'American Express';

  @override
  String get discoverOption => 'Discover';

  @override
  String get paypalEmailLabel => 'PayPal Email';

  @override
  String get defaultPaymentMethodLabel => 'Set as default payment method';

  @override
  String get requiredField => 'Required';

  @override
  String get invalidMonth => 'Invalid month';

  @override
  String get invalidYear => 'Invalid year';

  @override
  String get invalidCVV => 'Invalid CVV';

  @override
  String get pleaseEnterCardNumber => 'Please enter your card number';

  @override
  String get cardNumberMinLength => 'Card number must be at least 16 digits';

  @override
  String get pleaseEnterCardholderName => 'Please enter the cardholder name';

  @override
  String get pleaseEnterPaypalEmail => 'Please enter your PayPal email';

  @override
  String get pleaseEnterValidEmail => 'Please enter a valid email';

  @override
  String get completeAddressMessage =>
      'Please complete the address information.';

  @override
  String get selectPaymentMethodMessage =>
      'Please select a payment method to continue.';

  @override
  String get completeOrderInformationMessage =>
      'Please complete all required information before placing your order.';

  @override
  String get okButton => 'OK';

  @override
  String get orderItemsTitle => 'Order Items';

  @override
  String get noItemsInCart => 'No items in cart';

  @override
  String quantityLabel(int quantity) {
    return 'Quantity: $quantity';
  }

  @override
  String get sameAsShippingAddress => 'Same as shipping address';

  @override
  String get noShippingAddress => 'No shipping address selected';

  @override
  String get noPaymentMethod => 'No payment method selected';

  @override
  String get orderNotesLabel => 'Order Notes (Optional)';

  @override
  String get orderNotesHint => 'Special instructions for your order...';

  @override
  String get orderSummaryTitle => 'Order Summary';

  @override
  String get subtotalLabel => 'Subtotal';

  @override
  String get taxLabel => 'Tax';

  @override
  String get shippingLabel => 'Shipping';

  @override
  String get discountLabel => 'Discount';

  @override
  String get totalLabel => 'Total';

  @override
  String get orderConfirmedTitle => 'Order Confirmed!';

  @override
  String get orderConfirmedMessage =>
      'Thank you for your order. We\'ll send you a confirmation email shortly.';

  @override
  String get orderDetailsTitle => 'Order Details';

  @override
  String get orderNumberLabel => 'Order Number';

  @override
  String get orderDateLabel => 'Order Date';

  @override
  String get statusLabel => 'Status';

  @override
  String get totalItemsLabel => 'Total Items';

  @override
  String get totalAmountLabel => 'Total Amount';

  @override
  String get estimatedDeliveryLabel => 'Estimated Delivery';

  @override
  String get viewOrderDetailsButton => 'View Order Details';

  @override
  String get continueShoppingButton => 'Continue Shopping';

  @override
  String get orderUpdatesTitle => 'Order Updates';

  @override
  String get orderUpdatesMessage =>
      'We\'ll send you email updates about your order status and tracking information.';

  @override
  String get closeButton => 'Close';

  @override
  String get featuredProducts => 'Featured Products';

  @override
  String get viewAll => 'View All';

  @override
  String get shopByCategory => 'Shop by Category';

  @override
  String get skincare => 'Skincare';

  @override
  String get makeup => 'Makeup';

  @override
  String get hairCare => 'Hair Care';

  @override
  String get fragrance => 'Fragrance';

  @override
  String get whyChooseUs => 'Why Choose Us?';

  @override
  String get authenticProducts => 'Authentic Products';

  @override
  String get authenticProductsDesc =>
      'All products are 100% authentic and sourced directly from brands';

  @override
  String get fastDelivery => 'Fast Delivery';

  @override
  String get fastDeliveryDesc => 'Quick and secure delivery to your doorstep';

  @override
  String get expertSupport => 'Expert Support';

  @override
  String get expertSupportDesc =>
      'Professional skincare consultation and support';

  @override
  String get laRochePosay => 'LA ROCHE-POSAY';

  @override
  String get laboratoireDermatologique => 'Laboratoire Dermatologique';

  @override
  String get tolerianeEffaclar =>
      'Toleriane & Effaclar Collections\nAdvanced skincare solutions';

  @override
  String get shopCollection => 'Shop Collection';

  @override
  String get dermocosmetique => 'DERMOCOSMETIQUE';

  @override
  String get byPhMariam => 'by PH.MARIAM';

  @override
  String get premiumFrenchPharmacy =>
      'Premium French Pharmacy Brands\nAuthentic • Professional • Trusted';

  @override
  String get exploreBrands => 'Explore Brands';

  @override
  String get specialOffers => 'SPECIAL OFFERS';

  @override
  String get limitedTimeOnly => 'Limited Time Only';

  @override
  String get specialOffersDesc =>
      'Up to 30% OFF on selected items\nFree shipping on orders over \$50';

  @override
  String get viewOffers => 'View Offers';

  @override
  String get allProducts => 'All Products';

  @override
  String get comingSoon => 'Coming Soon';

  @override
  String comingSoonMessage(String feature) {
    return '$feature is under development and will be available soon!';
  }

  @override
  String get faceCare => 'Face Care';

  @override
  String get bodyCare => 'Body Care';

  @override
  String get hairCareCategory => 'Hair Care';

  @override
  String get allBrands => 'All Brands';

  @override
  String get loyaltyProgram => 'Loyalty Program';

  @override
  String get specialOffersMenu => 'Special Offers';

  @override
  String get contactUs => 'Contact Us';

  @override
  String get aboutUs => 'About Us';

  @override
  String get accountSettings => 'Account Settings';

  @override
  String get userProfile => 'User Profile';

  @override
  String get appTitle => 'DERMOCOSMETIQUE';

  @override
  String get appSubtitle => 'BY PH.MARIAM';

  @override
  String get searchLabel => 'Search';

  @override
  String get cartLabel => 'Cart';

  @override
  String get productsLabel => 'Products';

  @override
  String get profileLabel => 'Profile';

  @override
  String get notifications => 'Notifications';

  @override
  String get welcome => 'Welcome!';

  @override
  String get userEmail => 'user@example.com';

  @override
  String get shopByCategoryMenu => 'Shop by Category';

  @override
  String get brandExamples => 'La Roche Posay, Vichy, Bioderma...';

  @override
  String get earnPointsRewards => 'Earn points & rewards';

  @override
  String get discountsPromotions => 'Discounts & promotions';

  @override
  String get profilePreferences => 'Profile & preferences';

  @override
  String get searchProducts => 'Search Products';

  @override
  String get aboutUsFooter => 'About Us';

  @override
  String get loyaltyFooter => 'Loyalty';

  @override
  String get supportFooter => 'Support';

  @override
  String get privacyFooter => 'Privacy';

  @override
  String get termsFooter => 'Terms';

  @override
  String get followUs => 'Follow us: ';

  @override
  String get copyrightText => '© 2025 Dermocosmetique by Ph.Mariam';

  @override
  String get allRightsReserved => 'All rights reserved';

  @override
  String get productsPageTitle => 'Products';

  @override
  String get searchProductsHint => 'Search products...';

  @override
  String get sortAtoZ => 'Sort: A to Z';

  @override
  String get sortZtoA => 'Sort: Z to A';

  @override
  String get sortPriceLow => 'Sort: Price Low';

  @override
  String get sortPriceHigh => 'Sort: Price High';

  @override
  String get filtersTooltip => 'Filters';

  @override
  String get filtersTitle => 'Filters';

  @override
  String get clearAll => 'Clear All';

  @override
  String get categoryFilter => 'Category';

  @override
  String get brandFilter => 'Brand';

  @override
  String get allCategories => 'All Categories';

  @override
  String get allBrandsFilter => 'All Brands';

  @override
  String priceRange(int start, int end) {
    return 'Price Range: \$$start - \$$end';
  }

  @override
  String minimumRating(String rating) {
    return 'Minimum Rating: $rating stars';
  }

  @override
  String get showOnlyInStock => 'Show only products in stock';

  @override
  String get applyFilters => 'Apply Filters';

  @override
  String get avene => 'Avène';

  @override
  String get vichy => 'Vichy';

  @override
  String get eucerin => 'Eucerin';

  @override
  String get cerave => 'CeraVe';

  @override
  String get neutrogena => 'Neutrogena';

  @override
  String get soldOut => 'SOLD OUT';

  @override
  String get noProductsFound => 'No Products Found';

  @override
  String noProductsMatchSearch(String searchQuery) {
    return 'No products match your search for \"$searchQuery\"';
  }

  @override
  String get noProductsMatchFilters => 'No products match your current filters';

  @override
  String get noProductsAvailable => 'No products available at the moment';

  @override
  String get tryAdjustingFilters => 'Try adjusting your search or filters';

  @override
  String get clearAllFilters => 'Clear All Filters';

  @override
  String get gridViewTooltip => 'Grid View';

  @override
  String get listViewTooltip => 'List View';
}
