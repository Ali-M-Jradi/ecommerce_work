import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce/providers/admin/settings_provider.dart';
import 'package:ecommerce/providers/theme_provider.dart';
import 'package:ecommerce/models/admin/customization_settings.dart';
import 'components/settings_tile.dart';
import 'components/color_picker_dialog.dart';

class CustomizationPage extends StatefulWidget {
  const CustomizationPage({super.key});

  @override
  State<CustomizationPage> createState() => _CustomizationPageState();
}

class _CustomizationPageState extends State<CustomizationPage> {
  late TextEditingController _colorController;
  late TextEditingController _logoController;
  String _themeMode = 'light';

  @override
  void initState() {
    super.initState();
    _colorController = TextEditingController();
    _logoController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<SettingsProvider>().loadSettings();
      final settings = context.read<SettingsProvider>().settings;
      setState(() {
        _themeMode = settings?.themeMode ?? 'light';
        _colorController.text = settings?.primaryColor ?? '';
        _logoController.text = settings?.logoUrl ?? '';
      });
    });
  }

  @override
  void dispose() {
    _colorController.dispose();
    _logoController.dispose();
    super.dispose();
  }

  void _save() async {
    final provider = context.read<SettingsProvider>();
    final themeProvider = context.read<ThemeProvider>();
    final newSettings = CustomizationSettings(
      themeMode: _themeMode,
      primaryColor: _colorController.text,
      logoUrl: _logoController.text,
    );
    await provider.saveSettings(newSettings);
    // Update the app's theme mode and primary color immediately
    if (_themeMode == 'light') {
      themeProvider.setThemeMode(ThemeMode.light);
    } else {
      themeProvider.setThemeMode(ThemeMode.dark);
    }
    // Set the custom primary color in ThemeProvider
    try {
      final colorText = _colorController.text;
      if (colorText.isNotEmpty && colorText.startsWith('#')) {
        final color = Color(int.parse(colorText.replaceFirst('#', '0xff')));
        themeProvider.setCustomPrimaryColor(color);
      } else {
        themeProvider.setCustomPrimaryColor(null);
      }
    } catch (_) {
      themeProvider.setCustomPrimaryColor(null);
    }
    if (provider.error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Settings saved!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (provider.error != null) {
          return Center(child: Text('Error: \\${provider.error}'));
        }
        return Scaffold(
          appBar: AppBar(title: const Text('Customization Settings')),
          body: ListView(
            children: [
              ExpansionTile(title: const Text('upperbanner'), children: [
                const ListTile(title: Text('Upper Banner settings go here.')),
              ]),
              ExpansionTile(title: const Text('Landing home Page Moving banner'), children: [
                const ListTile(title: Text('Landing home Page Moving banner settings go here.')),
              ]),
              ExpansionTile(title: const Text('Number One In'), children: [
                const ListTile(title: Text('Number One In settings go here.')),
              ]),
              ExpansionTile(title: const Text('Carousel images'), children: [
                const ListTile(title: Text('Carousel images settings go here.')),
              ]),
              ExpansionTile(title: const Text('footer Icons'), children: [
                const ListTile(title: Text('Footer Icons settings go here.')),
              ]),
              ExpansionTile(title: const Text('Colors'), initiallyExpanded: true, children: [
                SettingsTile(
                  title: 'Theme Mode',
                  trailing: DropdownButton<String>(
                    value: _themeMode,
                    items: const [
                      DropdownMenuItem(value: 'light', child: Text('Light')),
                      DropdownMenuItem(value: 'dark', child: Text('Dark')),
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => _themeMode = val);
                    },
                  ),
                ),
                SettingsTile(
                  title: 'Primary Color (Hex)',
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 90,
                        child: TextField(
                          controller: _colorController,
                          decoration: const InputDecoration(hintText: '#673AB7'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.color_lens, color: Colors.deepPurpleAccent),
                        tooltip: 'Pick Color',
                        onPressed: () async {
                          Color initialColor = Colors.deepPurpleAccent;
                          try {
                            if (_colorController.text.isNotEmpty) {
                              initialColor = Color(int.parse(_colorController.text.replaceFirst('#', '0xff')));
                            }
                          } catch (_) {}
                          showDialog(
                            context: context,
                            builder: (context) => ColorPickerDialog(
                              initialColor: initialColor,
                              onColorSelected: (color) {
                                final hex = '#'
                                    + color.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase();
                                setState(() {
                                  _colorController.text = hex;
                                });
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ]),
              ExpansionTile(title: const Text('Logo Image Dark'), children: [
                const ListTile(title: Text('Logo Image Dark settings go here.')),
              ]),
              ExpansionTile(title: const Text('Logo Image Light'), children: [
                SettingsTile(
                  title: 'Logo URL',
                  trailing: SizedBox(
                    width: 180,
                    child: TextField(
                      controller: _logoController,
                      decoration: const InputDecoration(hintText: 'https://...'),
                    ),
                  ),
                ),
              ]),
              ExpansionTile(title: const Text('About Us'), children: [
                const ListTile(title: Text('About Us settings go here.')),
              ]),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ElevatedButton(
                  onPressed: _save,
                  child: const Text('Save Settings'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
