class AddressValidationService {
  // List of common countries for the dropdown - organized for usability
  static const List<String> validCountries = [
    'United States', 
    'Canada',
    'United Kingdom',
    'Australia',
    'Germany',
    'France',
    'Spain',
    'Italy',
    'Japan',
    'China',
    'India',
    'Brazil',
    'Mexico',
    'South Korea',
    'Russia',
    'Netherlands',
    'Singapore',
    'Sweden',
    'Switzerland',
    'Belgium',
    'Austria',
    'Portugal',
    'Norway',
    'Denmark',
    'Finland',
    'Ireland',
    'New Zealand',
    'Israel',
    'South Africa',
    'UAE',
    'Argentina',
    'Chile',
    'Hong Kong',
    'Malaysia',
    'Philippines',
    'Thailand',
    'Vietnam',
    'Indonesia',
    'Poland',
    'Greece',
    'Turkey',
  ];

  // US States
  static const List<String> usStates = [
    'Alabama', 'Alaska', 'Arizona', 'Arkansas', 'California', 'Colorado',
    'Connecticut', 'Delaware', 'Florida', 'Georgia', 'Hawaii', 'Idaho',
    'Illinois', 'Indiana', 'Iowa', 'Kansas', 'Kentucky', 'Louisiana',
    'Maine', 'Maryland', 'Massachusetts', 'Michigan', 'Minnesota',
    'Mississippi', 'Missouri', 'Montana', 'Nebraska', 'Nevada',
    'New Hampshire', 'New Jersey', 'New Mexico', 'New York',
    'North Carolina', 'North Dakota', 'Ohio', 'Oklahoma', 'Oregon',
    'Pennsylvania', 'Rhode Island', 'South Carolina', 'South Dakota',
    'Tennessee', 'Texas', 'Utah', 'Vermont', 'Virginia', 'Washington',
    'West Virginia', 'Wisconsin', 'Wyoming', 'DC',
  ];

  // Canadian Provinces
  static const List<String> canadianProvinces = [
    'Alberta', 'British Columbia', 'Manitoba', 'New Brunswick',
    'Newfoundland and Labrador', 'Northwest Territories', 'Nova Scotia',
    'Nunavut', 'Ontario', 'Prince Edward Island', 'Quebec', 'Saskatchewan',
    'Yukon',
  ];

