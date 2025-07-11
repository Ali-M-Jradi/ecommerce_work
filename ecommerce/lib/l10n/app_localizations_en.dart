// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String orderConfirmationTitle(Object orderId) {
    return 'Order Confirmation #$orderId';
  }

  @override
  String get notificationsTitle => 'Order Updates';

  @override
  String get orderConfirmationNotification =>
      'You will receive a confirmation notification immediately after placing your order.';

  @override
  String get paymentConfirmationNotification =>
      'A payment confirmation notification will be sent when your payment is processed.';

  @override
  String get shippingNotification =>
      'We\'ll notify you when your order is shipped with an estimated delivery date.';

  @override
  String get deliveryNotification =>
      'A notification will be sent when your order is delivered, followed by a request for review.';

  @override
  String navigatingToOrderDetails(Object orderId) {
    return 'Navigating to order #$orderId details';
  }

  @override
  String orderNotFound(Object orderId) {
    return 'Order #$orderId not found';
  }

  @override
  String orderConfirmationBody(Object customerName, Object orderTotal) {
    return 'Thank you, $customerName! Your order for \$$orderTotal has been received.';
  }

  @override
  String get paymentConfirmedTitle => 'Payment Confirmed';

  @override
  String paymentConfirmedBody(Object amount, Object orderId) {
    return 'Your payment of \$$amount for order #$orderId was successful.';
  }

  @override
  String orderShippedTitle(Object orderId) {
    return 'Your Order #$orderId Has Been Shipped';
  }

  @override
  String orderShippedBody(Object date) {
    return 'Your order is on its way! Expected delivery: $date.';
  }

  @override
  String orderArrivesTomorrowTitle(Object orderId) {
    return 'Your Order #$orderId Arrives Tomorrow';
  }

  @override
  String get orderArrivesTomorrowBody =>
      'Your package is scheduled for delivery tomorrow. Make sure someone is available to receive it!';

  @override
  String orderDeliveredTitle(Object orderId) {
    return 'Order #$orderId Delivered';
  }

  @override
  String get orderDeliveredBody =>
      'Your order has been delivered. Enjoy your products!';

  @override
  String get reviewRequestTitle => 'How Was Your Order?';

  @override
  String get reviewRequestBody =>
      'We hope you\'re enjoying your products! Please take a moment to share your thoughts.';

  @override
  String get ecommerceAppTitle => 'E-Commerce App';

  @override
  String get welcomeBack => 'Welcome Back';

  @override
  String get signInToContinue => 'Sign in to continue your beauty journey';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get rememberMe => 'Remember Me';

  @override
  String get loginButton => 'Login';

  @override
  String get noAccount => 'Don\'t have an account?';

  @override
  String get signUp => 'Sign Up';

  @override
  String get loginSuccessful => 'Login successful!';

  @override
  String get orContinueWith => 'or continue with';

  @override
  String get brandName => 'DERMOCOSMETIQUE';

  @override
  String get brandTagline => 'BY PH.MARIAM';

  @override
  String get emailRequired => 'Please enter your email';

  @override
  String get emailInvalid => 'Please enter a valid email';

  @override
  String get passwordRequired => 'Please enter your password';

  @override
  String get passwordTooShort => 'Password must be at least 6 characters';

  @override
  String get createAccount => 'Create Account';

  @override
  String get createYourAccount => 'Create Your Account';

  @override
  String get joinBeautyCommunity => 'Join our beauty community today';

  @override
  String get firstName => 'First Name';

  @override
  String get lastName => 'Last Name';

  @override
  String get emailAddress => 'Email Address';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get fieldRequired => 'Required';

  @override
  String get confirmPasswordRequired => 'Please confirm your password';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get agreeToTerms => 'I agree to the ';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get and => ' and ';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get agreeToTermsRequired => 'Please agree to terms and conditions';

  @override
  String get accountCreatedSuccessfully => 'Account created successfully!';

  @override
  String get haveAccount => 'Already have an account? ';

  @override
  String get signIn => 'Sign In';

  @override
  String get google => 'Google';

  @override
  String get apple => 'Apple';

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
  String get fullNameRequired => 'Full name is required';

  @override
  String get fullNameTooShort => 'Full name must be at least 2 characters';

  @override
  String get fullNameTooLong => 'Full name must be less than 50 characters';

  @override
  String get fullNameInvalidCharacters =>
      'Full name can only contain letters, spaces, hyphens, and apostrophes';

  @override
  String get fullNameMissingLastName => 'Please enter both first and last name';

  @override
  String get streetAddressRequired => 'Street address is required';

  @override
  String get streetAddressTooShort =>
      'Street address must be at least 5 characters';

  @override
  String get streetAddressTooLong =>
      'Street address must be less than 100 characters';

  @override
  String get streetAddressInvalidCharacters =>
      'Street address contains invalid characters';

  @override
  String get cityRequired => 'City is required';

  @override
  String get cityTooShort => 'City name must be at least 2 characters';

  @override
  String get cityTooLong => 'City name must be less than 50 characters';

  @override
  String get cityInvalidCharacters =>
      'City name can only contain letters, spaces, hyphens, and apostrophes';

  @override
  String get stateRequired => 'State/Province is required';

  @override
  String get stateInvalidUS => 'Please select a valid US state';

  @override
  String get stateInvalidCanada => 'Please select a valid Canadian province';

  @override
  String get stateTooShort => 'State/Province must be at least 2 characters';

  @override
  String get stateTooLong => 'State/Province must be less than 50 characters';

  @override
  String get stateInvalidCharacters =>
      'State/Province can only contain letters, spaces, hyphens, and apostrophes';

  @override
  String get zipCodeRequired => 'ZIP/Postal code is required';

  @override
  String get zipCodeInvalidUS =>
      'Please enter a valid US ZIP code (5 or 9 digits)';

  @override
  String get zipCodeInvalidCanada =>
      'Please enter a valid Canadian postal code (e.g., A1A 1A1)';

  @override
  String get zipCodeInvalidUK => 'Please enter a valid UK postal code';

  @override
  String get zipCodeInvalidGermany =>
      'Please enter a valid German postal code (5 digits)';

  @override
  String get zipCodeInvalidFrance =>
      'Please enter a valid French postal code (5 digits)';

  @override
  String get zipCodeInvalidAustralia =>
      'Please enter a valid Australian postal code (4 digits)';

  @override
  String get zipCodeInvalidGeneral => 'Please enter a valid postal code';

  @override
  String get zipCodeInvalidCharacters =>
      'Postal code can only contain letters, numbers, spaces, and hyphens';

  @override
  String get zipCodeTooLong =>
      'ZIP/Postal code must be less than 20 characters';

  @override
  String get countryRequired => 'Country is required';

  @override
  String get countryInvalid => 'Please select a valid country';

  @override
  String get phoneNumberInvalid => 'Please enter a valid phone number';

  @override
  String get countryAF => 'Afghanistan';

  @override
  String get countryAL => 'Albania';

  @override
  String get countryDZ => 'Algeria';

  @override
  String get countryAD => 'Andorra';

  @override
  String get countryAO => 'Angola';

  @override
  String get countryAG => 'Antigua and Barbuda';

  @override
  String get countryAR => 'Argentina';

  @override
  String get countryAM => 'Armenia';

  @override
  String get countryAU => 'Australia';

  @override
  String get countryAT => 'Austria';

  @override
  String get countryAZ => 'Azerbaijan';

  @override
  String get countryBS => 'Bahamas';

  @override
  String get countryBH => 'Bahrain';

  @override
  String get countryBD => 'Bangladesh';

  @override
  String get countryBB => 'Barbados';

  @override
  String get countryBY => 'Belarus';

  @override
  String get countryBE => 'Belgium';

  @override
  String get countryBZ => 'Belize';

  @override
  String get countryBJ => 'Benin';

  @override
  String get countryBT => 'Bhutan';

  @override
  String get countryBO => 'Bolivia';

  @override
  String get countryBA => 'Bosnia and Herzegovina';

  @override
  String get countryBW => 'Botswana';

  @override
  String get countryBR => 'Brazil';

  @override
  String get countryBN => 'Brunei';

  @override
  String get countryBG => 'Bulgaria';

  @override
  String get countryBF => 'Burkina Faso';

  @override
  String get countryBI => 'Burundi';

  @override
  String get countryCV => 'Cabo Verde';

  @override
  String get countryKH => 'Cambodia';

  @override
  String get countryCM => 'Cameroon';

  @override
  String get countryCA => 'Canada';

  @override
  String get countryCF => 'Central African Republic';

  @override
  String get countryTD => 'Chad';

  @override
  String get countryCL => 'Chile';

  @override
  String get countryCN => 'China';

  @override
  String get countryCO => 'Colombia';

  @override
  String get countryKM => 'Comoros';

  @override
  String get countryCG => 'Congo';

  @override
  String get countryCD => 'Congo (Democratic Republic)';

  @override
  String get countryCR => 'Costa Rica';

  @override
  String get countryCI => 'Côte d\'Ivoire';

  @override
  String get countryHR => 'Croatia';

  @override
  String get countryCU => 'Cuba';

  @override
  String get countryCY => 'Cyprus';

  @override
  String get countryCZ => 'Czech Republic';

  @override
  String get countryDK => 'Denmark';

  @override
  String get countryDJ => 'Djibouti';

  @override
  String get countryDM => 'Dominica';

  @override
  String get countryDO => 'Dominican Republic';

  @override
  String get countryEC => 'Ecuador';

  @override
  String get countryEG => 'Egypt';

  @override
  String get countrySV => 'El Salvador';

  @override
  String get countryGQ => 'Equatorial Guinea';

  @override
  String get countryER => 'Eritrea';

  @override
  String get countryEE => 'Estonia';

  @override
  String get countryET => 'Ethiopia';

  @override
  String get countryFJ => 'Fiji';

  @override
  String get countryFI => 'Finland';

  @override
  String get countryFR => 'France';

  @override
  String get countryGA => 'Gabon';

  @override
  String get countryGM => 'Gambia';

  @override
  String get countryGE => 'Georgia';

  @override
  String get countryDE => 'Germany';

  @override
  String get countryGH => 'Ghana';

  @override
  String get countryGR => 'Greece';

  @override
  String get countryGD => 'Grenada';

  @override
  String get countryGT => 'Guatemala';

  @override
  String get countryGN => 'Guinea';

  @override
  String get countryGW => 'Guinea-Bissau';

  @override
  String get countryGY => 'Guyana';

  @override
  String get countryHT => 'Haiti';

  @override
  String get countryHN => 'Honduras';

  @override
  String get countryHU => 'Hungary';

  @override
  String get countryIS => 'Iceland';

  @override
  String get countryIN => 'India';

  @override
  String get countryID => 'Indonesia';

  @override
  String get countryIR => 'Iran';

  @override
  String get countryIQ => 'Iraq';

  @override
  String get countryIE => 'Ireland';

  @override
  String get countryIL => 'Israel';

  @override
  String get countryIT => 'Italy';

  @override
  String get countryJM => 'Jamaica';

  @override
  String get countryJP => 'Japan';

  @override
  String get countryJO => 'Jordan';

  @override
  String get countryKZ => 'Kazakhstan';

  @override
  String get countryKE => 'Kenya';

  @override
  String get countryKI => 'Kiribati';

  @override
  String get countryKW => 'Kuwait';

  @override
  String get countryKG => 'Kyrgyzstan';

  @override
  String get countryLA => 'Laos';

  @override
  String get countryLV => 'Latvia';

  @override
  String get countryLB => 'Lebanon';

  @override
  String get countryLS => 'Lesotho';

  @override
  String get countryLR => 'Liberia';

  @override
  String get countryLY => 'Libya';

  @override
  String get countryLI => 'Liechtenstein';

  @override
  String get countryLT => 'Lithuania';

  @override
  String get countryLU => 'Luxembourg';

  @override
  String get countryMK => 'North Macedonia';

  @override
  String get countryMG => 'Madagascar';

  @override
  String get countryMW => 'Malawi';

  @override
  String get countryMY => 'Malaysia';

  @override
  String get countryMV => 'Maldives';

  @override
  String get countryML => 'Mali';

  @override
  String get countryMT => 'Malta';

  @override
  String get countryMH => 'Marshall Islands';

  @override
  String get countryMR => 'Mauritania';

  @override
  String get countryMU => 'Mauritius';

  @override
  String get countryMX => 'Mexico';

  @override
  String get countryFM => 'Micronesia';

  @override
  String get countryMD => 'Moldova';

  @override
  String get countryMC => 'Monaco';

  @override
  String get countryMN => 'Mongolia';

  @override
  String get countryME => 'Montenegro';

  @override
  String get countryMA => 'Morocco';

  @override
  String get countryMZ => 'Mozambique';

  @override
  String get countryMM => 'Myanmar';

  @override
  String get countryNA => 'Namibia';

  @override
  String get countryNR => 'Nauru';

  @override
  String get countryNP => 'Nepal';

  @override
  String get countryNL => 'Netherlands';

  @override
  String get countryNZ => 'New Zealand';

  @override
  String get countryNI => 'Nicaragua';

  @override
  String get countryNE => 'Niger';

  @override
  String get countryNG => 'Nigeria';

  @override
  String get countryKP => 'North Korea';

  @override
  String get countryNO => 'Norway';

  @override
  String get countryOM => 'Oman';

  @override
  String get countryPK => 'Pakistan';

  @override
  String get countryPW => 'Palau';

  @override
  String get countryPA => 'Panama';

  @override
  String get countryPG => 'Papua New Guinea';

  @override
  String get countryPY => 'Paraguay';

  @override
  String get countryPE => 'Peru';

  @override
  String get countryPH => 'Philippines';

  @override
  String get countryPL => 'Poland';

  @override
  String get countryPT => 'Portugal';

  @override
  String get countryQA => 'Qatar';

  @override
  String get countryRO => 'Romania';

  @override
  String get countryRU => 'Russia';

  @override
  String get countryRW => 'Rwanda';

  @override
  String get countryKN => 'Saint Kitts and Nevis';

  @override
  String get countryLC => 'Saint Lucia';

  @override
  String get countryVC => 'Saint Vincent and the Grenadines';

  @override
  String get countryWS => 'Samoa';

  @override
  String get countrySM => 'San Marino';

  @override
  String get countryST => 'São Tomé and Príncipe';

  @override
  String get countrySA => 'Saudi Arabia';

  @override
  String get countrySN => 'Senegal';

  @override
  String get countryRS => 'Serbia';

  @override
  String get countrySC => 'Seychelles';

  @override
  String get countrySL => 'Sierra Leone';

  @override
  String get countrySG => 'Singapore';

  @override
  String get countrySK => 'Slovakia';

  @override
  String get countrySI => 'Slovenia';

  @override
  String get countrySB => 'Solomon Islands';

  @override
  String get countrySO => 'Somalia';

  @override
  String get countryZA => 'South Africa';

  @override
  String get countryKR => 'South Korea';

  @override
  String get countrySS => 'South Sudan';

  @override
  String get countryES => 'Spain';

  @override
  String get countryLK => 'Sri Lanka';

  @override
  String get countrySD => 'Sudan';

  @override
  String get countrySR => 'Suriname';

  @override
  String get countrySZ => 'Eswatini';

  @override
  String get countrySE => 'Sweden';

  @override
  String get countryCH => 'Switzerland';

  @override
  String get countrySY => 'Syria';

  @override
  String get countryTW => 'Taiwan';

  @override
  String get countryTJ => 'Tajikistan';

  @override
  String get countryTZ => 'Tanzania';

  @override
  String get countryTH => 'Thailand';

  @override
  String get countryTL => 'Timor-Leste';

  @override
  String get countryTG => 'Togo';

  @override
  String get countryTO => 'Tonga';

  @override
  String get countryTT => 'Trinidad and Tobago';

  @override
  String get countryTN => 'Tunisia';

  @override
  String get countryTR => 'Turkey';

  @override
  String get countryTM => 'Turkmenistan';

  @override
  String get countryTV => 'Tuvalu';

  @override
  String get countryUG => 'Uganda';

  @override
  String get countryUA => 'Ukraine';

  @override
  String get countryAE => 'United Arab Emirates';

  @override
  String get countryGB => 'United Kingdom';

  @override
  String get countryUS => 'United States';

  @override
  String get countryUY => 'Uruguay';

  @override
  String get countryUZ => 'Uzbekistan';

  @override
  String get countryVU => 'Vanuatu';

  @override
  String get countryVA => 'Vatican City';

  @override
  String get countryVE => 'Venezuela';

  @override
  String get countryVN => 'Vietnam';

  @override
  String get countryYE => 'Yemen';

  @override
  String get countryZM => 'Zambia';

  @override
  String get countryZW => 'Zimbabwe';

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
  String get orderDetailsDialogTitle => 'Order Details';

  @override
  String get orderEmailUpdatesMessage =>
      'You will receive email updates about your order status and tracking information.';

  @override
  String get cardLabel => 'CARD';

  @override
  String get orderStatusPending => 'Pending';

  @override
  String get orderStatusConfirmed => 'Confirmed';

  @override
  String get orderStatusProcessing => 'Processing';

  @override
  String get orderStatusShipped => 'Shipped';

  @override
  String get orderStatusDelivered => 'Delivered';

  @override
  String get orderStatusCancelled => 'Cancelled';

  @override
  String get orderStatusRefunded => 'Refunded';

  @override
  String get categoryFaceCare => 'Face Care';

  @override
  String get categoryBodyCare => 'Body Care';

  @override
  String get categoryHairCare => 'Hair Care';

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
  String get accessProfile => 'Access Profile';

  @override
  String get loginRegisterPrompt =>
      'Please login or register to access your profile.';

  @override
  String get register => 'Register';

  @override
  String get myProfile => 'My Profile';

  @override
  String get personalInformation => 'Personal Information';

  @override
  String get security => 'Security';

  @override
  String get changePassword => 'Change Password';

  @override
  String get twoFactorAuth => 'Two-Factor Authentication';

  @override
  String get emailNotifications => 'Email Notifications';

  @override
  String get pushNotifications => 'Push Notifications';

  @override
  String get orderUpdates => 'Order Updates';

  @override
  String get recentOrders => 'Recent Orders';

  @override
  String get viewAllOrders => 'View All Orders';

  @override
  String get shippingAddresses => 'Shipping Addresses';

  @override
  String get addNew => 'Add New';

  @override
  String get home => 'Home';

  @override
  String get work => 'Work';

  @override
  String get defaultAddress => 'Default';

  @override
  String get appearance => 'Appearance';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get account => 'Account';

  @override
  String get displayName => 'Display Name';

  @override
  String get phone => 'Phone';

  @override
  String get addToCart => 'Add to Cart';

  @override
  String get viewDetails => 'View Details';

  @override
  String get delivered => 'Delivered';

  @override
  String get processing => 'Processing';

  @override
  String get total => 'Total';

  @override
  String get items => 'items';

  @override
  String get item => 'item';

  @override
  String get notifications => 'Notifications';

  @override
  String get welcome => 'Welcome';

  @override
  String get userEmail => 'guest@example.com';

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

  @override
  String get sizeLabel => 'Size';

  @override
  String get currentRating => 'current';

  @override
  String get rateThisProduct => 'Rate this product:';

  @override
  String get ratingInstructions =>
      'Tap stars to rate (tap twice for half-star)';

  @override
  String get noRatingSelected => 'No rating selected';

  @override
  String yourRating(String rating, String stars) {
    return 'Your rating: $rating $stars';
  }

  @override
  String get star => 'star';

  @override
  String get stars => 'stars';

  @override
  String get submitRating => 'SUBMIT RATING';

  @override
  String ratingSubmitted(String rating) {
    return 'Rating submitted: $rating stars!';
  }

  @override
  String get addToCartButton => 'ADD TO CART';

  @override
  String addedToCart(String productName) {
    return '$productName added to cart!';
  }

  @override
  String get viewCart => 'VIEW CART';

  @override
  String get closeDialog => 'CLOSE';

  @override
  String get notSpecified => 'Not specified';

  @override
  String get shoppingCartTitle => 'Shopping Cart';

  @override
  String get cartEmpty => 'Your cart is empty';

  @override
  String get addProductsToStart => 'Add some products to get started';

  @override
  String get continueShopping => 'Continue Shopping';

  @override
  String itemRemovedFromCart(String itemName) {
    return '$itemName removed from cart';
  }

  @override
  String get undo => 'UNDO';

  @override
  String subtotalItems(int itemCount) {
    return 'Subtotal ($itemCount items)';
  }

  @override
  String get shipping => 'Shipping';

  @override
  String get free => 'Free';

  @override
  String get totalAmount => 'Total';

  @override
  String get proceedToCheckout => 'PROCEED TO CHECKOUT';

  @override
  String get language => 'Language';

  @override
  String get englishLanguage => 'English';

  @override
  String get arabicLanguage => 'Arabic';

  @override
  String get logout => 'Logout';

  @override
  String get loginRegister => 'Login / Register';

  @override
  String get logoutSuccessful => 'You have been successfully logged out';

  @override
  String welcomeUser(String name) {
    return 'Welcome, $name';
  }

  @override
  String get notLoggedIn => 'Not logged in';

  @override
  String get notificationsPageTitle => 'Notifications';

  @override
  String get notificationSettings => 'Notification Settings';

  @override
  String get notificationTypes => 'NOTIFICATION TYPES';

  @override
  String get enableNotifications => 'Enable Notifications';

  @override
  String get receiveAllNotifications =>
      'Receive all notifications from the app';

  @override
  String get orderUpdatesNotification => 'Order Updates';

  @override
  String get notificationsAboutYourOrders =>
      'Notifications about your order status';

  @override
  String get promotions => 'Promotions';

  @override
  String get specialOffersAndDiscounts => 'Special offers and discounts';

  @override
  String get newArrivals => 'New Arrivals';

  @override
  String get newProductAnnouncements => 'New product announcements';

  @override
  String get changeNotificationPermissionsInSettings =>
      'Please change notification settings in your device settings';

  @override
  String get noNotifications => 'No Notifications';

  @override
  String get checkBackLater => 'Check back later for updates';

  @override
  String get notificationRemoved => 'Notification removed';

  @override
  String get all => 'All';

  @override
  String get orders => 'Orders';

  @override
  String get profilePersonalInfo => 'Personal Info';

  @override
  String get profileOrders => 'Orders';

  @override
  String get profileAddresses => 'Addresses';

  @override
  String get profileWishlist => 'Wishlist';

  @override
  String get profileSettings => 'Settings';

  @override
  String get profilePersonalInformation => 'Personal Information';

  @override
  String get profileDisplayName => 'Display Name';

  @override
  String get profilePhone => 'Phone';

  @override
  String get profileSecurity => 'Security';

  @override
  String get profileChangePassword => 'Change Password';

  @override
  String get profileTwoFactorAuth => 'Two-Factor Authentication';

  @override
  String get profileNotifications => 'Notifications';

  @override
  String get profileEmailNotifications => 'Email Notifications';

  @override
  String get profilePushNotifications => 'Push Notifications';

  @override
  String get profileOrderUpdates => 'Order Updates';

  @override
  String get profileRecentOrders => 'Recent Orders';

  @override
  String get profileOrderDelivered => 'Delivered';

  @override
  String get profileOrderProcessing => 'Processing';

  @override
  String get profileViewAllOrders => 'View All Orders';

  @override
  String get profileShippingAddresses => 'Shipping Addresses';

  @override
  String get profileAddNew => 'Add New';

  @override
  String get profileAddressHome => 'Home';

  @override
  String get profileAddressWork => 'Work';

  @override
  String get profileAddressDefault => 'Default';

  @override
  String get profileLanguage => 'Language';

  @override
  String get profileAppearance => 'Appearance';

  @override
  String get profileDarkMode => 'Dark Mode';

  @override
  String get profileAccount => 'Account';

  @override
  String get profileItemSingular => 'item';

  @override
  String get profileItemPlural => 'items';

  @override
  String get profileViewDetails => 'View Details';

  @override
  String get profileProductName => 'Product Name';

  @override
  String get profileAddToCart => 'Add to Cart';

  @override
  String minAgo(int minutes) {
    return '$minutes min ago';
  }

  @override
  String hoursAgo(int hours) {
    return '$hours hours ago';
  }

  @override
  String daysAgo(int days) {
    return '$days days ago';
  }

  @override
  String dateFormat(int day, int month, int year) {
    return '$day/$month/$year';
  }

  @override
  String get testNotifications => 'Test Real Notifications';

  @override
  String get customNotification => 'Custom Notification';

  @override
  String get notificationTitle => 'Title';

  @override
  String get message => 'Message';

  @override
  String get sendNotification => 'Send Notification';

  @override
  String get notificationSent => 'Notification sent!';

  @override
  String get orderNotification => 'Order Notification';

  @override
  String get orderId => 'Order ID';

  @override
  String get status => 'Status';

  @override
  String get sendOrderNotification => 'Send Order Notification';

  @override
  String get orderNotificationSent => 'Order notification sent!';

  @override
  String get quickNotifications => 'Quick Notifications';

  @override
  String get sendPromotion => 'Send Promotion';

  @override
  String get sendNewArrival => 'Send New Arrival';

  @override
  String get promotionNotificationSent => 'Promotion notification sent!';

  @override
  String get newArrivalNotificationSent => 'New arrival notification sent!';

  @override
  String get notApplicable => 'N/A';

  @override
  String get addressNotAvailable => 'Address information not available';

  @override
  String get noNameProvided => 'No name provided';

  @override
  String get noStreetAddressProvided => 'No street address provided';

  @override
  String get noCityStateZipProvided => 'No city/state/zip information provided';

  @override
  String get noCountryProvided => 'No country provided';

  @override
  String get errorDisplayingAddress => 'Error displaying address information';

  @override
  String get cancelOrderButton => 'Cancel Order';

  @override
  String get cancelOrderTitle => 'Cancel Order';

  @override
  String get cancelOrderConfirmMessage =>
      'Are you sure you want to cancel this order? This action cannot be undone.';

  @override
  String get orderCancellationSuccess =>
      'Your order has been successfully cancelled.';

  @override
  String get orderCancellationFailed =>
      'Unable to cancel your order. Please try again or contact customer support.';

  @override
  String get orderCancellationUnavailable =>
      'This order can no longer be cancelled.';

  @override
  String get confirmButton => 'Confirm';

  @override
  String get orderTrackingTitle => 'Order Tracking';

  @override
  String get orderIdMissing => 'Order ID is missing';

  @override
  String get backToOrders => 'Back to Orders';

  @override
  String get trackingNumberCopied => 'Tracking number copied to clipboard';

  @override
  String get unableToTrackPackage => 'Unable to track package';

  @override
  String get orderDetailsTab => 'Details';

  @override
  String get shippingInfoTab => 'Shipping';

  @override
  String get supportTab => 'Support';

  @override
  String get trackingInformation => 'Tracking Information';

  @override
  String get trackingNumberLabel => 'Tracking Number';

  @override
  String get copyTrackingNumber => 'Copy Tracking Number';

  @override
  String get trackPackage => 'Track Package';

  @override
  String get orderItems => 'Order Items';

  @override
  String get paymentSummary => 'Payment Summary';

  @override
  String get deliveryAddressTitle => 'Delivery Address';

  @override
  String get estimatedDeliveryTitle => 'Estimated Delivery';

  @override
  String get carrierInformationTitle => 'Carrier Information';

  @override
  String deliveredOnDate(Object date) {
    return 'Delivered on $date';
  }

  @override
  String get deliveryDelayed => 'Delivery may be delayed';

  @override
  String get deliveringToday => 'Delivering today!';

  @override
  String get deliveringTomorrow => 'Delivering tomorrow';

  @override
  String deliveringInDays(Object days) {
    return 'Delivering in $days days';
  }

  @override
  String get estimatedDate => 'Estimated Date';

  @override
  String get carrierLabel => 'Carrier';

  @override
  String get lastUpdateLabel => 'Last Update';

  @override
  String get packageInTransit => 'Package in transit';

  @override
  String get orderStatus => 'Order Status';

  @override
  String get contactSupportTitle => 'Contact Support';

  @override
  String get orderReferenceLabel => 'Order Reference';

  @override
  String get copyOrderId => 'Copy Order ID';

  @override
  String get orderIdCopied => 'Order ID copied to clipboard';

  @override
  String get supportAvailabilityTitle => 'Support Availability';

  @override
  String get supportAvailabilityHours => 'Monday-Friday: 9am-6pm';

  @override
  String get supportPhoneNumber => '1-800-555-0123';

  @override
  String get supportEmailAddress => 'support@dermocosmetique.com';

  @override
  String get startConversation => 'Start a conversation';

  @override
  String get supportResponseTimeMessage =>
      'Our team typically responds within 24 hours';

  @override
  String get typeMessageHint => 'Type your message...';

  @override
  String get sendMessage => 'Send Message';

  @override
  String get supportResponseCancelRefund =>
      'For cancellation or refund requests, please visit the order details page and select \"Cancel Order\" or \"Request Refund\" option if available. If not available, our team will review your request and get back to you within 24 hours.';

  @override
  String get supportResponseDeliveryDelay =>
      'We apologize for any delay with your delivery. Based on our tracking information, your package is still in transit. Unexpected delays can sometimes occur due to weather or local delivery conditions. Please check back tomorrow for an updated delivery estimate.';

  @override
  String get supportResponseDamagedOrder =>
      'We\'re sorry to hear about issues with your order. Please take photos of the damaged or incorrect items and email them to support@dermocosmetique.com along with your order number. Our customer service team will process a replacement or refund within 1-2 business days.';

  @override
  String supportResponseGeneral(Object orderId) {
    return 'Thank you for contacting customer support regarding Order #$orderId. A support representative will review your message and respond within 24 hours. If you need immediate assistance, please call our customer service line at 1-800-555-0123.';
  }

  @override
  String get trackOrderButton => 'Track Order';

  @override
  String get paymentMethod => 'Payment Method';

  @override
  String get orderNotes => 'Order Notes';
}
