import 'package:flutter/material.dart';
import 'package:ecommerce/widgets/language_switcher.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce/providers/theme_provider.dart';

class AccountSettingsPage extends StatelessWidget {
  const AccountSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('Account Settings'),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor ?? Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor ?? Theme.of(context).colorScheme.onPrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          ListTile(
            leading: Icon(Icons.person, color: Theme.of(context).colorScheme.primary),
            title: const Text('Edit Profile'),
            subtitle: const Text('Change your name, email, or photo'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Navigate to Edit Profile page (not implemented)')),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.lock, color: Theme.of(context).colorScheme.primary),
            title: const Text('Change Password'),
            subtitle: const Text('Update your account password'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Navigate to Change Password page (not implemented)')),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.language, color: Theme.of(context).colorScheme.primary),
            title: const Text('Language'),
            subtitle: const Text('Switch app language'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  title: const Text('Choose Language'),
                  content: const LanguageSwitcher(),
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.notifications, color: Theme.of(context).colorScheme.primary),
            title: const Text('Notifications'),
            subtitle: const Text('Manage notification preferences'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Open notification settings (not implemented)')),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.delete_forever, color: Theme.of(context).colorScheme.error),
            title: const Text('Delete Account'),
            subtitle: const Text('Permanently remove your account'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Account deletion flow (not implemented)')),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.brightness_6, color: Theme.of(context).colorScheme.primary),
            title: const Text('Theme'),
            subtitle: const Text('Switch between light and dark mode'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () async {
              final mode = await showDialog<ThemeMode>(
                context: context,
                builder: (context) => AlertDialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  title: const Text('Choose Theme'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: const Icon(Icons.brightness_5),
                        title: const Text('Light'),
                        onTap: () => Navigator.of(context).pop(ThemeMode.light),
                      ),
                      ListTile(
                        leading: const Icon(Icons.brightness_2),
                        title: const Text('Dark'),
                        onTap: () => Navigator.of(context).pop(ThemeMode.dark),
                      ),
                    ],
                  ),
                ),
              );
              if (mode != null) {
                Provider.of<ThemeProvider>(context, listen: false).setThemeMode(mode);
              }
            },
          ),
        ],
      ),
    );
  }
}
