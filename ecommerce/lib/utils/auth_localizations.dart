import 'package:flutter/material.dart';

/// A temporary utility class for adding translatable strings for the auth pages
/// This will be used until the proper localization pipeline is set up for these strings
class AuthLocalizations {
  static String brandName(BuildContext context) {
    return Localizations.localeOf(context).languageCode == 'ar' 
        ? 'ديرموكوزميتيك'
        : 'DERMOCOSMETIQUE';
  }
  
  static String brandTagline(BuildContext context) {
    return Localizations.localeOf(context).languageCode == 'ar'
        ? 'بواسطة د. مريم'
        : 'BY PH.MARIAM';
  }
  
  static String welcomeBack(BuildContext context) {
    return Localizations.localeOf(context).languageCode == 'ar'
        ? 'مرحباً بعودتك'
        : 'Welcome Back';
  }
  
  static String signInToContinue(BuildContext context) {
    return Localizations.localeOf(context).languageCode == 'ar'
        ? 'سجل الدخول لمواصلة رحلة جمالك'
        : 'Sign in to continue your beauty journey';
  }
  
  static String email(BuildContext context) {
    return Localizations.localeOf(context).languageCode == 'ar'
        ? 'البريد الإلكتروني'
        : 'Email';
  }
  
  static String password(BuildContext context) {
    return Localizations.localeOf(context).languageCode == 'ar'
        ? 'كلمة المرور'
        : 'Password';
  }
  
  static String forgotPassword(BuildContext context) {
    return Localizations.localeOf(context).languageCode == 'ar'
        ? 'نسيت كلمة المرور؟'
        : 'Forgot Password?';
  }
  
  static String rememberMe(BuildContext context) {
    return Localizations.localeOf(context).languageCode == 'ar'
        ? 'تذكرني'
        : 'Remember Me';
  }
  
  static String loginButton(BuildContext context) {
    return Localizations.localeOf(context).languageCode == 'ar'
        ? 'تسجيل الدخول'
        : 'Login';
  }
  
  static String noAccount(BuildContext context) {
    return Localizations.localeOf(context).languageCode == 'ar'
        ? 'ليس لديك حساب؟'
        : 'Don\'t have an account?';
  }
  
  static String signUp(BuildContext context) {
    return Localizations.localeOf(context).languageCode == 'ar'
        ? 'إنشاء حساب'
        : 'Sign Up';
  }
  
  static String loginSuccessful(BuildContext context) {
    return Localizations.localeOf(context).languageCode == 'ar'
        ? 'تم تسجيل الدخول بنجاح!'
        : 'Login successful!';
  }
  
  static String orContinueWith(BuildContext context) {
    return Localizations.localeOf(context).languageCode == 'ar'
        ? 'أو تابع باستخدام'
        : 'or continue with';
  }
  
  static String emailRequired(BuildContext context) {
    return Localizations.localeOf(context).languageCode == 'ar'
        ? 'الرجاء إدخال بريدك الإلكتروني'
        : 'Please enter your email';
  }
  
  static String emailInvalid(BuildContext context) {
    return Localizations.localeOf(context).languageCode == 'ar'
        ? 'الرجاء إدخال بريد إلكتروني صالح'
        : 'Please enter a valid email';
  }
  
  static String passwordRequired(BuildContext context) {
    return Localizations.localeOf(context).languageCode == 'ar'
        ? 'الرجاء إدخال كلمة المرور'
        : 'Please enter your password';
  }
  
  static String passwordTooShort(BuildContext context) {
    return Localizations.localeOf(context).languageCode == 'ar'
        ? 'يجب أن تكون كلمة المرور 6 أحرف على الأقل'
        : 'Password must be at least 6 characters';
  }
  
  static String createAccount(BuildContext context) {
    return Localizations.localeOf(context).languageCode == 'ar'
        ? 'إنشاء حساب'
        : 'Create Account';
  }
  
  static String createYourAccount(BuildContext context) {
    return Localizations.localeOf(context).languageCode == 'ar'
        ? 'إنشاء حسابك'
        : 'Create Your Account';
  }
  
  static String joinBeautyCommunity(BuildContext context) {
    return Localizations.localeOf(context).languageCode == 'ar'
        ? 'انضم لمجتمع الجمال اليوم'
        : 'Join our beauty community today';
  }
  
  static String firstName(BuildContext context) {
    return Localizations.localeOf(context).languageCode == 'ar'
        ? 'الاسم الأول'
        : 'First Name';
  }
  
  static String lastName(BuildContext context) {
    return Localizations.localeOf(context).languageCode == 'ar'
        ? 'اسم العائلة'
        : 'Last Name';
  }
  
  static String emailAddress(BuildContext context) {
    return Localizations.localeOf(context).languageCode == 'ar'
        ? 'عنوان البريد الإلكتروني'
        : 'Email Address';
  }
  
  static String confirmPassword(BuildContext context) {
    return Localizations.localeOf(context).languageCode == 'ar'
        ? 'تأكيد كلمة المرور'
        : 'Confirm Password';
  }
  
  static String fieldRequired(BuildContext context) {
    return Localizations.localeOf(context).languageCode == 'ar'
        ? 'مطلوب'
        : 'Required';
  }
  
  static String confirmPasswordRequired(BuildContext context) {
    return Localizations.localeOf(context).languageCode == 'ar'
        ? 'الرجاء تأكيد كلمة المرور'
        : 'Please confirm your password';
  }
  
  static String passwordsDoNotMatch(BuildContext context) {
    return Localizations.localeOf(context).languageCode == 'ar'
        ? 'كلمات المرور غير متطابقة'
        : 'Passwords do not match';
  }
  
  static String agreeToTerms(BuildContext context) {
    return Localizations.localeOf(context).languageCode == 'ar'
        ? 'أوافق على '
        : 'I agree to the ';
  }
  
  static String termsOfService(BuildContext context) {
    return Localizations.localeOf(context).languageCode == 'ar'
        ? 'شروط الخدمة'
        : 'Terms of Service';
  }
  
  static String and(BuildContext context) {
    return Localizations.localeOf(context).languageCode == 'ar'
        ? ' و '
        : ' and ';
  }
  
  static String privacyPolicy(BuildContext context) {
    return Localizations.localeOf(context).languageCode == 'ar'
        ? 'سياسة الخصوصية'
        : 'Privacy Policy';
  }
  
  static String agreeToTermsRequired(BuildContext context) {
    return Localizations.localeOf(context).languageCode == 'ar'
        ? 'الرجاء الموافقة على الشروط والأحكام'
        : 'Please agree to terms and conditions';
  }
  
  static String accountCreatedSuccessfully(BuildContext context) {
    return Localizations.localeOf(context).languageCode == 'ar'
        ? 'تم إنشاء الحساب بنجاح!'
        : 'Account created successfully!';
  }
  
  static String haveAccount(BuildContext context) {
    return Localizations.localeOf(context).languageCode == 'ar'
        ? 'هل لديك حساب بالفعل؟ '
        : 'Already have an account? ';
  }
  
  static String signIn(BuildContext context) {
    return Localizations.localeOf(context).languageCode == 'ar'
        ? 'تسجيل الدخول'
        : 'Sign In';
  }
  
  static String google(BuildContext context) {
    return 'Google'; // Brand name, same in both languages
  }
  
  static String apple(BuildContext context) {
    return Localizations.localeOf(context).languageCode == 'ar'
        ? 'آبل'
        : 'Apple';
  }
}
