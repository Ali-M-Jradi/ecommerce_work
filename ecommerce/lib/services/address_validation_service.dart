import 'package:flutter/material.dart';
import '../localization/app_localizations_helper.dart';

class AddressValidationService {
  // List of all country codes - comprehensive list of all UN member states
  static const List<String> validCountryCodes = [
    'AF', 'AL', 'DZ', 'AD', 'AO', 'AG', 'AR', 'AM', 'AU', 'AT',
    'AZ', 'BS', 'BH', 'BD', 'BB', 'BY', 'BE', 'BZ', 'BJ', 'BT',
    'BO', 'BA', 'BW', 'BR', 'BN', 'BG', 'BF', 'BI', 'CV', 'KH',
    'CM', 'CA', 'CF', 'TD', 'CL', 'CN', 'CO', 'KM', 'CG', 'CD',
    'CR', 'CI', 'HR', 'CU', 'CY', 'CZ', 'DK', 'DJ', 'DM', 'DO',
    'EC', 'EG', 'SV', 'GQ', 'ER', 'EE', 'ET', 'FJ', 'FI', 'FR',
    'GA', 'GM', 'GE', 'DE', 'GH', 'GR', 'GD', 'GT', 'GN', 'GW',
    'GY', 'HT', 'HN', 'HU', 'IS', 'IN', 'ID', 'IR', 'IQ', 'IE',
    'IL', 'IT', 'JM', 'JP', 'JO', 'KZ', 'KE', 'KI', 'KW', 'KG',
    'LA', 'LV', 'LB', 'LS', 'LR', 'LY', 'LI', 'LT', 'LU', 'MK',
    'MG', 'MW', 'MY', 'MV', 'ML', 'MT', 'MH', 'MR', 'MU', 'MX',
    'FM', 'MD', 'MC', 'MN', 'ME', 'MA', 'MZ', 'MM', 'NA', 'NR',
    'NP', 'NL', 'NZ', 'NI', 'NE', 'NG', 'KP', 'NO', 'OM', 'PK',
    'PW', 'PA', 'PG', 'PY', 'PE', 'PH', 'PL', 'PT', 'QA', 'RO',
    'RU', 'RW', 'KN', 'LC', 'VC', 'WS', 'SM', 'ST', 'SA', 'SN',
    'RS', 'SC', 'SL', 'SG', 'SK', 'SI', 'SB', 'SO', 'ZA', 'KR',
    'SS', 'ES', 'LK', 'SD', 'SR', 'SZ', 'SE', 'CH', 'SY', 'TW',
    'TJ', 'TZ', 'TH', 'TL', 'TG', 'TO', 'TT', 'TN', 'TR', 'TM',
    'TV', 'UG', 'UA', 'AE', 'GB', 'US', 'UY', 'UZ', 'VU', 'VA',
    'VE', 'VN', 'YE', 'ZM', 'ZW'
  ];



