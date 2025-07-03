// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get ecommerceAppTitle => 'تطبيق التجارة الإلكترونية';

  @override
  String get checkoutTitle => 'إتمام الشراء';

  @override
  String get addressStep => 'عنوان الشحن';

  @override
  String get paymentStep => 'طريقة الدفع';

  @override
  String get reviewStep => 'مراجعة الطلب';

  @override
  String get confirmationStep => 'تم تأكيد الطلب';

  @override
  String get backButton => 'رجوع';

  @override
  String get continueButton => 'متابعة';

  @override
  String get placeOrderButton => 'تقديم الطلب';

  @override
  String get shippingAddressTitle => 'عنوان الشحن';

  @override
  String get billingAddressTitle => 'عنوان الفوترة';

  @override
  String get noAddressesMessage =>
      'لا توجد عناوين متاحة. يرجى إضافة عنوان للمتابعة.';

  @override
  String get selectShippingMessage => 'يرجى اختيار عنوان شحن للمتابعة';

  @override
  String get selectBillingMessage => 'يرجى اختيار عنوان فوترة للمتابعة';

  @override
  String get useSameAddressLabel => 'استخدام عنوان الشحن للفوترة';

  @override
  String get addAddressButton => 'إضافة عنوان';

  @override
  String get editAddressButton => 'تعديل العنوان';

  @override
  String get fullNameLabel => 'الاسم الكامل';

  @override
  String get streetAddressLabel => 'عنوان الشارع';

  @override
  String get addressLine2Label => 'سطر العنوان 2 (اختياري)';

  @override
  String get cityLabel => 'المدينة';

  @override
  String get stateLabel => 'الولاية';

  @override
  String get stateProvinceLabel => 'الولاية/المقاطعة/المنطقة';

  @override
  String get zipCodeLabel => 'الرمز البريدي';

  @override
  String get countryLabel => 'الدولة';

  @override
  String get phoneNumberLabel => 'رقم الهاتف (اختياري)';

  @override
  String get defaultAddressLabel => 'تعيين كعنوان افتراضي';

  @override
  String get saveButton => 'حفظ';

  @override
  String get cancelButton => 'إلغاء';

  @override
  String get paymentMethodsTitle => 'طرق الدفع';

  @override
  String get addNewPaymentMethodButton => 'إضافة طريقة دفع جديدة';

  @override
  String get defaultLabel => 'افتراضي';

  @override
  String expiresLabel(String month, String year) {
    return 'تنتهي $month/$year';
  }

  @override
  String get editAction => 'تعديل';

  @override
  String get deleteAction => 'حذف';

  @override
  String get deletePaymentMethodTitle => 'حذف طريقة الدفع';

  @override
  String get deletePaymentMethodMessage =>
      'هل أنت متأكد أنك تريد حذف طريقة الدفع هذه؟';

  @override
  String get addPaymentMethodTitle => 'إضافة طريقة دفع';

  @override
  String get editPaymentMethodTitle => 'تعديل طريقة الدفع';

  @override
  String get paymentTypeLabel => 'نوع الدفع';

  @override
  String get creditDebitCardOption => 'بطاقة ائتمان/خصم';

  @override
  String get paypalOption => 'باي بال';

  @override
  String get applePayOption => 'آبل باي';

  @override
  String get googlePayOption => 'جوجل باي';

  @override
  String get cardNumberLabel => 'رقم البطاقة';

  @override
  String get cardholderNameLabel => 'اسم حامل البطاقة';

  @override
  String get expiryMonthLabel => 'شهر';

  @override
  String get expiryYearLabel => 'سنة';

  @override
  String get cvvLabel => 'رمز التحقق';

  @override
  String get cardBrandLabel => 'نوع البطاقة';

  @override
  String get visaOption => 'فيزا';

  @override
  String get mastercardOption => 'ماستر كارد';

  @override
  String get amexOption => 'أمريكان إكسبريس';

  @override
  String get discoverOption => 'ديسكفر';

  @override
  String get paypalEmailLabel => 'البريد الإلكتروني لباي بال';

  @override
  String get defaultPaymentMethodLabel => 'تعيين كطريقة دفع افتراضية';

  @override
  String get requiredField => 'مطلوب';

  @override
  String get invalidMonth => 'شهر غير صالح';

  @override
  String get invalidYear => 'سنة غير صالحة';

  @override
  String get invalidCVV => 'رمز تحقق غير صالح';

  @override
  String get pleaseEnterCardNumber => 'يرجى إدخال رقم البطاقة';

  @override
  String get cardNumberMinLength =>
      'يجب أن يتكون رقم البطاقة من 16 رقمًا على الأقل';

  @override
  String get pleaseEnterCardholderName => 'يرجى إدخال اسم حامل البطاقة';

  @override
  String get pleaseEnterPaypalEmail => 'يرجى إدخال بريدك الإلكتروني لباي بال';

  @override
  String get pleaseEnterValidEmail => 'يرجى إدخال بريد إلكتروني صالح';

  @override
  String get completeAddressMessage => 'يرجى إكمال معلومات العنوان.';

  @override
  String get selectPaymentMethodMessage => 'يرجى اختيار طريقة دفع للمتابعة.';

  @override
  String get completeOrderInformationMessage =>
      'يرجى إكمال جميع المعلومات المطلوبة قبل تقديم طلبك.';

  @override
  String get okButton => 'موافق';

  @override
  String get orderItemsTitle => 'عناصر الطلب';

  @override
  String get noItemsInCart => 'لا توجد عناصر في سلة التسوق';

  @override
  String quantityLabel(int quantity) {
    return 'الكمية: $quantity';
  }

  @override
  String get sameAsShippingAddress => 'نفس عنوان الشحن';

  @override
  String get noShippingAddress => 'لم يتم تحديد عنوان للشحن';

  @override
  String get noPaymentMethod => 'لم يتم تحديد طريقة دفع';

  @override
  String get orderNotesLabel => 'ملاحظات الطلب (اختياري)';

  @override
  String get orderNotesHint => 'تعليمات خاصة لطلبك...';

  @override
  String get orderSummaryTitle => 'ملخص الطلب';

  @override
  String get subtotalLabel => 'المجموع الفرعي';

  @override
  String get taxLabel => 'الضريبة';

  @override
  String get shippingLabel => 'الشحن';

  @override
  String get discountLabel => 'الخصم';

  @override
  String get totalLabel => 'المجموع الكلي';

  @override
  String get orderConfirmedTitle => 'تم تأكيد الطلب!';

  @override
  String get orderConfirmedMessage =>
      'شكراً لطلبك. سنرسل لك رسالة بريد إلكتروني للتأكيد قريباً.';

  @override
  String get orderDetailsTitle => 'تفاصيل الطلب';

  @override
  String get orderNumberLabel => 'رقم الطلب';

  @override
  String get orderDateLabel => 'تاريخ الطلب';

  @override
  String get statusLabel => 'الحالة';

  @override
  String get totalItemsLabel => 'إجمالي العناصر';

  @override
  String get totalAmountLabel => 'المبلغ الإجمالي';

  @override
  String get estimatedDeliveryLabel => 'موعد التسليم المتوقع';

  @override
  String get viewOrderDetailsButton => 'عرض تفاصيل الطلب';

  @override
  String get continueShoppingButton => 'مواصلة التسوق';

  @override
  String get orderUpdatesTitle => 'تحديثات الطلب';

  @override
  String get orderUpdatesMessage =>
      'سنرسل لك تحديثات عبر البريد الإلكتروني حول حالة طلبك ومعلومات التتبع.';

  @override
  String get closeButton => 'إغلاق';

  @override
  String get featuredProducts => 'منتجات مميزة';

  @override
  String get viewAll => 'عرض الكل';

  @override
  String get shopByCategory => 'تسوق حسب الفئة';

  @override
  String get skincare => 'العناية بالبشرة';

  @override
  String get makeup => 'مكياج';

  @override
  String get hairCare => 'العناية بالشعر';

  @override
  String get fragrance => 'عطور';

  @override
  String get whyChooseUs => 'لماذا تختارنا؟';

  @override
  String get authenticProducts => 'منتجات أصلية';

  @override
  String get authenticProductsDesc =>
      'جميع المنتجات أصلية 100٪ ومصدرها مباشرة من العلامات التجارية';

  @override
  String get fastDelivery => 'توصيل سريع';

  @override
  String get fastDeliveryDesc => 'توصيل سريع وآمن إلى باب منزلك';

  @override
  String get expertSupport => 'دعم خبير';

  @override
  String get expertSupportDesc => 'استشارات ودعم احترافي للعناية بالبشرة';

  @override
  String get laRochePosay => 'لاروش بوزيه';

  @override
  String get laboratoireDermatologique => 'مختبر الجلدية';

  @override
  String get tolerianeEffaclar =>
      'مجموعات توليريان وإيفاكلار\nحلول متطورة للعناية بالبشرة';

  @override
  String get shopCollection => 'تسوق المجموعة';

  @override
  String get dermocosmetique => 'ديرموكوزمتيك';

  @override
  String get byPhMariam => 'بواسطة الصيدلانية مريم';

  @override
  String get premiumFrenchPharmacy =>
      'علامات تجارية فرنسية فاخرة\nأصلية • احترافية • موثوقة';

  @override
  String get exploreBrands => 'استكشاف العلامات التجارية';

  @override
  String get specialOffers => 'عروض خاصة';

  @override
  String get limitedTimeOnly => 'لفترة محدودة فقط';

  @override
  String get specialOffersDesc =>
      'خصم يصل إلى 30٪ على منتجات مختارة\nشحن مجاني للطلبات التي تزيد عن \$50';

  @override
  String get viewOffers => 'مشاهدة العروض';

  @override
  String get allProducts => 'جميع المنتجات';

  @override
  String get comingSoon => 'قريبًا';

  @override
  String comingSoonMessage(String feature) {
    return '$feature قيد التطوير وسيكون متاحًا قريبًا!';
  }

  @override
  String get faceCare => 'العناية بالوجه';

  @override
  String get bodyCare => 'العناية بالجسم';

  @override
  String get hairCareCategory => 'العناية بالشعر';

  @override
  String get allBrands => 'جميع العلامات التجارية';

  @override
  String get loyaltyProgram => 'برنامج الولاء';

  @override
  String get specialOffersMenu => 'عروض خاصة';

  @override
  String get contactUs => 'اتصل بنا';

  @override
  String get aboutUs => 'من نحن';

  @override
  String get accountSettings => 'إعدادات الحساب';

  @override
  String get userProfile => 'الملف الشخصي';

  @override
  String get appTitle => 'ديرموكوزمتيك';

  @override
  String get appSubtitle => 'بواسطة الصيدلانية مريم';

  @override
  String get searchLabel => 'بحث';

  @override
  String get cartLabel => 'سلة التسوق';

  @override
  String get productsLabel => 'المنتجات';

  @override
  String get profileLabel => 'الملف الشخصي';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get welcome => 'مرحباً!';

  @override
  String get userEmail => 'user@example.com';

  @override
  String get shopByCategoryMenu => 'تسوق حسب الفئة';

  @override
  String get brandExamples => 'لاروش بوزيه، فيشي، بيوديرما...';

  @override
  String get earnPointsRewards => 'اكسب النقاط والمكافآت';

  @override
  String get discountsPromotions => 'خصومات وعروض ترويجية';

  @override
  String get profilePreferences => 'الملف الشخصي والتفضيلات';

  @override
  String get searchProducts => 'البحث عن المنتجات';

  @override
  String get aboutUsFooter => 'من نحن';

  @override
  String get loyaltyFooter => 'الولاء';

  @override
  String get supportFooter => 'الدعم';

  @override
  String get privacyFooter => 'الخصوصية';

  @override
  String get termsFooter => 'الشروط';

  @override
  String get followUs => 'تابعنا: ';

  @override
  String get copyrightText => '© 2025 ديرموكوزمتيك بواسطة الصيدلانية مريم';

  @override
  String get allRightsReserved => 'جميع الحقوق محفوظة';

  @override
  String get productsPageTitle => 'المنتجات';

  @override
  String get searchProductsHint => 'البحث عن المنتجات...';

  @override
  String get sortAtoZ => 'ترتيب: أ إلى ي';

  @override
  String get sortZtoA => 'ترتيب: ي إلى أ';

  @override
  String get sortPriceLow => 'ترتيب: السعر من الأقل';

  @override
  String get sortPriceHigh => 'ترتيب: السعر من الأعلى';

  @override
  String get filtersTooltip => 'فلاتر';

  @override
  String get filtersTitle => 'فلاتر';

  @override
  String get clearAll => 'مسح الكل';

  @override
  String get categoryFilter => 'الفئة';

  @override
  String get brandFilter => 'العلامة التجارية';

  @override
  String get allCategories => 'جميع الفئات';

  @override
  String get allBrandsFilter => 'جميع العلامات التجارية';

  @override
  String priceRange(int start, int end) {
    return 'نطاق السعر: \$$start - \$$end';
  }

  @override
  String minimumRating(String rating) {
    return 'الحد الأدنى للتقييم: $rating نجمة';
  }

  @override
  String get showOnlyInStock => 'عرض المنتجات المتوفرة فقط';

  @override
  String get applyFilters => 'تطبيق الفلاتر';

  @override
  String get avene => 'أفين';

  @override
  String get vichy => 'فيشي';

  @override
  String get eucerin => 'يوسيرين';

  @override
  String get cerave => 'سيرافي';

  @override
  String get neutrogena => 'نيوتروجينا';

  @override
  String get soldOut => 'نفذ المخزون';

  @override
  String get noProductsFound => 'لم يتم العثور على منتجات';

  @override
  String noProductsMatchSearch(String searchQuery) {
    return 'لا توجد منتجات تطابق بحثك عن \"$searchQuery\"';
  }

  @override
  String get noProductsMatchFilters => 'لا توجد منتجات تطابق الفلاتر الحالية';

  @override
  String get noProductsAvailable => 'لا توجد منتجات متاحة في الوقت الحالي';

  @override
  String get tryAdjustingFilters => 'جرب تعديل البحث أو الفلاتر';

  @override
  String get clearAllFilters => 'مسح جميع الفلاتر';

  @override
  String get gridViewTooltip => 'عرض الشبكة';

  @override
  String get listViewTooltip => 'عرض القائمة';
}
