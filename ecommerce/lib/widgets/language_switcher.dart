import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';

class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final isEnglish = languageProvider.currentLocale.languageCode == 'en';

    return IconButton(
      icon: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(isEnglish ? 'EN' : 'عربي', 
               style: TextStyle(
                 fontSize: 14, 
                 fontWeight: FontWeight.bold,
                 color: Colors.white,
               )),
          const SizedBox(width: 4),
          Icon(Icons.language, size: 18),
        ],
      ),
      onPressed: () {
        languageProvider.toggleLanguage();
        // Show a snackbar to confirm language change
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEnglish 
                  ? 'تم تغيير اللغة إلى العربية' // Language changed to Arabic
                  : 'Language changed to English',
            ),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      tooltip: isEnglish ? 'Switch to Arabic' : 'تبديل إلى الإنجليزية',
    );
  }
}
