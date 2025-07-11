class PaymentMethod {
  final String id;
  final String type; // 'card', 'paypal', 'apple_pay', 'google_pay', 'bank_transfer'
  final String displayName;
  final String? cardNumber; // Last 4 digits for cards
  final String? cardBrand; // 'visa', 'mastercard', 'amex', etc.
  final String? expiryMonth;
  final String? expiryYear;
  final String? cardholderName;
  final String? email; // For PayPal
  final bool isDefault;
  final bool isEnabled;
  final String? details; // Additional payment details
  
  // Derived getter for a user-friendly name
  String get name {
    switch (type.toLowerCase()) {
      case 'card':
        return '${cardBrand?.toUpperCase() ?? 'Card'} •••• ${cardNumber ?? ''}';
      case 'paypal':
        return 'PayPal${email != null ? ' ($email)' : ''}';
      case 'apple_pay':
      case 'apple pay':
        return 'Apple Pay';
      case 'google_pay':
      case 'google pay':
        return 'Google Pay';
      case 'bank_transfer':
      case 'bank transfer':
        return 'Bank Transfer';
      case 'cash_on_delivery':
      case 'cash on delivery':
      case 'cod':
        return 'Cash on Delivery';
      default:
        return displayName;
    }
  }

  PaymentMethod({
    required this.id,
    required this.type,
    required this.displayName,
    this.cardNumber,
    this.cardBrand,
    this.expiryMonth,
    this.expiryYear,
    this.cardholderName,
    this.email,
    this.isDefault = false,
    this.isEnabled = true,
    this.details,
  });

  // Factory constructor for card payments
  factory PaymentMethod.card({
    required String id,
    required String cardNumber,
    required String cardBrand,
    required String expiryMonth,
    required String expiryYear,
    required String cardholderName,
    bool isDefault = false,
  }) {
    return PaymentMethod(
      id: id,
      type: 'card',
      displayName: '•••• •••• •••• ${cardNumber.substring(cardNumber.length - 4)}',
      cardNumber: cardNumber.substring(cardNumber.length - 4),
      cardBrand: cardBrand,
      expiryMonth: expiryMonth,
      expiryYear: expiryYear,
      cardholderName: cardholderName,
      isDefault: isDefault,
    );
  }

  // Factory constructor for PayPal
  factory PaymentMethod.paypal({
    required String id,
    required String email,
    bool isDefault = false,
  }) {
    return PaymentMethod(
      id: id,
      type: 'paypal',
      displayName: 'PayPal ($email)',
      email: email,
      isDefault: isDefault,
    );
  }

  // Factory constructor for Apple Pay
  factory PaymentMethod.applePay({
    required String id,
    bool isDefault = false,
  }) {
    return PaymentMethod(
      id: id,
      type: 'apple_pay',
      displayName: 'Apple Pay',
      isDefault: isDefault,
    );
  }

  // Factory constructor for Google Pay
  factory PaymentMethod.googlePay({
    required String id,
    bool isDefault = false,
  }) {
    return PaymentMethod(
      id: id,
      type: 'google_pay',
      displayName: 'Google Pay',
      isDefault: isDefault,
    );
  }

  // Get card brand icon
  String get cardBrandIcon {
    switch (cardBrand?.toLowerCase()) {
      case 'visa':
        return 'assets/icons/visa.png';
      case 'mastercard':
        return 'assets/icons/mastercard.png';
      case 'amex':
      case 'american_express':
        return 'assets/icons/amex.png';
      case 'discover':
        return 'assets/icons/discover.png';
      default:
        return 'assets/icons/credit_card.png';
    }
  }

  // Get payment method icon
  String get paymentIcon {
    switch (type) {
      case 'card':
        return cardBrandIcon;
      case 'paypal':
        return 'assets/icons/paypal.png';
      case 'apple_pay':
        return 'assets/icons/apple_pay.png';
      case 'google_pay':
        return 'assets/icons/google_pay.png';
      case 'bank_transfer':
        return 'assets/icons/bank_transfer.png';
      default:
        return 'assets/icons/payment.png';
    }
  }

  // Validate payment method
  bool get isValid {
    switch (type) {
      case 'card':
        return cardNumber != null && 
               cardBrand != null && 
               expiryMonth != null && 
               expiryYear != null && 
               cardholderName != null;
      case 'paypal':
        return email != null && email!.contains('@');
      case 'apple_pay':
      case 'google_pay':
        return true;
      default:
        return false;
    }
  }

  // Get formatted display text
  String get formattedDisplay {
    switch (type) {
      case 'card':
        return '${cardBrand?.toUpperCase() ?? 'CARD'} •••• ${cardNumber ?? ''}';
      case 'paypal':
        return 'PayPal';
      case 'apple_pay':
        return 'Apple Pay';
      case 'google_pay':
        return 'Google Pay';
      case 'bank_transfer':
        return 'Bank Transfer';
      default:
        return displayName;
    }
  }

  // Copy with method for updates
  PaymentMethod copyWith({
    String? id,
    String? type,
    String? displayName,
    String? cardNumber,
    String? cardBrand,
    String? expiryMonth,
    String? expiryYear,
    String? cardholderName,
    String? email,
    bool? isDefault,
    bool? isEnabled,
  }) {
    return PaymentMethod(
      id: id ?? this.id,
      type: type ?? this.type,
      displayName: displayName ?? this.displayName,
      cardNumber: cardNumber ?? this.cardNumber,
      cardBrand: cardBrand ?? this.cardBrand,
      expiryMonth: expiryMonth ?? this.expiryMonth,
      expiryYear: expiryYear ?? this.expiryYear,
      cardholderName: cardholderName ?? this.cardholderName,
      email: email ?? this.email,
      isDefault: isDefault ?? this.isDefault,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }

  // Convert to map for storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'displayName': displayName,
      'cardNumber': cardNumber,
      'cardBrand': cardBrand,
      'expiryMonth': expiryMonth,
      'expiryYear': expiryYear,
      'cardholderName': cardholderName,
      'email': email,
      'isDefault': isDefault,
      'isEnabled': isEnabled,
    };
  }

  // Create from map
  factory PaymentMethod.fromMap(Map<String, dynamic> map) {
    return PaymentMethod(
      id: map['id'] ?? '',
      type: map['type'] ?? '',
      displayName: map['displayName'] ?? '',
      cardNumber: map['cardNumber'],
      cardBrand: map['cardBrand'],
      expiryMonth: map['expiryMonth'],
      expiryYear: map['expiryYear'],
      cardholderName: map['cardholderName'],
      email: map['email'],
      isDefault: map['isDefault'] ?? false,
      isEnabled: map['isEnabled'] ?? true,
    );
  }

  @override
  String toString() {
    return 'PaymentMethod{id: $id, type: $type, displayName: $displayName, isDefault: $isDefault}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PaymentMethod && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