  static String? validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Full name is required';
    }
    
    final trimmed = value.trim();
    if (trimmed.length < 2) {
      return 'Full name must be at least 2 characters';
    }
    
    if (trimmed.length > 50) {
      return 'Full name must be less than 50 characters';
    }
    
    // Check for valid characters (letters, spaces, hyphens, apostrophes)
    if (!RegExp(r"^[a-zA-Z\s\-'\.]+$").hasMatch(trimmed)) {
      return 'Full name can only contain letters, spaces, hyphens, and apostrophes';
    }
    
    // Check for at least first and last name
    if (!trimmed.contains(' ')) {
      return 'Please enter both first and last name';
    }
    
    return null;
  }

  static String? validateStreetAddress(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Street address is required';
    }
    
    final trimmed = value.trim();
    if (trimmed.length < 5) {
      return 'Street address must be at least 5 characters';
    }
    
    if (trimmed.length > 100) {
      return 'Street address must be less than 100 characters';
    }
    
    // Check for valid characters (letters, numbers, spaces, common punctuation)
    if (!RegExp(r"^[a-zA-Z0-9\s\-',\.#/]+$").hasMatch(trimmed)) {
      return 'Street address contains invalid characters';
    }
    
    return null;
  }

  static String? validateCity(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'City is required';
    }
    
    final trimmed = value.trim();
    if (trimmed.length < 2) {
      return 'City name must be at least 2 characters';
    }
    
    if (trimmed.length > 50) {
      return 'City name must be less than 50 characters';
    }
    
    // Check for valid characters (letters, spaces, hyphens, apostrophes)
    if (!RegExp(r"^[a-zA-Z\s\-'\.]+$").hasMatch(trimmed)) {
      return 'City name can only contain letters, spaces, hyphens, and apostrophes';
    }
    
    return null;
  }

  static String? validateState(String? value, String country) {
    if (value == null || value.trim().isEmpty) {
      return 'State/Province is required';
    }
    
    final trimmed = value.trim();
    
    // Validate based on country
    if (country == 'United States') {
      if (!usStates.contains(trimmed)) {
        return 'Please select a valid US state';
      }
    } else if (country == 'Canada') {
      if (!canadianProvinces.contains(trimmed)) {
        return 'Please select a valid Canadian province';
      }
    } else {
      // For other countries, just check basic format
      if (trimmed.length < 2) {
        return 'State/Province must be at least 2 characters';
      }
      if (trimmed.length > 50) {
        return 'State/Province must be less than 50 characters';
      }
      if (!RegExp(r"^[a-zA-Z\s\-'\.]+$").hasMatch(trimmed)) {
        return 'State/Province can only contain letters, spaces, hyphens, and apostrophes';
      }
    }
    
    return null;
  }

  static String? validateZipCode(String? value, String country) {
    if (value == null || value.trim().isEmpty) {
      return 'ZIP/Postal code is required';
    }
    
    final trimmed = value.trim().toUpperCase();
    
    // Validate based on country
    switch (country) {
      case 'United States':
        // US ZIP code: 12345 or 12345-6789
        if (!RegExp(r'^\d{5}(-\d{4})?$').hasMatch(trimmed)) {
          return 'US ZIP code must be in format 12345 or 12345-6789';
        }
        break;
      case 'Canada':
        // Canadian postal code: A1A 1A1
        if (!RegExp(r'^[A-Z]\d[A-Z] \d[A-Z]\d$').hasMatch(trimmed)) {
          return 'Canadian postal code must be in format A1A 1A1';
        }
        break;
      case 'United Kingdom':
        // UK postal code: various formats
        if (!RegExp(r'^[A-Z]{1,2}\d[A-Z\d]? \d[A-Z]{2}$').hasMatch(trimmed)) {
          return 'UK postal code must be in valid format (e.g., SW1A 1AA)';
        }
        break;
      case 'Germany':
        // German postal code: 12345
        if (!RegExp(r'^\d{5}$').hasMatch(trimmed)) {
          return 'German postal code must be 5 digits';
        }
        break;
      case 'France':
        // French postal code: 12345
        if (!RegExp(r'^\d{5}$').hasMatch(trimmed)) {
          return 'French postal code must be 5 digits';
        }
        break;
      case 'Australia':
        // Australian postal code: 1234
        if (!RegExp(r'^\d{4}$').hasMatch(trimmed)) {
          return 'Australian postal code must be 4 digits';
        }
        break;
      default:
        // General validation for other countries
        if (trimmed.length < 3 || trimmed.length > 10) {
          return 'Postal code must be between 3 and 10 characters';
        }
        if (!RegExp(r'^[A-Z0-9\s\-]+$').hasMatch(trimmed)) {
          return 'Postal code can only contain letters, numbers, spaces, and hyphens';
        }
    }
    
    return null;
  }

  static String? validateCountry(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Country is required';
    }
    
    final trimmed = value.trim();
    if (!validCountries.contains(trimmed)) {
      return 'Please select a valid country';
    }
    
    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Phone is optional
    }
    
    final trimmed = value.trim();
    
    // Remove common formatting characters
    final cleaned = trimmed.replaceAll(RegExp(r'[\s\-\(\)\+]'), '');
    
    // Check if it's all digits (after removing formatting)
    if (!RegExp(r'^\d+$').hasMatch(cleaned)) {
      return 'Phone number can only contain digits and formatting characters';
    }
    
    // Check length (international numbers can be 7-15 digits)
    if (cleaned.length < 7 || cleaned.length > 15) {
      return 'Phone number must be between 7 and 15 digits';
    }
    
    return null;
  }

  static String? validateAddressLine2(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Address line 2 is optional
    }
    
    final trimmed = value.trim();
    if (trimmed.length > 100) {
      return 'Address line 2 must be less than 100 characters';
    }
    
    // Check for valid characters (letters, numbers, spaces, common punctuation)
    if (!RegExp(r"^[a-zA-Z0-9\s\-',\.#/]+$").hasMatch(trimmed)) {
      return 'Address line 2 contains invalid characters';
    }
    
    return null;
  }

  static List<String> getStatesForCountry(String country) {
    switch (country) {
      case 'United States':
        return usStates;
      case 'Canada':
        return canadianProvinces;
      default:
        return [];
    }
  }

  static bool hasStatesForCountry(String country) {
    return country == 'United States' || country == 'Canada';
  }
}
