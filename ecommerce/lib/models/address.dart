class Address {
  final String id;
  final String fullName;
  final String streetAddress;
  final String? addressLine2;
  final String city;
  final String state;
  final String zipCode;
  final String country;
  final String? phoneNumber;
  final bool isDefault;

  Address({
    required this.id,
    required this.fullName,
    required this.streetAddress,
    this.addressLine2,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
    this.phoneNumber,
    this.isDefault = false,
  });

  // Create Address from form data
  factory Address.fromForm(Map<String, dynamic> formData) {
    return Address(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      fullName: formData['fullName'] ?? '',
      streetAddress: formData['streetAddress'] ?? '',
      addressLine2: formData['addressLine2'],
      city: formData['city'] ?? '',
      state: formData['state'] ?? '',
      zipCode: formData['zipCode'] ?? '',
      country: formData['country'] ?? 'United States',
      phoneNumber: formData['phoneNumber'],
      isDefault: formData['isDefault'] ?? false,
    );
  }

  // Convert to Map for storage/serialization
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'streetAddress': streetAddress,
      'addressLine2': addressLine2,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'country': country,
      'phoneNumber': phoneNumber,
      'isDefault': isDefault,
    };
  }

  // Create from Map for deserialization
  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      id: map['id'] ?? '',
      fullName: map['fullName'] ?? '',
      streetAddress: map['streetAddress'] ?? '',
      addressLine2: map['addressLine2'],
      city: map['city'] ?? '',
      state: map['state'] ?? '',
      zipCode: map['zipCode'] ?? '',
      country: map['country'] ?? 'United States',
      phoneNumber: map['phoneNumber'],
      isDefault: map['isDefault'] ?? false,
    );
  }

  // Get formatted address string
  String get formattedAddress {
    final buffer = StringBuffer();
    buffer.writeln(fullName);
    buffer.writeln(streetAddress);
    if (addressLine2 != null && addressLine2!.isNotEmpty) {
      buffer.writeln(addressLine2);
    }
    buffer.writeln('$city, $state $zipCode');
    buffer.writeln(country);
    if (phoneNumber != null && phoneNumber!.isNotEmpty) {
      buffer.writeln('Phone: $phoneNumber');
    }
    return buffer.toString().trim();
  }

  // Create copy with modifications
  Address copyWith({
    String? id,
    String? fullName,
    String? streetAddress,
    String? addressLine2,
    String? city,
    String? state,
    String? zipCode,
    String? country,
    String? phoneNumber,
    bool? isDefault,
  }) {
    return Address(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      streetAddress: streetAddress ?? this.streetAddress,
      addressLine2: addressLine2 ?? this.addressLine2,
      city: city ?? this.city,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
      country: country ?? this.country,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  @override
  String toString() {
    return 'Address(id: $id, fullName: $fullName, city: $city, state: $state)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Address && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
