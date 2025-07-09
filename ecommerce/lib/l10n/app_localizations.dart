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

  /// No description provided for @ecommerceAppTitle.
  ///
  /// In en, this message translates to:
  /// **'E-Commerce App'**
  String get ecommerceAppTitle;

  /// Welcome back message on login screen
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// Sign in prompt message
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue your beauty journey'**
  String get signInToContinue;

  /// Email field label
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Password field label
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Forgot password link text
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// Remember me checkbox label
  ///
  /// In en, this message translates to:
  /// **'Remember Me'**
  String get rememberMe;

  /// Login button text
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginButton;

  /// No account text
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get noAccount;

  /// Sign up button text
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// Login successful message
  ///
  /// In en, this message translates to:
  /// **'Login successful!'**
  String get loginSuccessful;

  /// Social login divider text
  ///
  /// In en, this message translates to:
  /// **'or continue with'**
  String get orContinueWith;

  /// Brand name displayed on login screen
  ///
  /// In en, this message translates to:
  /// **'DERMOCOSMETIQUE'**
  String get brandName;

  /// Brand tagline displayed on login screen
  ///
  /// In en, this message translates to:
  /// **'BY PH.MARIAM'**
  String get brandTagline;

  /// Error message for required email
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get emailRequired;

  /// Error message for invalid email
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get emailInvalid;

  /// Error message for required password
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get passwordRequired;

  /// Error message for short password
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordTooShort;

  /// Create account button text
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// Signup page heading
  ///
  /// In en, this message translates to:
  /// **'Create Your Account'**
  String get createYourAccount;

  /// Signup page subheading
  ///
  /// In en, this message translates to:
  /// **'Join our beauty community today'**
  String get joinBeautyCommunity;

  /// First name field label
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// Last name field label
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// Email address field label
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// Confirm password field label
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// Required field error message
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get fieldRequired;

  /// Error message for required password confirmation
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get confirmPasswordRequired;

  /// Error message for non-matching passwords
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// Terms agreement text beginning
  ///
  /// In en, this message translates to:
  /// **'I agree to the '**
  String get agreeToTerms;

  /// Terms of service text
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// Conjunction between terms and privacy policy
  ///
  /// In en, this message translates to:
  /// **' and '**
  String get and;

  /// Privacy policy text
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// Error message for terms agreement
  ///
  /// In en, this message translates to:
  /// **'Please agree to terms and conditions'**
  String get agreeToTermsRequired;

  /// Account creation success message
  ///
  /// In en, this message translates to:
  /// **'Account created successfully!'**
  String get accountCreatedSuccessfully;

  /// Have account text for signup page
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get haveAccount;

  /// Sign in button text for signup page
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// Google text for social login button
  ///
  /// In en, this message translates to:
  /// **'Google'**
  String get google;

  /// Apple text for social login button
  ///
  /// In en, this message translates to:
  /// **'Apple'**
  String get apple;

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

  /// Full name required validation error
  ///
  /// In en, this message translates to:
  /// **'Full name is required'**
  String get fullNameRequired;

  /// Full name too short validation error
  ///
  /// In en, this message translates to:
  /// **'Full name must be at least 2 characters'**
  String get fullNameTooShort;

  /// Full name too long validation error
  ///
  /// In en, this message translates to:
  /// **'Full name must be less than 50 characters'**
  String get fullNameTooLong;

  /// Full name invalid characters validation error
  ///
  /// In en, this message translates to:
  /// **'Full name can only contain letters, spaces, hyphens, and apostrophes'**
  String get fullNameInvalidCharacters;

  /// Full name missing last name validation error
  ///
  /// In en, this message translates to:
  /// **'Please enter both first and last name'**
  String get fullNameMissingLastName;

  /// Street address required validation error
  ///
  /// In en, this message translates to:
  /// **'Street address is required'**
  String get streetAddressRequired;

  /// Street address too short validation error
  ///
  /// In en, this message translates to:
  /// **'Street address must be at least 5 characters'**
  String get streetAddressTooShort;

  /// Street address too long validation error
  ///
  /// In en, this message translates to:
  /// **'Street address must be less than 100 characters'**
  String get streetAddressTooLong;

  /// Street address invalid characters validation error
  ///
  /// In en, this message translates to:
  /// **'Street address contains invalid characters'**
  String get streetAddressInvalidCharacters;

  /// City required validation error
  ///
  /// In en, this message translates to:
  /// **'City is required'**
  String get cityRequired;

  /// City too short validation error
  ///
  /// In en, this message translates to:
  /// **'City name must be at least 2 characters'**
  String get cityTooShort;

  /// City too long validation error
  ///
  /// In en, this message translates to:
  /// **'City name must be less than 50 characters'**
  String get cityTooLong;

  /// City invalid characters validation error
  ///
  /// In en, this message translates to:
  /// **'City name can only contain letters, spaces, hyphens, and apostrophes'**
  String get cityInvalidCharacters;

  /// State required validation error
  ///
  /// In en, this message translates to:
  /// **'State/Province is required'**
  String get stateRequired;

  /// Invalid US state validation error
  ///
  /// In en, this message translates to:
  /// **'Please select a valid US state'**
  String get stateInvalidUS;

  /// Invalid Canadian province validation error
  ///
  /// In en, this message translates to:
  /// **'Please select a valid Canadian province'**
  String get stateInvalidCanada;

  /// State too short validation error
  ///
  /// In en, this message translates to:
  /// **'State/Province must be at least 2 characters'**
  String get stateTooShort;

  /// State too long validation error
  ///
  /// In en, this message translates to:
  /// **'State/Province must be less than 50 characters'**
  String get stateTooLong;

  /// State invalid characters validation error
  ///
  /// In en, this message translates to:
  /// **'State/Province can only contain letters, spaces, hyphens, and apostrophes'**
  String get stateInvalidCharacters;

  /// ZIP code required validation error
  ///
  /// In en, this message translates to:
  /// **'ZIP/Postal code is required'**
  String get zipCodeRequired;

  /// Invalid US ZIP code validation error
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid US ZIP code (5 or 9 digits)'**
  String get zipCodeInvalidUS;

  /// Invalid Canadian postal code validation error
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid Canadian postal code (e.g., A1A 1A1)'**
  String get zipCodeInvalidCanada;

  /// Invalid UK postal code validation error
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid UK postal code'**
  String get zipCodeInvalidUK;

  /// Invalid German postal code validation error
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid German postal code (5 digits)'**
  String get zipCodeInvalidGermany;

  /// Invalid French postal code validation error
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid French postal code (5 digits)'**
  String get zipCodeInvalidFrance;

  /// Invalid Australian postal code validation error
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid Australian postal code (4 digits)'**
  String get zipCodeInvalidAustralia;

  /// General invalid postal code validation error
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid postal code'**
  String get zipCodeInvalidGeneral;

  /// Invalid postal code characters validation error
  ///
  /// In en, this message translates to:
  /// **'Postal code can only contain letters, numbers, spaces, and hyphens'**
  String get zipCodeInvalidCharacters;

  /// ZIP code too long validation error
  ///
  /// In en, this message translates to:
  /// **'ZIP/Postal code must be less than 20 characters'**
  String get zipCodeTooLong;

  /// Country required validation error
  ///
  /// In en, this message translates to:
  /// **'Country is required'**
  String get countryRequired;

  /// Invalid country validation error
  ///
  /// In en, this message translates to:
  /// **'Please select a valid country'**
  String get countryInvalid;

  /// Invalid phone number validation error
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number'**
  String get phoneNumberInvalid;

  /// No description provided for @countryAF.
  ///
  /// In en, this message translates to:
  /// **'Afghanistan'**
  String get countryAF;

  /// No description provided for @countryAL.
  ///
  /// In en, this message translates to:
  /// **'Albania'**
  String get countryAL;

  /// No description provided for @countryDZ.
  ///
  /// In en, this message translates to:
  /// **'Algeria'**
  String get countryDZ;

  /// No description provided for @countryAD.
  ///
  /// In en, this message translates to:
  /// **'Andorra'**
  String get countryAD;

  /// No description provided for @countryAO.
  ///
  /// In en, this message translates to:
  /// **'Angola'**
  String get countryAO;

  /// No description provided for @countryAG.
  ///
  /// In en, this message translates to:
  /// **'Antigua and Barbuda'**
  String get countryAG;

  /// No description provided for @countryAR.
  ///
  /// In en, this message translates to:
  /// **'Argentina'**
  String get countryAR;

  /// No description provided for @countryAM.
  ///
  /// In en, this message translates to:
  /// **'Armenia'**
  String get countryAM;

  /// No description provided for @countryAU.
  ///
  /// In en, this message translates to:
  /// **'Australia'**
  String get countryAU;

  /// No description provided for @countryAT.
  ///
  /// In en, this message translates to:
  /// **'Austria'**
  String get countryAT;

  /// No description provided for @countryAZ.
  ///
  /// In en, this message translates to:
  /// **'Azerbaijan'**
  String get countryAZ;

  /// No description provided for @countryBS.
  ///
  /// In en, this message translates to:
  /// **'Bahamas'**
  String get countryBS;

  /// No description provided for @countryBH.
  ///
  /// In en, this message translates to:
  /// **'Bahrain'**
  String get countryBH;

  /// No description provided for @countryBD.
  ///
  /// In en, this message translates to:
  /// **'Bangladesh'**
  String get countryBD;

  /// No description provided for @countryBB.
  ///
  /// In en, this message translates to:
  /// **'Barbados'**
  String get countryBB;

  /// No description provided for @countryBY.
  ///
  /// In en, this message translates to:
  /// **'Belarus'**
  String get countryBY;

  /// No description provided for @countryBE.
  ///
  /// In en, this message translates to:
  /// **'Belgium'**
  String get countryBE;

  /// No description provided for @countryBZ.
  ///
  /// In en, this message translates to:
  /// **'Belize'**
  String get countryBZ;

  /// No description provided for @countryBJ.
  ///
  /// In en, this message translates to:
  /// **'Benin'**
  String get countryBJ;

  /// No description provided for @countryBT.
  ///
  /// In en, this message translates to:
  /// **'Bhutan'**
  String get countryBT;

  /// No description provided for @countryBO.
  ///
  /// In en, this message translates to:
  /// **'Bolivia'**
  String get countryBO;

  /// No description provided for @countryBA.
  ///
  /// In en, this message translates to:
  /// **'Bosnia and Herzegovina'**
  String get countryBA;

  /// No description provided for @countryBW.
  ///
  /// In en, this message translates to:
  /// **'Botswana'**
  String get countryBW;

  /// No description provided for @countryBR.
  ///
  /// In en, this message translates to:
  /// **'Brazil'**
  String get countryBR;

  /// No description provided for @countryBN.
  ///
  /// In en, this message translates to:
  /// **'Brunei'**
  String get countryBN;

  /// No description provided for @countryBG.
  ///
  /// In en, this message translates to:
  /// **'Bulgaria'**
  String get countryBG;

  /// No description provided for @countryBF.
  ///
  /// In en, this message translates to:
  /// **'Burkina Faso'**
  String get countryBF;

  /// No description provided for @countryBI.
  ///
  /// In en, this message translates to:
  /// **'Burundi'**
  String get countryBI;

  /// No description provided for @countryCV.
  ///
  /// In en, this message translates to:
  /// **'Cabo Verde'**
  String get countryCV;

  /// No description provided for @countryKH.
  ///
  /// In en, this message translates to:
  /// **'Cambodia'**
  String get countryKH;

  /// No description provided for @countryCM.
  ///
  /// In en, this message translates to:
  /// **'Cameroon'**
  String get countryCM;

  /// No description provided for @countryCA.
  ///
  /// In en, this message translates to:
  /// **'Canada'**
  String get countryCA;

  /// No description provided for @countryCF.
  ///
  /// In en, this message translates to:
  /// **'Central African Republic'**
  String get countryCF;

  /// No description provided for @countryTD.
  ///
  /// In en, this message translates to:
  /// **'Chad'**
  String get countryTD;

  /// No description provided for @countryCL.
  ///
  /// In en, this message translates to:
  /// **'Chile'**
  String get countryCL;

  /// No description provided for @countryCN.
  ///
  /// In en, this message translates to:
  /// **'China'**
  String get countryCN;

  /// No description provided for @countryCO.
  ///
  /// In en, this message translates to:
  /// **'Colombia'**
  String get countryCO;

  /// No description provided for @countryKM.
  ///
  /// In en, this message translates to:
  /// **'Comoros'**
  String get countryKM;

  /// No description provided for @countryCG.
  ///
  /// In en, this message translates to:
  /// **'Congo'**
  String get countryCG;

  /// No description provided for @countryCD.
  ///
  /// In en, this message translates to:
  /// **'Congo (Democratic Republic)'**
  String get countryCD;

  /// No description provided for @countryCR.
  ///
  /// In en, this message translates to:
  /// **'Costa Rica'**
  String get countryCR;

  /// No description provided for @countryCI.
  ///
  /// In en, this message translates to:
  /// **'Côte d\'Ivoire'**
  String get countryCI;

  /// No description provided for @countryHR.
  ///
  /// In en, this message translates to:
  /// **'Croatia'**
  String get countryHR;

  /// No description provided for @countryCU.
  ///
  /// In en, this message translates to:
  /// **'Cuba'**
  String get countryCU;

  /// No description provided for @countryCY.
  ///
  /// In en, this message translates to:
  /// **'Cyprus'**
  String get countryCY;

  /// No description provided for @countryCZ.
  ///
  /// In en, this message translates to:
  /// **'Czech Republic'**
  String get countryCZ;

  /// No description provided for @countryDK.
  ///
  /// In en, this message translates to:
  /// **'Denmark'**
  String get countryDK;

  /// No description provided for @countryDJ.
  ///
  /// In en, this message translates to:
  /// **'Djibouti'**
  String get countryDJ;

  /// No description provided for @countryDM.
  ///
  /// In en, this message translates to:
  /// **'Dominica'**
  String get countryDM;

  /// No description provided for @countryDO.
  ///
  /// In en, this message translates to:
  /// **'Dominican Republic'**
  String get countryDO;

  /// No description provided for @countryEC.
  ///
  /// In en, this message translates to:
  /// **'Ecuador'**
  String get countryEC;

  /// No description provided for @countryEG.
  ///
  /// In en, this message translates to:
  /// **'Egypt'**
  String get countryEG;

  /// No description provided for @countrySV.
  ///
  /// In en, this message translates to:
  /// **'El Salvador'**
  String get countrySV;

  /// No description provided for @countryGQ.
  ///
  /// In en, this message translates to:
  /// **'Equatorial Guinea'**
  String get countryGQ;

  /// No description provided for @countryER.
  ///
  /// In en, this message translates to:
  /// **'Eritrea'**
  String get countryER;

  /// No description provided for @countryEE.
  ///
  /// In en, this message translates to:
  /// **'Estonia'**
  String get countryEE;

  /// No description provided for @countryET.
  ///
  /// In en, this message translates to:
  /// **'Ethiopia'**
  String get countryET;

  /// No description provided for @countryFJ.
  ///
  /// In en, this message translates to:
  /// **'Fiji'**
  String get countryFJ;

  /// No description provided for @countryFI.
  ///
  /// In en, this message translates to:
  /// **'Finland'**
  String get countryFI;

  /// No description provided for @countryFR.
  ///
  /// In en, this message translates to:
  /// **'France'**
  String get countryFR;

  /// No description provided for @countryGA.
  ///
  /// In en, this message translates to:
  /// **'Gabon'**
  String get countryGA;

  /// No description provided for @countryGM.
  ///
  /// In en, this message translates to:
  /// **'Gambia'**
  String get countryGM;

  /// No description provided for @countryGE.
  ///
  /// In en, this message translates to:
  /// **'Georgia'**
  String get countryGE;

  /// No description provided for @countryDE.
  ///
  /// In en, this message translates to:
  /// **'Germany'**
  String get countryDE;

  /// No description provided for @countryGH.
  ///
  /// In en, this message translates to:
  /// **'Ghana'**
  String get countryGH;

  /// No description provided for @countryGR.
  ///
  /// In en, this message translates to:
  /// **'Greece'**
  String get countryGR;

  /// No description provided for @countryGD.
  ///
  /// In en, this message translates to:
  /// **'Grenada'**
  String get countryGD;

  /// No description provided for @countryGT.
  ///
  /// In en, this message translates to:
  /// **'Guatemala'**
  String get countryGT;

  /// No description provided for @countryGN.
  ///
  /// In en, this message translates to:
  /// **'Guinea'**
  String get countryGN;

  /// No description provided for @countryGW.
  ///
  /// In en, this message translates to:
  /// **'Guinea-Bissau'**
  String get countryGW;

  /// No description provided for @countryGY.
  ///
  /// In en, this message translates to:
  /// **'Guyana'**
  String get countryGY;

  /// No description provided for @countryHT.
  ///
  /// In en, this message translates to:
  /// **'Haiti'**
  String get countryHT;

  /// No description provided for @countryHN.
  ///
  /// In en, this message translates to:
  /// **'Honduras'**
  String get countryHN;

  /// No description provided for @countryHU.
  ///
  /// In en, this message translates to:
  /// **'Hungary'**
  String get countryHU;

  /// No description provided for @countryIS.
  ///
  /// In en, this message translates to:
  /// **'Iceland'**
  String get countryIS;

  /// No description provided for @countryIN.
  ///
  /// In en, this message translates to:
  /// **'India'**
  String get countryIN;

  /// No description provided for @countryID.
  ///
  /// In en, this message translates to:
  /// **'Indonesia'**
  String get countryID;

  /// No description provided for @countryIR.
  ///
  /// In en, this message translates to:
  /// **'Iran'**
  String get countryIR;

  /// No description provided for @countryIQ.
  ///
  /// In en, this message translates to:
  /// **'Iraq'**
  String get countryIQ;

  /// No description provided for @countryIE.
  ///
  /// In en, this message translates to:
  /// **'Ireland'**
  String get countryIE;

  /// No description provided for @countryIL.
  ///
  /// In en, this message translates to:
  /// **'Israel'**
  String get countryIL;

  /// No description provided for @countryIT.
  ///
  /// In en, this message translates to:
  /// **'Italy'**
  String get countryIT;

  /// No description provided for @countryJM.
  ///
  /// In en, this message translates to:
  /// **'Jamaica'**
  String get countryJM;

  /// No description provided for @countryJP.
  ///
  /// In en, this message translates to:
  /// **'Japan'**
  String get countryJP;

  /// No description provided for @countryJO.
  ///
  /// In en, this message translates to:
  /// **'Jordan'**
  String get countryJO;

  /// No description provided for @countryKZ.
  ///
  /// In en, this message translates to:
  /// **'Kazakhstan'**
  String get countryKZ;

  /// No description provided for @countryKE.
  ///
  /// In en, this message translates to:
  /// **'Kenya'**
  String get countryKE;

  /// No description provided for @countryKI.
  ///
  /// In en, this message translates to:
  /// **'Kiribati'**
  String get countryKI;

  /// No description provided for @countryKW.
  ///
  /// In en, this message translates to:
  /// **'Kuwait'**
  String get countryKW;

  /// No description provided for @countryKG.
  ///
  /// In en, this message translates to:
  /// **'Kyrgyzstan'**
  String get countryKG;

  /// No description provided for @countryLA.
  ///
  /// In en, this message translates to:
  /// **'Laos'**
  String get countryLA;

  /// No description provided for @countryLV.
  ///
  /// In en, this message translates to:
  /// **'Latvia'**
  String get countryLV;

  /// No description provided for @countryLB.
  ///
  /// In en, this message translates to:
  /// **'Lebanon'**
  String get countryLB;

  /// No description provided for @countryLS.
  ///
  /// In en, this message translates to:
  /// **'Lesotho'**
  String get countryLS;

  /// No description provided for @countryLR.
  ///
  /// In en, this message translates to:
  /// **'Liberia'**
  String get countryLR;

  /// No description provided for @countryLY.
  ///
  /// In en, this message translates to:
  /// **'Libya'**
  String get countryLY;

  /// No description provided for @countryLI.
  ///
  /// In en, this message translates to:
  /// **'Liechtenstein'**
  String get countryLI;

  /// No description provided for @countryLT.
  ///
  /// In en, this message translates to:
  /// **'Lithuania'**
  String get countryLT;

  /// No description provided for @countryLU.
  ///
  /// In en, this message translates to:
  /// **'Luxembourg'**
  String get countryLU;

  /// No description provided for @countryMK.
  ///
  /// In en, this message translates to:
  /// **'North Macedonia'**
  String get countryMK;

  /// No description provided for @countryMG.
  ///
  /// In en, this message translates to:
  /// **'Madagascar'**
  String get countryMG;

  /// No description provided for @countryMW.
  ///
  /// In en, this message translates to:
  /// **'Malawi'**
  String get countryMW;

  /// No description provided for @countryMY.
  ///
  /// In en, this message translates to:
  /// **'Malaysia'**
  String get countryMY;

  /// No description provided for @countryMV.
  ///
  /// In en, this message translates to:
  /// **'Maldives'**
  String get countryMV;

  /// No description provided for @countryML.
  ///
  /// In en, this message translates to:
  /// **'Mali'**
  String get countryML;

  /// No description provided for @countryMT.
  ///
  /// In en, this message translates to:
  /// **'Malta'**
  String get countryMT;

  /// No description provided for @countryMH.
  ///
  /// In en, this message translates to:
  /// **'Marshall Islands'**
  String get countryMH;

  /// No description provided for @countryMR.
  ///
  /// In en, this message translates to:
  /// **'Mauritania'**
  String get countryMR;

  /// No description provided for @countryMU.
  ///
  /// In en, this message translates to:
  /// **'Mauritius'**
  String get countryMU;

  /// No description provided for @countryMX.
  ///
  /// In en, this message translates to:
  /// **'Mexico'**
  String get countryMX;

  /// No description provided for @countryFM.
  ///
  /// In en, this message translates to:
  /// **'Micronesia'**
  String get countryFM;

  /// No description provided for @countryMD.
  ///
  /// In en, this message translates to:
  /// **'Moldova'**
  String get countryMD;

  /// No description provided for @countryMC.
  ///
  /// In en, this message translates to:
  /// **'Monaco'**
  String get countryMC;

  /// No description provided for @countryMN.
  ///
  /// In en, this message translates to:
  /// **'Mongolia'**
  String get countryMN;

  /// No description provided for @countryME.
  ///
  /// In en, this message translates to:
  /// **'Montenegro'**
  String get countryME;

  /// No description provided for @countryMA.
  ///
  /// In en, this message translates to:
  /// **'Morocco'**
  String get countryMA;

  /// No description provided for @countryMZ.
  ///
  /// In en, this message translates to:
  /// **'Mozambique'**
  String get countryMZ;

  /// No description provided for @countryMM.
  ///
  /// In en, this message translates to:
  /// **'Myanmar'**
  String get countryMM;

  /// No description provided for @countryNA.
  ///
  /// In en, this message translates to:
  /// **'Namibia'**
  String get countryNA;

  /// No description provided for @countryNR.
  ///
  /// In en, this message translates to:
  /// **'Nauru'**
  String get countryNR;

  /// No description provided for @countryNP.
  ///
  /// In en, this message translates to:
  /// **'Nepal'**
  String get countryNP;

  /// No description provided for @countryNL.
  ///
  /// In en, this message translates to:
  /// **'Netherlands'**
  String get countryNL;

  /// No description provided for @countryNZ.
  ///
  /// In en, this message translates to:
  /// **'New Zealand'**
  String get countryNZ;

  /// No description provided for @countryNI.
  ///
  /// In en, this message translates to:
  /// **'Nicaragua'**
  String get countryNI;

  /// No description provided for @countryNE.
  ///
  /// In en, this message translates to:
  /// **'Niger'**
  String get countryNE;

  /// No description provided for @countryNG.
  ///
  /// In en, this message translates to:
  /// **'Nigeria'**
  String get countryNG;

  /// No description provided for @countryKP.
  ///
  /// In en, this message translates to:
  /// **'North Korea'**
  String get countryKP;

  /// No description provided for @countryNO.
  ///
  /// In en, this message translates to:
  /// **'Norway'**
  String get countryNO;

  /// No description provided for @countryOM.
  ///
  /// In en, this message translates to:
  /// **'Oman'**
  String get countryOM;

  /// No description provided for @countryPK.
  ///
  /// In en, this message translates to:
  /// **'Pakistan'**
  String get countryPK;

  /// No description provided for @countryPW.
  ///
  /// In en, this message translates to:
  /// **'Palau'**
  String get countryPW;

  /// No description provided for @countryPA.
  ///
  /// In en, this message translates to:
  /// **'Panama'**
  String get countryPA;

  /// No description provided for @countryPG.
  ///
  /// In en, this message translates to:
  /// **'Papua New Guinea'**
  String get countryPG;

  /// No description provided for @countryPY.
  ///
  /// In en, this message translates to:
  /// **'Paraguay'**
  String get countryPY;

  /// No description provided for @countryPE.
  ///
  /// In en, this message translates to:
  /// **'Peru'**
  String get countryPE;

  /// No description provided for @countryPH.
  ///
  /// In en, this message translates to:
  /// **'Philippines'**
  String get countryPH;

  /// No description provided for @countryPL.
  ///
  /// In en, this message translates to:
  /// **'Poland'**
  String get countryPL;

  /// No description provided for @countryPT.
  ///
  /// In en, this message translates to:
  /// **'Portugal'**
  String get countryPT;

  /// No description provided for @countryQA.
  ///
  /// In en, this message translates to:
  /// **'Qatar'**
  String get countryQA;

  /// No description provided for @countryRO.
  ///
  /// In en, this message translates to:
  /// **'Romania'**
  String get countryRO;

  /// No description provided for @countryRU.
  ///
  /// In en, this message translates to:
  /// **'Russia'**
  String get countryRU;

  /// No description provided for @countryRW.
  ///
  /// In en, this message translates to:
  /// **'Rwanda'**
  String get countryRW;

  /// No description provided for @countryKN.
  ///
  /// In en, this message translates to:
  /// **'Saint Kitts and Nevis'**
  String get countryKN;

  /// No description provided for @countryLC.
  ///
  /// In en, this message translates to:
  /// **'Saint Lucia'**
  String get countryLC;

  /// No description provided for @countryVC.
  ///
  /// In en, this message translates to:
  /// **'Saint Vincent and the Grenadines'**
  String get countryVC;

  /// No description provided for @countryWS.
  ///
  /// In en, this message translates to:
  /// **'Samoa'**
  String get countryWS;

  /// No description provided for @countrySM.
  ///
  /// In en, this message translates to:
  /// **'San Marino'**
  String get countrySM;

  /// No description provided for @countryST.
  ///
  /// In en, this message translates to:
  /// **'São Tomé and Príncipe'**
  String get countryST;

  /// No description provided for @countrySA.
  ///
  /// In en, this message translates to:
  /// **'Saudi Arabia'**
  String get countrySA;

  /// No description provided for @countrySN.
  ///
  /// In en, this message translates to:
  /// **'Senegal'**
  String get countrySN;

  /// No description provided for @countryRS.
  ///
  /// In en, this message translates to:
  /// **'Serbia'**
  String get countryRS;

  /// No description provided for @countrySC.
  ///
  /// In en, this message translates to:
  /// **'Seychelles'**
  String get countrySC;

  /// No description provided for @countrySL.
  ///
  /// In en, this message translates to:
  /// **'Sierra Leone'**
  String get countrySL;

  /// No description provided for @countrySG.
  ///
  /// In en, this message translates to:
  /// **'Singapore'**
  String get countrySG;

  /// No description provided for @countrySK.
  ///
  /// In en, this message translates to:
  /// **'Slovakia'**
  String get countrySK;

  /// No description provided for @countrySI.
  ///
  /// In en, this message translates to:
  /// **'Slovenia'**
  String get countrySI;

  /// No description provided for @countrySB.
  ///
  /// In en, this message translates to:
  /// **'Solomon Islands'**
  String get countrySB;

  /// No description provided for @countrySO.
  ///
  /// In en, this message translates to:
  /// **'Somalia'**
  String get countrySO;

  /// No description provided for @countryZA.
  ///
  /// In en, this message translates to:
  /// **'South Africa'**
  String get countryZA;

  /// No description provided for @countryKR.
  ///
  /// In en, this message translates to:
  /// **'South Korea'**
  String get countryKR;

  /// No description provided for @countrySS.
  ///
  /// In en, this message translates to:
  /// **'South Sudan'**
  String get countrySS;

  /// No description provided for @countryES.
  ///
  /// In en, this message translates to:
  /// **'Spain'**
  String get countryES;

  /// No description provided for @countryLK.
  ///
  /// In en, this message translates to:
  /// **'Sri Lanka'**
  String get countryLK;

  /// No description provided for @countrySD.
  ///
  /// In en, this message translates to:
  /// **'Sudan'**
  String get countrySD;

  /// No description provided for @countrySR.
  ///
  /// In en, this message translates to:
  /// **'Suriname'**
  String get countrySR;

  /// No description provided for @countrySZ.
  ///
  /// In en, this message translates to:
  /// **'Eswatini'**
  String get countrySZ;

  /// No description provided for @countrySE.
  ///
  /// In en, this message translates to:
  /// **'Sweden'**
  String get countrySE;

  /// No description provided for @countryCH.
  ///
  /// In en, this message translates to:
  /// **'Switzerland'**
  String get countryCH;

  /// No description provided for @countrySY.
  ///
  /// In en, this message translates to:
  /// **'Syria'**
  String get countrySY;

  /// No description provided for @countryTW.
  ///
  /// In en, this message translates to:
  /// **'Taiwan'**
  String get countryTW;

  /// No description provided for @countryTJ.
  ///
  /// In en, this message translates to:
  /// **'Tajikistan'**
  String get countryTJ;

  /// No description provided for @countryTZ.
  ///
  /// In en, this message translates to:
  /// **'Tanzania'**
  String get countryTZ;

  /// No description provided for @countryTH.
  ///
  /// In en, this message translates to:
  /// **'Thailand'**
  String get countryTH;

  /// No description provided for @countryTL.
  ///
  /// In en, this message translates to:
  /// **'Timor-Leste'**
  String get countryTL;

  /// No description provided for @countryTG.
  ///
  /// In en, this message translates to:
  /// **'Togo'**
  String get countryTG;

  /// No description provided for @countryTO.
  ///
  /// In en, this message translates to:
  /// **'Tonga'**
  String get countryTO;

  /// No description provided for @countryTT.
  ///
  /// In en, this message translates to:
  /// **'Trinidad and Tobago'**
  String get countryTT;

  /// No description provided for @countryTN.
  ///
  /// In en, this message translates to:
  /// **'Tunisia'**
  String get countryTN;

  /// No description provided for @countryTR.
  ///
  /// In en, this message translates to:
  /// **'Turkey'**
  String get countryTR;

  /// No description provided for @countryTM.
  ///
  /// In en, this message translates to:
  /// **'Turkmenistan'**
  String get countryTM;

  /// No description provided for @countryTV.
  ///
  /// In en, this message translates to:
  /// **'Tuvalu'**
  String get countryTV;

  /// No description provided for @countryUG.
  ///
  /// In en, this message translates to:
  /// **'Uganda'**
  String get countryUG;

  /// No description provided for @countryUA.
  ///
  /// In en, this message translates to:
  /// **'Ukraine'**
  String get countryUA;

  /// No description provided for @countryAE.
  ///
  /// In en, this message translates to:
  /// **'United Arab Emirates'**
  String get countryAE;

  /// No description provided for @countryGB.
  ///
  /// In en, this message translates to:
  /// **'United Kingdom'**
  String get countryGB;

  /// No description provided for @countryUS.
  ///
  /// In en, this message translates to:
  /// **'United States'**
  String get countryUS;

  /// No description provided for @countryUY.
  ///
  /// In en, this message translates to:
  /// **'Uruguay'**
  String get countryUY;

  /// No description provided for @countryUZ.
  ///
  /// In en, this message translates to:
  /// **'Uzbekistan'**
  String get countryUZ;

  /// No description provided for @countryVU.
  ///
  /// In en, this message translates to:
  /// **'Vanuatu'**
  String get countryVU;

  /// No description provided for @countryVA.
  ///
  /// In en, this message translates to:
  /// **'Vatican City'**
  String get countryVA;

  /// No description provided for @countryVE.
  ///
  /// In en, this message translates to:
  /// **'Venezuela'**
  String get countryVE;

  /// No description provided for @countryVN.
  ///
  /// In en, this message translates to:
  /// **'Vietnam'**
  String get countryVN;

  /// No description provided for @countryYE.
  ///
  /// In en, this message translates to:
  /// **'Yemen'**
  String get countryYE;

  /// No description provided for @countryZM.
  ///
  /// In en, this message translates to:
  /// **'Zambia'**
  String get countryZM;

  /// No description provided for @countryZW.
  ///
  /// In en, this message translates to:
  /// **'Zimbabwe'**
  String get countryZW;

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

  /// Order details dialog title
  ///
  /// In en, this message translates to:
  /// **'Order Details'**
  String get orderDetailsDialogTitle;

  /// Order email updates message
  ///
  /// In en, this message translates to:
  /// **'You will receive email updates about your order status and tracking information.'**
  String get orderEmailUpdatesMessage;

  /// Generic card label
  ///
  /// In en, this message translates to:
  /// **'CARD'**
  String get cardLabel;

  /// Order status: Pending
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get orderStatusPending;

  /// Order status: Confirmed
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get orderStatusConfirmed;

  /// Order status: Processing
  ///
  /// In en, this message translates to:
  /// **'Processing'**
  String get orderStatusProcessing;

  /// Order status: Shipped
  ///
  /// In en, this message translates to:
  /// **'Shipped'**
  String get orderStatusShipped;

  /// Order status: Delivered
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get orderStatusDelivered;

  /// Order status: Cancelled
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get orderStatusCancelled;

  /// Order status: Refunded
  ///
  /// In en, this message translates to:
  /// **'Refunded'**
  String get orderStatusRefunded;

  /// Face Care category
  ///
  /// In en, this message translates to:
  /// **'Face Care'**
  String get categoryFaceCare;

  /// Body Care category
  ///
  /// In en, this message translates to:
  /// **'Body Care'**
  String get categoryBodyCare;

  /// Hair Care category
  ///
  /// In en, this message translates to:
  /// **'Hair Care'**
  String get categoryHairCare;

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

  /// Profile access dialog title
  ///
  /// In en, this message translates to:
  /// **'Access Profile'**
  String get accessProfile;

  /// Profile access dialog message
  ///
  /// In en, this message translates to:
  /// **'Please login or register to access your profile.'**
  String get loginRegisterPrompt;

  /// Register button text
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// My Profile menu item
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get myProfile;

  /// Personal Information section title
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInformation;

  /// Security section title
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// Change password option
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// Two-factor authentication option
  ///
  /// In en, this message translates to:
  /// **'Two-Factor Authentication'**
  String get twoFactorAuth;

  /// Email notifications setting
  ///
  /// In en, this message translates to:
  /// **'Email Notifications'**
  String get emailNotifications;

  /// Push notifications setting
  ///
  /// In en, this message translates to:
  /// **'Push Notifications'**
  String get pushNotifications;

  /// Order updates setting
  ///
  /// In en, this message translates to:
  /// **'Order Updates'**
  String get orderUpdates;

  /// Recent orders section title
  ///
  /// In en, this message translates to:
  /// **'Recent Orders'**
  String get recentOrders;

  /// View all orders button
  ///
  /// In en, this message translates to:
  /// **'View All Orders'**
  String get viewAllOrders;

  /// Shipping addresses section title
  ///
  /// In en, this message translates to:
  /// **'Shipping Addresses'**
  String get shippingAddresses;

  /// Add new button
  ///
  /// In en, this message translates to:
  /// **'Add New'**
  String get addNew;

  /// Home address label
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Work address label
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get work;

  /// Default address label
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get defaultAddress;

  /// Appearance section title
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// Dark mode setting
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// Account section title
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// Display name field
  ///
  /// In en, this message translates to:
  /// **'Display Name'**
  String get displayName;

  /// Phone field
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// Add to cart button
  ///
  /// In en, this message translates to:
  /// **'ADD TO CART'**
  String get addToCart;

  /// View details button
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetails;

  /// Delivered status
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get delivered;

  /// Processing status
  ///
  /// In en, this message translates to:
  /// **'Processing'**
  String get processing;

  /// Total label in cart summary
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// Items plural
  ///
  /// In en, this message translates to:
  /// **'items'**
  String get items;

  /// Item singular
  ///
  /// In en, this message translates to:
  /// **'item'**
  String get item;

  /// Notifications feature name
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// Welcome message for guests
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// Default user email for drawer when not logged in
  ///
  /// In en, this message translates to:
  /// **'guest@example.com'**
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

  /// Size label for product details
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get sizeLabel;

  /// Current rating indicator
  ///
  /// In en, this message translates to:
  /// **'current'**
  String get currentRating;

  /// Rate this product label
  ///
  /// In en, this message translates to:
  /// **'Rate this product:'**
  String get rateThisProduct;

  /// Instructions for rating products
  ///
  /// In en, this message translates to:
  /// **'Tap stars to rate (tap twice for half-star)'**
  String get ratingInstructions;

  /// No rating selected message
  ///
  /// In en, this message translates to:
  /// **'No rating selected'**
  String get noRatingSelected;

  /// Your rating display
  ///
  /// In en, this message translates to:
  /// **'Your rating: {rating} {stars}'**
  String yourRating(String rating, String stars);

  /// Singular star
  ///
  /// In en, this message translates to:
  /// **'star'**
  String get star;

  /// Plural stars
  ///
  /// In en, this message translates to:
  /// **'stars'**
  String get stars;

  /// Submit rating button
  ///
  /// In en, this message translates to:
  /// **'SUBMIT RATING'**
  String get submitRating;

  /// Rating submitted confirmation
  ///
  /// In en, this message translates to:
  /// **'Rating submitted: {rating} stars!'**
  String ratingSubmitted(String rating);

  /// Product added to cart message
  ///
  /// In en, this message translates to:
  /// **'{productName} added to cart!'**
  String addedToCart(String productName);

  /// View cart button
  ///
  /// In en, this message translates to:
  /// **'VIEW CART'**
  String get viewCart;

  /// Close dialog button
  ///
  /// In en, this message translates to:
  /// **'CLOSE'**
  String get closeDialog;

  /// Text shown when product size or other field is not specified
  ///
  /// In en, this message translates to:
  /// **'Not specified'**
  String get notSpecified;

  /// Shopping cart page title
  ///
  /// In en, this message translates to:
  /// **'Shopping Cart'**
  String get shoppingCartTitle;

  /// Empty cart message
  ///
  /// In en, this message translates to:
  /// **'Your cart is empty'**
  String get cartEmpty;

  /// Empty cart suggestion message
  ///
  /// In en, this message translates to:
  /// **'Add some products to get started'**
  String get addProductsToStart;

  /// Continue shopping button in empty cart
  ///
  /// In en, this message translates to:
  /// **'Continue Shopping'**
  String get continueShopping;

  /// Snackbar message when item is removed from cart
  ///
  /// In en, this message translates to:
  /// **'{itemName} removed from cart'**
  String itemRemovedFromCart(String itemName);

  /// Undo action button
  ///
  /// In en, this message translates to:
  /// **'UNDO'**
  String get undo;

  /// Subtotal with item count in cart summary
  ///
  /// In en, this message translates to:
  /// **'Subtotal ({itemCount} items)'**
  String subtotalItems(int itemCount);

  /// Shipping label in cart summary
  ///
  /// In en, this message translates to:
  /// **'Shipping'**
  String get shipping;

  /// Free shipping label
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get free;

  /// Proceed to checkout button
  ///
  /// In en, this message translates to:
  /// **'PROCEED TO CHECKOUT'**
  String get proceedToCheckout;

  /// Language label
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// English language name
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get englishLanguage;

  /// Arabic language name
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabicLanguage;

  /// Logout text for drawer
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// Login/Register text for drawer
  ///
  /// In en, this message translates to:
  /// **'Login / Register'**
  String get loginRegister;

  /// Logout successful message
  ///
  /// In en, this message translates to:
  /// **'You have been successfully logged out'**
  String get logoutSuccessful;

  /// Welcome message for logged in user
  ///
  /// In en, this message translates to:
  /// **'Welcome, {name}'**
  String welcomeUser(String name);

  /// Text shown when user is not logged in
  ///
  /// In en, this message translates to:
  /// **'Not logged in'**
  String get notLoggedIn;

  /// Personal Info tab title
  ///
  /// In en, this message translates to:
  /// **'Personal Info'**
  String get profilePersonalInfo;

  /// Orders tab title
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get profileOrders;

  /// Addresses tab title
  ///
  /// In en, this message translates to:
  /// **'Addresses'**
  String get profileAddresses;

  /// Wishlist tab title
  ///
  /// In en, this message translates to:
  /// **'Wishlist'**
  String get profileWishlist;

  /// Settings tab title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get profileSettings;

  /// Personal Information section title
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get profilePersonalInformation;

  /// Display name field label
  ///
  /// In en, this message translates to:
  /// **'Display Name'**
  String get profileDisplayName;

  /// Phone field label
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get profilePhone;

  /// Security section title
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get profileSecurity;

  /// Change password button text
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get profileChangePassword;

  /// Two-Factor Authentication button text
  ///
  /// In en, this message translates to:
  /// **'Two-Factor Authentication'**
  String get profileTwoFactorAuth;

  /// Notifications section title
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get profileNotifications;

  /// Email notifications toggle label
  ///
  /// In en, this message translates to:
  /// **'Email Notifications'**
  String get profileEmailNotifications;

  /// Push notifications toggle label
  ///
  /// In en, this message translates to:
  /// **'Push Notifications'**
  String get profilePushNotifications;

  /// Order updates toggle label
  ///
  /// In en, this message translates to:
  /// **'Order Updates'**
  String get profileOrderUpdates;

  /// Recent orders section title
  ///
  /// In en, this message translates to:
  /// **'Recent Orders'**
  String get profileRecentOrders;

  /// Order status: delivered
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get profileOrderDelivered;

  /// Order status: processing
  ///
  /// In en, this message translates to:
  /// **'Processing'**
  String get profileOrderProcessing;

  /// View all orders button text
  ///
  /// In en, this message translates to:
  /// **'View All Orders'**
  String get profileViewAllOrders;

  /// Shipping addresses section title
  ///
  /// In en, this message translates to:
  /// **'Shipping Addresses'**
  String get profileShippingAddresses;

  /// Add new button text
  ///
  /// In en, this message translates to:
  /// **'Add New'**
  String get profileAddNew;

  /// Home address label
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get profileAddressHome;

  /// Work address label
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get profileAddressWork;

  /// Default address label
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get profileAddressDefault;

  /// Language section title
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get profileLanguage;

  /// Appearance section title
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get profileAppearance;

  /// Dark mode toggle label
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get profileDarkMode;

  /// Account section title
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get profileAccount;

  /// Singular form of item
  ///
  /// In en, this message translates to:
  /// **'item'**
  String get profileItemSingular;

  /// Plural form of items
  ///
  /// In en, this message translates to:
  /// **'items'**
  String get profileItemPlural;

  /// View details button text
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get profileViewDetails;

  /// Product name placeholder
  ///
  /// In en, this message translates to:
  /// **'Product Name'**
  String get profileProductName;

  /// Add to cart button text
  ///
  /// In en, this message translates to:
  /// **'Add to Cart'**
  String get profileAddToCart;
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
