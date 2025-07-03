import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'E-Commerce App'**
  String get ecommerceAppTitle;

  /// The title of the checkout page
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get checkoutTitle;

  /// The address step title in checkout
  ///
  /// In en, this message translates to:
  /// **'Shipping Address'**
  String get addressStep;

  /// The payment step title in checkout
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get paymentStep;

  /// The review step title in checkout
  ///
  /// In en, this message translates to:
  /// **'Review Order'**
  String get reviewStep;

  /// The confirmation step title in checkout
  ///
  /// In en, this message translates to:
  /// **'Order Confirmed'**
  String get confirmationStep;

  /// Back button label
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get backButton;

  /// Continue button label
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// Place order button label
  ///
  /// In en, this message translates to:
  /// **'Place Order'**
  String get placeOrderButton;

  /// Shipping address section title
  ///
  /// In en, this message translates to:
  /// **'Shipping Address'**
  String get shippingAddressTitle;

  /// Billing address section title
  ///
  /// In en, this message translates to:
  /// **'Billing Address'**
  String get billingAddressTitle;

  /// Message shown when no addresses are available
  ///
  /// In en, this message translates to:
  /// **'No addresses available. Please add an address to continue.'**
  String get noAddressesMessage;

  /// Message shown when shipping address is not selected
  ///
  /// In en, this message translates to:
  /// **'Please select a shipping address to continue'**
  String get selectShippingMessage;

  /// Message shown when billing address is not selected
  ///
  /// In en, this message translates to:
  /// **'Please select a billing address to continue'**
  String get selectBillingMessage;

  /// Label for using same address for billing checkbox
  ///
  /// In en, this message translates to:
  /// **'Use shipping address for billing'**
  String get useSameAddressLabel;

  /// Add address button label
  ///
  /// In en, this message translates to:
  /// **'Add Address'**
  String get addAddressButton;

  /// Edit address button label
  ///
  /// In en, this message translates to:
  /// **'Edit Address'**
  String get editAddressButton;

  /// Full name field label
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullNameLabel;

  /// Street address field label
  ///
  /// In en, this message translates to:
  /// **'Street Address'**
  String get streetAddressLabel;

  /// Address line 2 field label
  ///
  /// In en, this message translates to:
  /// **'Address Line 2 (Optional)'**
  String get addressLine2Label;

  /// City field label
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get cityLabel;

  /// State field label
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get stateLabel;

  /// State/Province/Region field label
  ///
  /// In en, this message translates to:
  /// **'State/Province/Region'**
  String get stateProvinceLabel;

  /// ZIP code field label
  ///
  /// In en, this message translates to:
  /// **'ZIP Code'**
  String get zipCodeLabel;

  /// Country field label
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get countryLabel;

  /// Phone number field label
  ///
  /// In en, this message translates to:
  /// **'Phone Number (Optional)'**
  String get phoneNumberLabel;

  /// Default address checkbox label
  ///
  /// In en, this message translates to:
  /// **'Set as default address'**
  String get defaultAddressLabel;

  /// Save button label
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveButton;

  /// Cancel button label
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelButton;

  /// Payment methods section title
  ///
  /// In en, this message translates to:
  /// **'Payment Methods'**
  String get paymentMethodsTitle;

  /// Add new payment method button label
  ///
  /// In en, this message translates to:
  /// **'Add New Payment Method'**
  String get addNewPaymentMethodButton;

  /// Default payment method label
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get defaultLabel;

  /// Card expiration date format
  ///
  /// In en, this message translates to:
  /// **'Expires {month}/{year}'**
  String expiresLabel(String month, String year);

  /// Edit action label
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editAction;

  /// Delete action label
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteAction;

  /// Delete payment method dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete Payment Method'**
  String get deletePaymentMethodTitle;

  /// Delete payment method confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this payment method?'**
  String get deletePaymentMethodMessage;

  /// Add payment method dialog title
  ///
  /// In en, this message translates to:
  /// **'Add Payment Method'**
  String get addPaymentMethodTitle;

  /// Edit payment method dialog title
  ///
  /// In en, this message translates to:
  /// **'Edit Payment Method'**
  String get editPaymentMethodTitle;

  /// Payment type field label
  ///
  /// In en, this message translates to:
  /// **'Payment Type'**
  String get paymentTypeLabel;

  /// Credit/Debit card option
  ///
  /// In en, this message translates to:
  /// **'Credit/Debit Card'**
  String get creditDebitCardOption;

  /// PayPal option
  ///
  /// In en, this message translates to:
  /// **'PayPal'**
  String get paypalOption;

  /// Apple Pay option
  ///
  /// In en, this message translates to:
  /// **'Apple Pay'**
  String get applePayOption;

  /// Google Pay option
  ///
  /// In en, this message translates to:
  /// **'Google Pay'**
  String get googlePayOption;

  /// Card number field label
  ///
  /// In en, this message translates to:
  /// **'Card Number'**
  String get cardNumberLabel;

  /// Cardholder name field label
  ///
  /// In en, this message translates to:
  /// **'Cardholder Name'**
  String get cardholderNameLabel;

  /// Expiry month field label
  ///
  /// In en, this message translates to:
  /// **'MM'**
  String get expiryMonthLabel;

  /// Expiry year field label
  ///
  /// In en, this message translates to:
  /// **'YYYY'**
  String get expiryYearLabel;

  /// CVV field label
  ///
  /// In en, this message translates to:
  /// **'CVV'**
  String get cvvLabel;

  /// Card brand field label
  ///
  /// In en, this message translates to:
  /// **'Card Brand'**
  String get cardBrandLabel;

  /// Visa option
  ///
  /// In en, this message translates to:
  /// **'Visa'**
  String get visaOption;

  /// Mastercard option
  ///
  /// In en, this message translates to:
  /// **'Mastercard'**
  String get mastercardOption;

  /// American Express option
  ///
  /// In en, this message translates to:
  /// **'American Express'**
  String get amexOption;

  /// Discover option
  ///
  /// In en, this message translates to:
  /// **'Discover'**
  String get discoverOption;

  /// PayPal email field label
  ///
  /// In en, this message translates to:
  /// **'PayPal Email'**
  String get paypalEmailLabel;

  /// Default payment method checkbox label
  ///
  /// In en, this message translates to:
  /// **'Set as default payment method'**
  String get defaultPaymentMethodLabel;

  /// Required field error message
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get requiredField;

  /// Invalid month error message
  ///
  /// In en, this message translates to:
  /// **'Invalid month'**
  String get invalidMonth;

  /// Invalid year error message
  ///
  /// In en, this message translates to:
  /// **'Invalid year'**
  String get invalidYear;

  /// Invalid CVV error message
  ///
  /// In en, this message translates to:
  /// **'Invalid CVV'**
  String get invalidCVV;

  /// Card number required error message
  ///
  /// In en, this message translates to:
  /// **'Please enter your card number'**
  String get pleaseEnterCardNumber;

  /// Card number min length error message
  ///
  /// In en, this message translates to:
  /// **'Card number must be at least 16 digits'**
  String get cardNumberMinLength;

  /// Cardholder name required error message
  ///
  /// In en, this message translates to:
  /// **'Please enter the cardholder name'**
  String get pleaseEnterCardholderName;

  /// PayPal email required error message
  ///
  /// In en, this message translates to:
  /// **'Please enter your PayPal email'**
  String get pleaseEnterPaypalEmail;

  /// Invalid email error message
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get pleaseEnterValidEmail;

  /// Message shown when address information is incomplete
  ///
  /// In en, this message translates to:
  /// **'Please complete the address information.'**
  String get completeAddressMessage;

  /// Message shown when payment method is not selected
  ///
  /// In en, this message translates to:
  /// **'Please select a payment method to continue.'**
  String get selectPaymentMethodMessage;

  /// Message shown when order information is incomplete
  ///
  /// In en, this message translates to:
  /// **'Please complete all required information before placing your order.'**
  String get completeOrderInformationMessage;

  /// OK button label
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get okButton;

  /// Order items section title
  ///
  /// In en, this message translates to:
  /// **'Order Items'**
  String get orderItemsTitle;

  /// Message when cart is empty
  ///
  /// In en, this message translates to:
  /// **'No items in cart'**
  String get noItemsInCart;

  /// Quantity label with placeholder
  ///
  /// In en, this message translates to:
  /// **'Quantity: {quantity}'**
  String quantityLabel(int quantity);

  /// Text when billing address is same as shipping
  ///
  /// In en, this message translates to:
  /// **'Same as shipping address'**
  String get sameAsShippingAddress;

  /// Text when no shipping address is selected
  ///
  /// In en, this message translates to:
  /// **'No shipping address selected'**
  String get noShippingAddress;

  /// Text when no payment method is selected
  ///
  /// In en, this message translates to:
  /// **'No payment method selected'**
  String get noPaymentMethod;

  /// Order notes field label
  ///
  /// In en, this message translates to:
  /// **'Order Notes (Optional)'**
  String get orderNotesLabel;

  /// Order notes field hint
  ///
  /// In en, this message translates to:
  /// **'Special instructions for your order...'**
  String get orderNotesHint;

  /// Order summary section title
  ///
  /// In en, this message translates to:
  /// **'Order Summary'**
  String get orderSummaryTitle;

  /// Subtotal label in order summary
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get subtotalLabel;

  /// Tax label in order summary
  ///
  /// In en, this message translates to:
  /// **'Tax'**
  String get taxLabel;

  /// Shipping label in order summary
  ///
  /// In en, this message translates to:
  /// **'Shipping'**
  String get shippingLabel;

  /// Discount label in order summary
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get discountLabel;

  /// Total label in order summary
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get totalLabel;

  /// Order confirmed title
  ///
  /// In en, this message translates to:
  /// **'Order Confirmed!'**
  String get orderConfirmedTitle;

  /// Order confirmed message
  ///
  /// In en, this message translates to:
  /// **'Thank you for your order. We\'ll send you a confirmation email shortly.'**
  String get orderConfirmedMessage;

  /// Order details section title
  ///
  /// In en, this message translates to:
  /// **'Order Details'**
  String get orderDetailsTitle;

  /// Order number label
  ///
  /// In en, this message translates to:
  /// **'Order Number'**
  String get orderNumberLabel;

  /// Order date label
  ///
  /// In en, this message translates to:
  /// **'Order Date'**
  String get orderDateLabel;

  /// Status label
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get statusLabel;

  /// Total items label
  ///
  /// In en, this message translates to:
  /// **'Total Items'**
  String get totalItemsLabel;

  /// Total amount label
  ///
  /// In en, this message translates to:
  /// **'Total Amount'**
  String get totalAmountLabel;

  /// Estimated delivery label
  ///
  /// In en, this message translates to:
  /// **'Estimated Delivery'**
  String get estimatedDeliveryLabel;

  /// View order details button label
  ///
  /// In en, this message translates to:
  /// **'View Order Details'**
  String get viewOrderDetailsButton;

  /// Continue shopping button label
  ///
  /// In en, this message translates to:
  /// **'Continue Shopping'**
  String get continueShoppingButton;

  /// Order updates section title
  ///
  /// In en, this message translates to:
  /// **'Order Updates'**
  String get orderUpdatesTitle;

  /// Order updates message
  ///
  /// In en, this message translates to:
  /// **'We\'ll send you email updates about your order status and tracking information.'**
  String get orderUpdatesMessage;

  /// Close button label
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get closeButton;

  /// Title for featured products section
  ///
  /// In en, this message translates to:
  /// **'Featured Products'**
  String get featuredProducts;

  /// Link to view all products
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// Title for shop by category section
  ///
  /// In en, this message translates to:
  /// **'Shop by Category'**
  String get shopByCategory;

  /// Skincare category name
  ///
  /// In en, this message translates to:
  /// **'Skincare'**
  String get skincare;

  /// Makeup category name
  ///
  /// In en, this message translates to:
  /// **'Makeup'**
  String get makeup;

  /// Hair care category name
  ///
  /// In en, this message translates to:
  /// **'Hair Care'**
  String get hairCare;

  /// Fragrance category name
  ///
  /// In en, this message translates to:
  /// **'Fragrance'**
  String get fragrance;

  /// Title for why choose us section
  ///
  /// In en, this message translates to:
  /// **'Why Choose Us?'**
  String get whyChooseUs;

  /// Feature item for authentic products
  ///
  /// In en, this message translates to:
  /// **'Authentic Products'**
  String get authenticProducts;

  /// Description for authentic products
  ///
  /// In en, this message translates to:
  /// **'All products are 100% authentic and sourced directly from brands'**
  String get authenticProductsDesc;

  /// Feature item for fast delivery
  ///
  /// In en, this message translates to:
  /// **'Fast Delivery'**
  String get fastDelivery;

  /// Description for fast delivery
  ///
  /// In en, this message translates to:
  /// **'Quick and secure delivery to your doorstep'**
  String get fastDeliveryDesc;

  /// Feature item for expert support
  ///
  /// In en, this message translates to:
  /// **'Expert Support'**
  String get expertSupport;

  /// Description for expert support
  ///
  /// In en, this message translates to:
  /// **'Professional skincare consultation and support'**
  String get expertSupportDesc;

  /// LA ROCHE-POSAY brand name
  ///
  /// In en, this message translates to:
  /// **'LA ROCHE-POSAY'**
  String get laRochePosay;

  /// Subtitle for LA ROCHE-POSAY
  ///
  /// In en, this message translates to:
  /// **'Laboratoire Dermatologique'**
  String get laboratoireDermatologique;

  /// Description for LA ROCHE-POSAY banner
  ///
  /// In en, this message translates to:
  /// **'Toleriane & Effaclar Collections\nAdvanced skincare solutions'**
  String get tolerianeEffaclar;

  /// Button text for shop collection
  ///
  /// In en, this message translates to:
  /// **'Shop Collection'**
  String get shopCollection;

  /// DERMOCOSMETIQUE brand name
  ///
  /// In en, this message translates to:
  /// **'DERMOCOSMETIQUE'**
  String get dermocosmetique;

  /// Subtitle for DERMOCOSMETIQUE
  ///
  /// In en, this message translates to:
  /// **'by PH.MARIAM'**
  String get byPhMariam;

  /// Description for DERMOCOSMETIQUE banner
  ///
  /// In en, this message translates to:
  /// **'Premium French Pharmacy Brands\nAuthentic • Professional • Trusted'**
  String get premiumFrenchPharmacy;

  /// Button text for explore brands
  ///
  /// In en, this message translates to:
  /// **'Explore Brands'**
  String get exploreBrands;

  /// Special offers title
  ///
  /// In en, this message translates to:
  /// **'SPECIAL OFFERS'**
  String get specialOffers;

  /// Subtitle for special offers
  ///
  /// In en, this message translates to:
  /// **'Limited Time Only'**
  String get limitedTimeOnly;

  /// Description for special offers banner
  ///
  /// In en, this message translates to:
  /// **'Up to 30% OFF on selected items\nFree shipping on orders over \$50'**
  String get specialOffersDesc;

  /// Button text for view offers
  ///
  /// In en, this message translates to:
  /// **'View Offers'**
  String get viewOffers;

  /// Title for all products page
  ///
  /// In en, this message translates to:
  /// **'All Products'**
  String get allProducts;

  /// Title for coming soon dialog
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get comingSoon;

  /// Message for coming soon dialog
  ///
  /// In en, this message translates to:
  /// **'{feature} is under development and will be available soon!'**
  String comingSoonMessage(String feature);

  /// Face care category name
  ///
  /// In en, this message translates to:
  /// **'Face Care'**
  String get faceCare;

  /// Body care category name
  ///
  /// In en, this message translates to:
  /// **'Body Care'**
  String get bodyCare;

  /// Hair care category name
  ///
  /// In en, this message translates to:
  /// **'Hair Care'**
  String get hairCareCategory;

  /// All brands category title
  ///
  /// In en, this message translates to:
  /// **'All Brands'**
  String get allBrands;

  /// Loyalty program menu item
  ///
  /// In en, this message translates to:
  /// **'Loyalty Program'**
  String get loyaltyProgram;

  /// Special offers menu item
  ///
  /// In en, this message translates to:
  /// **'Special Offers'**
  String get specialOffersMenu;

  /// Contact us menu item
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contactUs;

  /// About us menu item
  ///
  /// In en, this message translates to:
  /// **'About Us'**
  String get aboutUs;

  /// Account settings menu item
  ///
  /// In en, this message translates to:
  /// **'Account Settings'**
  String get accountSettings;

  /// User profile menu item
  ///
  /// In en, this message translates to:
  /// **'User Profile'**
  String get userProfile;

  /// App title
  ///
  /// In en, this message translates to:
  /// **'DERMOCOSMETIQUE'**
  String get appTitle;

  /// App subtitle
  ///
  /// In en, this message translates to:
  /// **'BY PH.MARIAM'**
  String get appSubtitle;

  /// Search navigation label
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchLabel;

  /// Cart navigation label
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get cartLabel;

  /// Products navigation label
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get productsLabel;

  /// Profile navigation label
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileLabel;

  /// Notifications feature name
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// Welcome text in drawer header
  ///
  /// In en, this message translates to:
  /// **'Welcome!'**
  String get welcome;

  /// User email in drawer header
  ///
  /// In en, this message translates to:
  /// **'user@example.com'**
  String get userEmail;

  /// Shop by category menu item
  ///
  /// In en, this message translates to:
  /// **'Shop by Category'**
  String get shopByCategoryMenu;

  /// Brand examples
  ///
  /// In en, this message translates to:
  /// **'La Roche Posay, Vichy, Bioderma...'**
  String get brandExamples;

  /// Loyalty program subtitle
  ///
  /// In en, this message translates to:
  /// **'Earn points & rewards'**
  String get earnPointsRewards;

  /// Special offers subtitle
  ///
  /// In en, this message translates to:
  /// **'Discounts & promotions'**
  String get discountsPromotions;

  /// Account settings subtitle
  ///
  /// In en, this message translates to:
  /// **'Profile & preferences'**
  String get profilePreferences;

  /// Search products title
  ///
  /// In en, this message translates to:
  /// **'Search Products'**
  String get searchProducts;

  /// About us footer link
  ///
  /// In en, this message translates to:
  /// **'About Us'**
  String get aboutUsFooter;

  /// Loyalty footer link
  ///
  /// In en, this message translates to:
  /// **'Loyalty'**
  String get loyaltyFooter;

  /// Support footer link
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get supportFooter;

  /// Privacy footer link
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacyFooter;

  /// Terms footer link
  ///
  /// In en, this message translates to:
  /// **'Terms'**
  String get termsFooter;

  /// Follow us text in footer
  ///
  /// In en, this message translates to:
  /// **'Follow us: '**
  String get followUs;

  /// Copyright text in footer
  ///
  /// In en, this message translates to:
  /// **'© 2025 Dermocosmetique by Ph.Mariam'**
  String get copyrightText;

  /// All rights reserved text in footer
  ///
  /// In en, this message translates to:
  /// **'All rights reserved'**
  String get allRightsReserved;

  /// Default products page title
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get productsPageTitle;

  /// Search bar hint text
  ///
  /// In en, this message translates to:
  /// **'Search products...'**
  String get searchProductsHint;

  /// Sort option A to Z
  ///
  /// In en, this message translates to:
  /// **'Sort: A to Z'**
  String get sortAtoZ;

  /// Sort option Z to A
  ///
  /// In en, this message translates to:
  /// **'Sort: Z to A'**
  String get sortZtoA;

  /// Sort option price low to high
  ///
  /// In en, this message translates to:
  /// **'Sort: Price Low'**
  String get sortPriceLow;

  /// Sort option price high to low
  ///
  /// In en, this message translates to:
  /// **'Sort: Price High'**
  String get sortPriceHigh;

  /// Tooltip for filters button
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filtersTooltip;

  /// Filters bottom sheet title
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filtersTitle;

  /// Clear all filters button
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get clearAll;

  /// Category filter label
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get categoryFilter;

  /// Brand filter label
  ///
  /// In en, this message translates to:
  /// **'Brand'**
  String get brandFilter;

  /// All categories filter option
  ///
  /// In en, this message translates to:
  /// **'All Categories'**
  String get allCategories;

  /// All brands filter option
  ///
  /// In en, this message translates to:
  /// **'All Brands'**
  String get allBrandsFilter;

  /// Price range filter label
  ///
  /// In en, this message translates to:
  /// **'Price Range: \${start} - \${end}'**
  String priceRange(int start, int end);

  /// Minimum rating filter label
  ///
  /// In en, this message translates to:
  /// **'Minimum Rating: {rating} stars'**
  String minimumRating(String rating);

  /// In stock filter label
  ///
  /// In en, this message translates to:
  /// **'Show only products in stock'**
  String get showOnlyInStock;

  /// Apply filters button
  ///
  /// In en, this message translates to:
  /// **'Apply Filters'**
  String get applyFilters;

  /// Avène brand name
  ///
  /// In en, this message translates to:
  /// **'Avène'**
  String get avene;

  /// Vichy brand name
  ///
  /// In en, this message translates to:
  /// **'Vichy'**
  String get vichy;

  /// Eucerin brand name
  ///
  /// In en, this message translates to:
  /// **'Eucerin'**
  String get eucerin;

  /// CeraVe brand name
  ///
  /// In en, this message translates to:
  /// **'CeraVe'**
  String get cerave;

  /// Neutrogena brand name
  ///
  /// In en, this message translates to:
  /// **'Neutrogena'**
  String get neutrogena;

  /// Sold out label for products
  ///
  /// In en, this message translates to:
  /// **'SOLD OUT'**
  String get soldOut;

  /// No products found message title
  ///
  /// In en, this message translates to:
  /// **'No Products Found'**
  String get noProductsFound;

  /// No products found for search query message
  ///
  /// In en, this message translates to:
  /// **'No products match your search for \"{searchQuery}\"'**
  String noProductsMatchSearch(String searchQuery);

  /// No products found for current filters message
  ///
  /// In en, this message translates to:
  /// **'No products match your current filters'**
  String get noProductsMatchFilters;

  /// No products available message
  ///
  /// In en, this message translates to:
  /// **'No products available at the moment'**
  String get noProductsAvailable;

  /// Suggestion to adjust search or filters
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your search or filters'**
  String get tryAdjustingFilters;

  /// Clear all filters button
  ///
  /// In en, this message translates to:
  /// **'Clear All Filters'**
  String get clearAllFilters;

  /// Tooltip for grid view button
  ///
  /// In en, this message translates to:
  /// **'Grid View'**
  String get gridViewTooltip;

  /// Tooltip for list view button
  ///
  /// In en, this message translates to:
  /// **'List View'**
  String get listViewTooltip;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
