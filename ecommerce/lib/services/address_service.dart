import '../models/address.dart';

class AddressService {
  static final AddressService _instance = AddressService._internal();
  factory AddressService() => _instance;
  AddressService._internal();

  final List<Address> _addresses = [
    Address(
      id: '1',
      fullName: 'John Doe',
      streetAddress: '123 Main Street',
      city: 'New York',
      state: 'NY',
      zipCode: '10001',
      country: 'United States',
      phoneNumber: '+1 (555) 123-4567',
      isDefault: true,
    ),
    Address(
      id: '2',
      fullName: 'John Doe',
      streetAddress: '456 Office Avenue',
      city: 'New York',
      state: 'NY',
      zipCode: '10002',
      country: 'United States',
      phoneNumber: '+1 (555) 123-4567',
    ),
  ];

  List<Address> get addresses => List.unmodifiable(_addresses);

  Address? get defaultAddress {
    try {
      return _addresses.firstWhere((address) => address.isDefault);
    } catch (e) {
      return _addresses.isNotEmpty ? _addresses.first : null;
    }
  }

  void addAddress(Address address) {
    // If this is being set as default, remove default from others
    if (address.isDefault) {
      for (int i = 0; i < _addresses.length; i++) {
        _addresses[i] = Address(
          id: _addresses[i].id,
          fullName: _addresses[i].fullName,
          streetAddress: _addresses[i].streetAddress,
          addressLine2: _addresses[i].addressLine2,
          city: _addresses[i].city,
          state: _addresses[i].state,
          zipCode: _addresses[i].zipCode,
          country: _addresses[i].country,
          phoneNumber: _addresses[i].phoneNumber,
          isDefault: false,
        );
      }
    }
    _addresses.add(address);
  }

  void updateAddress(Address updatedAddress) {
    final index = _addresses.indexWhere((a) => a.id == updatedAddress.id);
    if (index != -1) {
      // If this is being set as default, remove default from others
      if (updatedAddress.isDefault) {
        for (int i = 0; i < _addresses.length; i++) {
          if (i != index) {
            _addresses[i] = Address(
              id: _addresses[i].id,
              fullName: _addresses[i].fullName,
              streetAddress: _addresses[i].streetAddress,
              addressLine2: _addresses[i].addressLine2,
              city: _addresses[i].city,
              state: _addresses[i].state,
              zipCode: _addresses[i].zipCode,
              country: _addresses[i].country,
              phoneNumber: _addresses[i].phoneNumber,
              isDefault: false,
            );
          }
        }
      }
      _addresses[index] = updatedAddress;
    }
  }

  bool deleteAddress(String addressId) {
    final index = _addresses.indexWhere((a) => a.id == addressId);
    if (index != -1) {
      final wasDefault = _addresses[index].isDefault;
      _addresses.removeAt(index);
      
      // If we deleted the default address and there are still addresses left,
      // make the first one default
      if (wasDefault && _addresses.isNotEmpty) {
        _addresses[0] = Address(
          id: _addresses[0].id,
          fullName: _addresses[0].fullName,
          streetAddress: _addresses[0].streetAddress,
          addressLine2: _addresses[0].addressLine2,
          city: _addresses[0].city,
          state: _addresses[0].state,
          zipCode: _addresses[0].zipCode,
          country: _addresses[0].country,
          phoneNumber: _addresses[0].phoneNumber,
          isDefault: true,
        );
      }
      return true;
    }
    return false;
  }

  Address? getAddressById(String id) {
    try {
      return _addresses.firstWhere((a) => a.id == id);
    } catch (e) {
      return null;
    }
  }

  bool get hasAddresses => _addresses.isNotEmpty;
}
