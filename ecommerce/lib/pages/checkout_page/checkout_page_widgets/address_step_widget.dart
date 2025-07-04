import 'package:flutter/material.dart';
import '../../../models/address.dart';
import '../../../services/address_service.dart';
import '../../../services/address_validation_service.dart';
import '../../../l10n/app_localizations.dart';

class AddressStepWidget extends StatefulWidget {
  final Address? selectedShippingAddress;
  final Address? selectedBillingAddress;
  final bool useSameAddressForBilling;
  final Function(Address) onShippingAddressChanged;
  final Function(Address) onBillingAddressChanged;
  final Function(bool) onUseSameAddressChanged;

  const AddressStepWidget({
    Key? key,
    this.selectedShippingAddress,
    this.selectedBillingAddress,
    required this.useSameAddressForBilling,
    required this.onShippingAddressChanged,
    required this.onBillingAddressChanged,
    required this.onUseSameAddressChanged,
  }) : super(key: key);

  @override
  State<AddressStepWidget> createState() => _AddressStepWidgetState();
}

class _AddressStepWidgetState extends State<AddressStepWidget> {
  final AddressService _addressService = AddressService();

  @override
  void initState() {
    super.initState();
    
    // Auto-select default address if no address is currently selected
    if (widget.selectedShippingAddress == null && _addressService.hasAddresses) {
      final defaultAddress = _addressService.defaultAddress;
      if (defaultAddress != null) {
        // Use WidgetsBinding to call the callback after the widget is built
        WidgetsBinding.instance.addPostFrameCallback((_) {
          widget.onShippingAddressChanged(defaultAddress);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Shipping Address Section
          _buildSectionTitle(AppLocalizations.of(context)!.shippingAddressTitle),
          if (!_addressService.hasAddresses) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                border: Border.all(color: Colors.red.shade200),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.red.shade600, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context)!.noAddressesMessage,
                      style: TextStyle(
                        color: Colors.red.shade700,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ] else if (widget.selectedShippingAddress == null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                border: Border.all(color: Colors.orange.shade200),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.orange.shade600, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context)!.selectShippingMessage,
                      style: TextStyle(
                        color: Colors.orange.shade700,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 16),
          _buildAddressSelection(
            selectedAddress: widget.selectedShippingAddress,
            onAddressChanged: widget.onShippingAddressChanged,
            isShipping: true,
          ),
          const SizedBox(height: 32),

          // Billing Address Section
          _buildSectionTitle(AppLocalizations.of(context)!.billingAddressTitle),
          const SizedBox(height: 16),
          
          // Same as shipping checkbox
          CheckboxListTile(
            title: Text(AppLocalizations.of(context)!.useSameAddressLabel),
            value: widget.useSameAddressForBilling,
            onChanged: (value) {
              widget.onUseSameAddressChanged(value ?? true);
            },
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
          ),
          
          if (!widget.useSameAddressForBilling) ...[
            const SizedBox(height: 16),
            if (!_addressService.hasAddresses) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  border: Border.all(color: Colors.red.shade200),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red.shade600, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        AppLocalizations.of(context)!.selectBillingMessage,
                        style: TextStyle(
                          color: Colors.red.shade700,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ] else if (widget.selectedBillingAddress == null) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  border: Border.all(color: Colors.orange.shade200),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.orange.shade600, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child:                      Text(
                        AppLocalizations.of(context)!.selectBillingMessage,
                        style: TextStyle(
                          color: Colors.orange.shade700,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
            _buildAddressSelection(
              selectedAddress: widget.selectedBillingAddress,
              onAddressChanged: widget.onBillingAddressChanged,
              isShipping: false,
            ),
          ],

          const SizedBox(height: 32),

          // Add New Address Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                _showAddAddressDialog();
              },
              icon: const Icon(Icons.add),
              label: Text(AppLocalizations.of(context)!.addAddressButton),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
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

  Widget _buildAddressSelection({
    required Address? selectedAddress,
    required Function(Address) onAddressChanged,
    required bool isShipping,
  }) {
    final addresses = _addressService.addresses;
    
    if (addresses.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(
                Icons.location_off,
                size: 48,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context)!.noAddressesMessage,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context)!.selectShippingMessage,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: addresses.map((address) {
        final isSelected = selectedAddress?.id == address.id;
        
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected 
                  ? Theme.of(context).primaryColor
                  : Colors.grey[300]!,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(12),
            color: isSelected 
                ? Theme.of(context).primaryColor.withValues(alpha: 0.05)
                : Colors.white,
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: Radio<Address>(
              value: address,
              groupValue: selectedAddress,
              onChanged: (Address? value) {
                if (value != null) {
                  onAddressChanged(value);
                }
              },
              activeColor: Theme.of(context).primaryColor,
            ),
            title: Row(
              children: [
                Text(
                  address.fullName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                if (address.isDefault) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.defaultLabel,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(
                  address.streetAddress,
                  style: const TextStyle(fontSize: 14),
                ),
                if (address.addressLine2 != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    address.addressLine2!,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
                const SizedBox(height: 4),
                Text(
                  '${address.city}, ${address.state} ${address.zipCode}',
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  address.country,
                  style: const TextStyle(fontSize: 14),
                ),
                if (address.phoneNumber != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    address.phoneNumber!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ],
            ),
            trailing: PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (String action) {
                switch (action) {
                  case 'edit':
                    _showEditAddressDialog(address);
                    break;
                  case 'delete':
                    _showDeleteAddressDialog(address);
                    break;
                }
              },
              itemBuilder: (BuildContext context) => [
                PopupMenuItem(
                  value: 'edit',
                  child: ListTile(
                    leading: const Icon(Icons.edit),
                    title: Text(AppLocalizations.of(context)!.editAction),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: ListTile(
                    leading: const Icon(Icons.delete),
                    title: Text(AppLocalizations.of(context)!.deleteAction),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
            onTap: () {
              onAddressChanged(address);
            },
          ),
        );
      }).toList(),
    );
  }

  void _showAddAddressDialog() {
    showDialog(
      context: context,
      builder: (context) => AddressFormDialog(
        onAddressAdded: (address) {
          setState(() {
            _addressService.addAddress(address);
          });
          // If this was the first address added, auto-select it
          if (_addressService.addresses.length == 1) {
            widget.onShippingAddressChanged(address);
          }
        },
      ),
    );
  }

  void _showEditAddressDialog(Address address) {
    showDialog(
      context: context,
      builder: (context) => AddressFormDialog(
        address: address,
        onAddressAdded: (updatedAddress) {
          setState(() {
            _addressService.updateAddress(updatedAddress);
          });
          // If this was the selected address, update the selection
          if (widget.selectedShippingAddress?.id == address.id) {
            widget.onShippingAddressChanged(updatedAddress);
          }
          if (widget.selectedBillingAddress?.id == address.id) {
            widget.onBillingAddressChanged(updatedAddress);
          }
        },
      ),
    );
  }

  void _showDeleteAddressDialog(Address address) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.deletePaymentMethodTitle),
        content: Text(AppLocalizations.of(context)!.deletePaymentMethodMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancelButton),
          ),
          TextButton(
            onPressed: () {
              final wasSelectedShipping = widget.selectedShippingAddress?.id == address.id;
              final wasSelectedBilling = widget.selectedBillingAddress?.id == address.id;
              
              setState(() {
                _addressService.deleteAddress(address.id);
              });
              
              // Handle address selection updates after deletion
              if (wasSelectedShipping) {
                final newDefault = _addressService.defaultAddress;
                if (newDefault != null) {
                  widget.onShippingAddressChanged(newDefault);
                }
                // If no addresses left, the validation will handle this
              }
              
              if (wasSelectedBilling && !widget.useSameAddressForBilling) {
                final newDefault = _addressService.defaultAddress;
                if (newDefault != null) {
                  widget.onBillingAddressChanged(newDefault);
                }
              }
              
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context)!.deleteAction),
          ),
        ],
      ),
    );
  }
}

class AddressFormDialog extends StatefulWidget {
  final Address? address;
  final Function(Address) onAddressAdded;

  const AddressFormDialog({
    Key? key,
    this.address,
    required this.onAddressAdded,
  }) : super(key: key);

  @override
  State<AddressFormDialog> createState() => _AddressFormDialogState();
}

class _AddressFormDialogState extends State<AddressFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _streetController = TextEditingController();
  final _addressLine2Controller = TextEditingController();
  final _cityController = TextEditingController();
  final _zipCodeController = TextEditingController();
  final _phoneController = TextEditingController();
  
  String _selectedCountry = '';
  String? _selectedState;
  bool _isDefault = false;
  bool _showStateDropdown = true;

  @override
  void initState() {
    super.initState();
    
    // Initialize the default country to the localized "United States"
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final countries = AddressValidationService.getLocalizedCountries(context);
      final usCountry = countries.firstWhere(
        (country) => country['code'] == 'US',
        orElse: () => countries.first,
      );
      
      if (widget.address != null) {
        // Find the localized name for the existing country
        final existingCountry = countries.firstWhere(
          (country) => country['name'] == widget.address!.country ||
                      country['code'] == _getCountryCodeFromName(widget.address!.country),
          orElse: () => usCountry,
        );
        
        _nameController.text = widget.address!.fullName;
        _streetController.text = widget.address!.streetAddress;
        _addressLine2Controller.text = widget.address!.addressLine2 ?? '';
        _cityController.text = widget.address!.city;
        _zipCodeController.text = widget.address!.zipCode;
        _selectedCountry = existingCountry['name']!;
        _selectedState = widget.address!.state;
        _phoneController.text = widget.address!.phoneNumber ?? '';
        _isDefault = widget.address!.isDefault;
      } else {
        _selectedCountry = usCountry['name']!;
        _selectedState = null;
      }
      
      // Set whether state should be shown as dropdown based on country
      _showStateDropdown = AddressValidationService.hasStatesForCountry(_selectedCountry);
      
      setState(() {});
    });
  }

  // Helper method to get country code from legacy country name
  String _getCountryCodeFromName(String countryName) {
    const legacyToCodeMap = {
      'United States': 'US',
      'Canada': 'CA',
      'United Kingdom': 'GB',
      'Australia': 'AU',
      'Germany': 'DE',
      'France': 'FR',
      'Spain': 'ES',
      'Italy': 'IT',
      'Japan': 'JP',
      'China': 'CN',
      'India': 'IN',
      'Brazil': 'BR',
      'Mexico': 'MX',
      'South Korea': 'KR',
      'Russia': 'RU',
    };
    return legacyToCodeMap[countryName] ?? 'US';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _streetController.dispose();
    _addressLine2Controller.dispose();
    _cityController.dispose();
    _zipCodeController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.address == null ? AppLocalizations.of(context)!.addAddressButton : AppLocalizations.of(context)!.editAddressButton),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.fullNameLabel,
                  border: const OutlineInputBorder(),
                ),
                validator: (value) => AddressValidationService.validateFullName(value, context),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _streetController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.streetAddressLabel,
                  border: const OutlineInputBorder(),
                ),
                validator: (value) => AddressValidationService.validateStreetAddress(value, context),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressLine2Controller,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.addressLine2Label,
                  border: const OutlineInputBorder(),
                ),
                validator: AddressValidationService.validateAddressLine2,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      controller: _cityController,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.cityLabel,
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) => AddressValidationService.validateCity(value, context),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: _showStateDropdown 
                      ? DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.stateLabel,
                            border: const OutlineInputBorder(),
                          ),
                          value: _selectedState,
                          isExpanded: true, // Prevent overflow
                          items: AddressValidationService.getStatesForCountry(_selectedCountry)
                              .map((state) => DropdownMenuItem(
                                    value: state,
                                    child: Text(
                                      state,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ))
                              .toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _selectedState = newValue;
                            });
                          },
                          validator: (value) => AddressValidationService.validateState(value, _selectedCountry, context),
                        )
                      : TextFormField(
                          initialValue: _selectedState,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.stateProvinceLabel,
                            border: const OutlineInputBorder(),
                            labelStyle: const TextStyle(fontSize: 12), // Smaller label for long text
                          ),
                          onChanged: (newValue) {
                            setState(() {
                              _selectedState = newValue;
                            });
                          },
                          validator: (value) => AddressValidationService.validateState(value, _selectedCountry, context),
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _zipCodeController,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.zipCodeLabel,
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) => AddressValidationService.validateZipCode(value, _selectedCountry, context),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 3,
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.countryLabel,
                        border: const OutlineInputBorder(),
                      ),
                      value: _selectedCountry.isEmpty ? null : _selectedCountry,
                      isExpanded: true, // Prevent overflow
                      items: AddressValidationService.getLocalizedCountries(context)
                          .map((country) => DropdownMenuItem(
                                value: country['name']!,
                                child: Text(
                                  country['name']!,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ))
                          .toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedCountry = newValue!;
                          // Reset state if country changes
                          _selectedState = null;
                          _showStateDropdown = AddressValidationService.hasStatesForCountry(_selectedCountry);
                        });
                      },
                      validator: (value) => AddressValidationService.validateCountry(value, context),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.phoneNumberLabel,
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              CheckboxListTile(
                title: Text(AppLocalizations.of(context)!.defaultAddressLabel),
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
          child: Text(AppLocalizations.of(context)!.cancelButton),
        ),
        ElevatedButton(
          onPressed: _saveAddress,
          child: Text(AppLocalizations.of(context)!.saveButton),
        ),
      ],
    );
  }

  void _saveAddress() {
    if (_formKey.currentState!.validate()) {
      final address = Address(
        id: widget.address?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        fullName: _nameController.text,
        streetAddress: _streetController.text,
        addressLine2: _addressLine2Controller.text.isEmpty ? null : _addressLine2Controller.text,
        city: _cityController.text,
        state: _selectedState ?? '',
        zipCode: _zipCodeController.text,
        country: _selectedCountry,
        phoneNumber: _phoneController.text.isEmpty ? null : _phoneController.text,
        isDefault: _isDefault,
      );

      widget.onAddressAdded(address);
      Navigator.pop(context);
    }
  }
}