  // Get localized country names for dropdown
  static List<Map<String, String>> getLocalizedCountries(BuildContext context) {
    // Define country mappings
    final countryMappings = <String, Map<String, String>>{
      'AF': {'en': 'Afghanistan', 'ar': 'أفغانستان'},
      'AL': {'en': 'Albania', 'ar': 'ألبانيا'},
      'DZ': {'en': 'Algeria', 'ar': 'الجزائر'},
      'AD': {'en': 'Andorra', 'ar': 'أندورا'},
      'AO': {'en': 'Angola', 'ar': 'أنغولا'},
      'AG': {'en': 'Antigua and Barbuda', 'ar': 'أنتيغوا وبربودا'},
      'AR': {'en': 'Argentina', 'ar': 'الأرجنتين'},
      'AM': {'en': 'Armenia', 'ar': 'أرمينيا'},
      'AU': {'en': 'Australia', 'ar': 'أستراليا'},
      'AT': {'en': 'Austria', 'ar': 'النمسا'},
      'AZ': {'en': 'Azerbaijan', 'ar': 'أذربيجان'},
      'BS': {'en': 'Bahamas', 'ar': 'جزر البهاما'},
      'BH': {'en': 'Bahrain', 'ar': 'البحرين'},
      'BD': {'en': 'Bangladesh', 'ar': 'بنغلاديش'},
      'BB': {'en': 'Barbados', 'ar': 'بربادوس'},
      'BY': {'en': 'Belarus', 'ar': 'بيلاروس'},
      'BE': {'en': 'Belgium', 'ar': 'بلجيكا'},
      'BZ': {'en': 'Belize', 'ar': 'بليز'},
      'BJ': {'en': 'Benin', 'ar': 'بنين'},
      'BT': {'en': 'Bhutan', 'ar': 'بوتان'},
      'BO': {'en': 'Bolivia', 'ar': 'بوليفيا'},
      'BA': {'en': 'Bosnia and Herzegovina', 'ar': 'البوسنة والهرسك'},
      'BW': {'en': 'Botswana', 'ar': 'بوتسوانا'},
      'BR': {'en': 'Brazil', 'ar': 'البرازيل'},
      'BN': {'en': 'Brunei', 'ar': 'بروناي'},
      'BG': {'en': 'Bulgaria', 'ar': 'بلغاريا'},
      'BF': {'en': 'Burkina Faso', 'ar': 'بوركينا فاسو'},
      'BI': {'en': 'Burundi', 'ar': 'بوروندي'},
      'CV': {'en': 'Cabo Verde', 'ar': 'الرأس الأخضر'},
      'KH': {'en': 'Cambodia', 'ar': 'كمبوديا'},
      'CM': {'en': 'Cameroon', 'ar': 'الكاميرون'},
      'CA': {'en': 'Canada', 'ar': 'كندا'},
      'CF': {'en': 'Central African Republic', 'ar': 'جمهورية أفريقيا الوسطى'},
      'TD': {'en': 'Chad', 'ar': 'تشاد'},
      'CL': {'en': 'Chile', 'ar': 'تشيلي'},
      'CN': {'en': 'China', 'ar': 'الصين'},
      'CO': {'en': 'Colombia', 'ar': 'كولومبيا'},
      'KM': {'en': 'Comoros', 'ar': 'جزر القمر'},
      'CG': {'en': 'Congo', 'ar': 'الكونغو'},
      'CD': {'en': 'Congo (Democratic Republic)', 'ar': 'جمهورية الكونغو الديمقراطية'},
      'CR': {'en': 'Costa Rica', 'ar': 'كوستاريكا'},
      'CI': {'en': 'Côte d\'Ivoire', 'ar': 'كوت ديفوار'},
      'HR': {'en': 'Croatia', 'ar': 'كرواتيا'},
      'CU': {'en': 'Cuba', 'ar': 'كوبا'},
      'CY': {'en': 'Cyprus', 'ar': 'قبرص'},
      'CZ': {'en': 'Czech Republic', 'ar': 'جمهورية التشيك'},
      'DK': {'en': 'Denmark', 'ar': 'الدنمارك'},
      'DJ': {'en': 'Djibouti', 'ar': 'جيبوتي'},
      'DM': {'en': 'Dominica', 'ar': 'دومينيكا'},
      'DO': {'en': 'Dominican Republic', 'ar': 'جمهورية الدومينيكان'},
      'EC': {'en': 'Ecuador', 'ar': 'الإكوادور'},
      'EG': {'en': 'Egypt', 'ar': 'مصر'},
      'SV': {'en': 'El Salvador', 'ar': 'السلفادور'},
      'GQ': {'en': 'Equatorial Guinea', 'ar': 'غينيا الاستوائية'},
      'ER': {'en': 'Eritrea', 'ar': 'إريتريا'},
      'EE': {'en': 'Estonia', 'ar': 'إستونيا'},
      'ET': {'en': 'Ethiopia', 'ar': 'إثيوبيا'},
      'FJ': {'en': 'Fiji', 'ar': 'فيجي'},
      'FI': {'en': 'Finland', 'ar': 'فنلندا'},
      'FR': {'en': 'France', 'ar': 'فرنسا'},
      'GA': {'en': 'Gabon', 'ar': 'الغابون'},
      'GM': {'en': 'Gambia', 'ar': 'غامبيا'},
      'GE': {'en': 'Georgia', 'ar': 'جورجيا'},
      'DE': {'en': 'Germany', 'ar': 'ألمانيا'},
      'GH': {'en': 'Ghana', 'ar': 'غانا'},
      'GR': {'en': 'Greece', 'ar': 'اليونان'},
      'GD': {'en': 'Grenada', 'ar': 'غرينادا'},
      'GT': {'en': 'Guatemala', 'ar': 'غواتيمالا'},
      'GN': {'en': 'Guinea', 'ar': 'غينيا'},
      'GW': {'en': 'Guinea-Bissau', 'ar': 'غينيا بيساو'},
      'GY': {'en': 'Guyana', 'ar': 'غيانا'},
      'HT': {'en': 'Haiti', 'ar': 'هايتي'},
      'HN': {'en': 'Honduras', 'ar': 'هندوراس'},
      'HU': {'en': 'Hungary', 'ar': 'المجر'},
      'IS': {'en': 'Iceland', 'ar': 'آيسلندا'},
      'IN': {'en': 'India', 'ar': 'الهند'},
      'ID': {'en': 'Indonesia', 'ar': 'إندونيسيا'},
      'IR': {'en': 'Iran', 'ar': 'إيران'},
      'IQ': {'en': 'Iraq', 'ar': 'العراق'},
      'IE': {'en': 'Ireland', 'ar': 'أيرلندا'},
      'IL': {'en': 'Israel', 'ar': 'إسرائيل'},
      'IT': {'en': 'Italy', 'ar': 'إيطاليا'},
      'JM': {'en': 'Jamaica', 'ar': 'جامايكا'},
      'JP': {'en': 'Japan', 'ar': 'اليابان'},
      'JO': {'en': 'Jordan', 'ar': 'الأردن'},
      'KZ': {'en': 'Kazakhstan', 'ar': 'كازاخستان'},
      'KE': {'en': 'Kenya', 'ar': 'كينيا'},
      'KI': {'en': 'Kiribati', 'ar': 'كيريباتي'},
      'KW': {'en': 'Kuwait', 'ar': 'الكويت'},
      'KG': {'en': 'Kyrgyzstan', 'ar': 'قيرغيزستان'},
      'LA': {'en': 'Laos', 'ar': 'لاوس'},
      'LV': {'en': 'Latvia', 'ar': 'لاتفيا'},
      'LB': {'en': 'Lebanon', 'ar': 'لبنان'},
      'LS': {'en': 'Lesotho', 'ar': 'ليسوتو'},
      'LR': {'en': 'Liberia', 'ar': 'ليبيريا'},
      'LY': {'en': 'Libya', 'ar': 'ليبيا'},
      'LI': {'en': 'Liechtenstein', 'ar': 'ليختنشتاين'},
      'LT': {'en': 'Lithuania', 'ar': 'ليتوانيا'},
      'LU': {'en': 'Luxembourg', 'ar': 'لوكسمبورغ'},
      'MK': {'en': 'North Macedonia', 'ar': 'مقدونيا الشمالية'},
      'MG': {'en': 'Madagascar', 'ar': 'مدغشقر'},
      'MW': {'en': 'Malawi', 'ar': 'ملاوي'},
      'MY': {'en': 'Malaysia', 'ar': 'ماليزيا'},
      'MV': {'en': 'Maldives', 'ar': 'جزر المالديف'},
      'ML': {'en': 'Mali', 'ar': 'مالي'},
      'MT': {'en': 'Malta', 'ar': 'مالطا'},
      'MH': {'en': 'Marshall Islands', 'ar': 'جزر مارشال'},
      'MR': {'en': 'Mauritania', 'ar': 'موريتانيا'},
      'MU': {'en': 'Mauritius', 'ar': 'موريشيوس'},
      'MX': {'en': 'Mexico', 'ar': 'المكسيك'},
      'FM': {'en': 'Micronesia', 'ar': 'ميكرونيزيا'},
      'MD': {'en': 'Moldova', 'ar': 'مولدوفا'},
      'MC': {'en': 'Monaco', 'ar': 'موناكو'},
      'MN': {'en': 'Mongolia', 'ar': 'منغوليا'},
      'ME': {'en': 'Montenegro', 'ar': 'الجبل الأسود'},
      'MA': {'en': 'Morocco', 'ar': 'المغرب'},
      'MZ': {'en': 'Mozambique', 'ar': 'موزمبيق'},
      'MM': {'en': 'Myanmar', 'ar': 'ميانمار'},
      'NA': {'en': 'Namibia', 'ar': 'ناميبيا'},
      'NR': {'en': 'Nauru', 'ar': 'ناورو'},
      'NP': {'en': 'Nepal', 'ar': 'نيبال'},
      'NL': {'en': 'Netherlands', 'ar': 'هولندا'},
      'NZ': {'en': 'New Zealand', 'ar': 'نيوزيلندا'},
      'NI': {'en': 'Nicaragua', 'ar': 'نيكاراغوا'},
      'NE': {'en': 'Niger', 'ar': 'النيجر'},
      'NG': {'en': 'Nigeria', 'ar': 'نيجيريا'},
      'KP': {'en': 'North Korea', 'ar': 'كوريا الشمالية'},
      'NO': {'en': 'Norway', 'ar': 'النرويج'},
      'OM': {'en': 'Oman', 'ar': 'عُمان'},
      'PK': {'en': 'Pakistan', 'ar': 'باكستان'},
      'PW': {'en': 'Palau', 'ar': 'بالاو'},
      'PA': {'en': 'Panama', 'ar': 'بنما'},
      'PG': {'en': 'Papua New Guinea', 'ar': 'بابوا غينيا الجديدة'},
      'PY': {'en': 'Paraguay', 'ar': 'باراغواي'},
      'PE': {'en': 'Peru', 'ar': 'بيرو'},
      'PH': {'en': 'Philippines', 'ar': 'الفلبين'},
      'PL': {'en': 'Poland', 'ar': 'بولندا'},
      'PT': {'en': 'Portugal', 'ar': 'البرتغال'},
      'QA': {'en': 'Qatar', 'ar': 'قطر'},
      'RO': {'en': 'Romania', 'ar': 'رومانيا'},
      'RU': {'en': 'Russia', 'ar': 'روسيا'},
      'RW': {'en': 'Rwanda', 'ar': 'رواندا'},
      'KN': {'en': 'Saint Kitts and Nevis', 'ar': 'سانت كيتس ونيفيس'},
      'LC': {'en': 'Saint Lucia', 'ar': 'سانت لوسيا'},
      'VC': {'en': 'Saint Vincent and the Grenadines', 'ar': 'سانت فنسنت والغرينادين'},
      'WS': {'en': 'Samoa', 'ar': 'ساموا'},
      'SM': {'en': 'San Marino', 'ar': 'سان مارينو'},
      'ST': {'en': 'São Tomé and Príncipe', 'ar': 'ساو تومي وبرينسيبي'},
      'SA': {'en': 'Saudi Arabia', 'ar': 'المملكة العربية السعودية'},
      'SN': {'en': 'Senegal', 'ar': 'السنغال'},
      'RS': {'en': 'Serbia', 'ar': 'صربيا'},
      'SC': {'en': 'Seychelles', 'ar': 'سيشل'},
      'SL': {'en': 'Sierra Leone', 'ar': 'سيراليون'},
      'SG': {'en': 'Singapore', 'ar': 'سنغافورة'},
      'SK': {'en': 'Slovakia', 'ar': 'سلوفاكيا'},
      'SI': {'en': 'Slovenia', 'ar': 'سلوفينيا'},
      'SB': {'en': 'Solomon Islands', 'ar': 'جزر سليمان'},
      'SO': {'en': 'Somalia', 'ar': 'الصومال'},
      'ZA': {'en': 'South Africa', 'ar': 'جنوب أفريقيا'},
      'KR': {'en': 'South Korea', 'ar': 'كوريا الجنوبية'},
      'SS': {'en': 'South Sudan', 'ar': 'جنوب السودان'},
      'ES': {'en': 'Spain', 'ar': 'إسبانيا'},
      'LK': {'en': 'Sri Lanka', 'ar': 'سريلانكا'},
      'SD': {'en': 'Sudan', 'ar': 'السودان'},
      'SR': {'en': 'Suriname', 'ar': 'سورينام'},
      'SZ': {'en': 'Eswatini', 'ar': 'إسواتيني'},
      'SE': {'en': 'Sweden', 'ar': 'السويد'},
      'CH': {'en': 'Switzerland', 'ar': 'سويسرا'},
      'SY': {'en': 'Syria', 'ar': 'سوريا'},
      'TW': {'en': 'Taiwan', 'ar': 'تايوان'},
      'TJ': {'en': 'Tajikistan', 'ar': 'طاجيكستان'},
      'TZ': {'en': 'Tanzania', 'ar': 'تنزانيا'},
      'TH': {'en': 'Thailand', 'ar': 'تايلاند'},
      'TL': {'en': 'Timor-Leste', 'ar': 'تيمور الشرقية'},
      'TG': {'en': 'Togo', 'ar': 'توغو'},
      'TO': {'en': 'Tonga', 'ar': 'تونغا'},
      'TT': {'en': 'Trinidad and Tobago', 'ar': 'ترينيداد وتوباغو'},
      'TN': {'en': 'Tunisia', 'ar': 'تونس'},
      'TR': {'en': 'Turkey', 'ar': 'تركيا'},
      'TM': {'en': 'Turkmenistan', 'ar': 'تركمانستان'},
      'TV': {'en': 'Tuvalu', 'ar': 'توفالو'},
      'UG': {'en': 'Uganda', 'ar': 'أوغندا'},
      'UA': {'en': 'Ukraine', 'ar': 'أوكرانيا'},
      'AE': {'en': 'United Arab Emirates', 'ar': 'الإمارات العربية المتحدة'},
      'GB': {'en': 'United Kingdom', 'ar': 'المملكة المتحدة'},
      'US': {'en': 'United States', 'ar': 'الولايات المتحدة'},
      'UY': {'en': 'Uruguay', 'ar': 'أوروغواي'},
      'UZ': {'en': 'Uzbekistan', 'ar': 'أوزبكستان'},
      'VU': {'en': 'Vanuatu', 'ar': 'فانواتو'},
      'VA': {'en': 'Vatican City', 'ar': 'مدينة الفاتيكان'},
      'VE': {'en': 'Venezuela', 'ar': 'فنزويلا'},
      'VN': {'en': 'Vietnam', 'ar': 'فيتنام'},
      'YE': {'en': 'Yemen', 'ar': 'اليمن'},
      'ZM': {'en': 'Zambia', 'ar': 'زامبيا'},
      'ZW': {'en': 'Zimbabwe', 'ar': 'زيمبابوي'},
    };

    // Get current locale
    final locale = Localizations.localeOf(context);
    final languageCode = locale.languageCode;
    
    // Generate localized country list
    final localizedCountries = countryMappings.entries.map((entry) {
      final code = entry.key;
      final names = entry.value;
      final localizedName = names[languageCode] ?? names['en'] ?? code;
      
      return {
        'code': code,
        'name': localizedName,
      };
    }).toList();
    
    // Sort alphabetically by localized name
    localizedCountries.sort((a, b) => a['name']!.compareTo(b['name']!));
    
    return localizedCountries;
  }



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

  static String? validateFullName(String? value, [BuildContext? context]) {
    if (value == null || value.trim().isEmpty) {
      return context != null 
        ? "${AppLocalizationsHelper.of(context).fullNameLabel} ${AppLocalizationsHelper.of(context).requiredField.toLowerCase()}"
        : 'Full name is required';
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

  static String? validateStreetAddress(String? value, [BuildContext? context]) {
    if (value == null || value.trim().isEmpty) {
      return context != null 
        ? "${AppLocalizationsHelper.of(context).streetAddressLabel} ${AppLocalizationsHelper.of(context).requiredField.toLowerCase()}"
        : 'Street address is required';
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

  static String? validateCity(String? value, [BuildContext? context]) {
    if (value == null || value.trim().isEmpty) {
      return context != null 
        ? "${AppLocalizationsHelper.of(context).cityLabel} ${AppLocalizationsHelper.of(context).requiredField.toLowerCase()}"
        : 'City is required';
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

  static String? validateState(String? value, String country, [BuildContext? context]) {
    if (value == null || value.trim().isEmpty) {
      return context != null 
        ? "${AppLocalizationsHelper.of(context).stateLabel} ${AppLocalizationsHelper.of(context).requiredField.toLowerCase()}"
        : 'State/Province is required';
    }
    
    final trimmed = value.trim();
    final normalizedCountry = _normalizeCountryName(country);
    
    // Validate based on country
    if (normalizedCountry == 'United States') {
      if (!usStates.contains(trimmed)) {
        return 'Please select a valid US state';
      }
    } else if (normalizedCountry == 'Canada') {
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

  // Helper method to normalize country names to English for validation
  static String _normalizeCountryName(String country) {
    const countryNormalizationMap = {
      'الولايات المتحدة': 'United States',
      'كندا': 'Canada', 
      'المملكة المتحدة': 'United Kingdom',
      'أستراليا': 'Australia',
      'ألمانيا': 'Germany',
      'فرنسا': 'France',
    };
    return countryNormalizationMap[country] ?? country;
  }

  static String? validateZipCode(String? value, String country, [BuildContext? context]) {
    if (value == null || value.trim().isEmpty) {
      return context != null 
        ? AppLocalizationsHelper.of(context).zipCodeRequired
        : 'ZIP/Postal code is required';
    }
    
    final trimmed = value.trim().toUpperCase();
    final normalizedCountry = _normalizeCountryName(country);
    
    // Validate based on country
    switch (normalizedCountry) {
      case 'United States':
        // US ZIP code: 12345 or 12345-6789
        if (!RegExp(r'^\d{5}(-\d{4})?$').hasMatch(trimmed)) {
          return context != null 
            ? AppLocalizationsHelper.of(context).zipCodeInvalidUS
            : 'US ZIP code must be in format 12345 or 12345-6789';
        }
        break;
      case 'Canada':
        // Canadian postal code: A1A 1A1
        if (!RegExp(r'^[A-Z]\d[A-Z] \d[A-Z]\d$').hasMatch(trimmed)) {
          return context != null 
            ? AppLocalizationsHelper.of(context).zipCodeInvalidCanada
            : 'Canadian postal code must be in format A1A 1A1';
        }
        break;
      case 'United Kingdom':
        // UK postal code: various formats
        if (!RegExp(r'^[A-Z]{1,2}\d[A-Z\d]? \d[A-Z]{2}$').hasMatch(trimmed)) {
          return context != null 
            ? AppLocalizationsHelper.of(context).zipCodeInvalidUK
            : 'UK postal code must be in valid format (e.g., SW1A 1AA)';
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

  static String? validateCountry(String? value, [BuildContext? context]) {
    if (value == null || value.trim().isEmpty) {
      return context != null 
        ? "${AppLocalizationsHelper.of(context).countryLabel} ${AppLocalizationsHelper.of(context).requiredField.toLowerCase()}"
        : 'Country is required';
    }
    
    final trimmed = value.trim();
    
    // Check if country exists in our mapping
    if (context != null) {
      final countries = getLocalizedCountries(context);
      final isValid = countries.any((country) => country['name'] == trimmed);
      if (!isValid) {
        return AppLocalizationsHelper.of(context).countryInvalid;
      }
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
    final normalizedCountry = _normalizeCountryName(country);
    // Check if it's the English name
    if (normalizedCountry == 'United States') {
      return usStates;
    }
    if (normalizedCountry == 'Canada') {
      return canadianProvinces;
    }
    return [];
  }

  static bool hasStatesForCountry(String country) {
    final normalizedCountry = _normalizeCountryName(country);
    // Check if it's the English name for US or Canada
    return normalizedCountry == 'United States' || normalizedCountry == 'Canada';
  }
}
