import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/admin/settings_provider.dart';
import 'package:ecommerce/models/admin/customization_settings.dart';
import '../../../providers/parameter_provider.dart';
import '../../../providers/theme_provider.dart';
import '../../models/parameter.dart';

class AdminSettingsPage extends StatefulWidget {
  const AdminSettingsPage({super.key});

  @override
  State<AdminSettingsPage> createState() => _AdminSettingsPageState();
}

class _AdminSettingsPageState extends State<AdminSettingsPage> {
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

  void _saveThemeSettings() async {
    final provider = context.read<SettingsProvider>();
    final themeProvider = context.read<ThemeProvider>();
    final newSettings = CustomizationSettings(
      themeMode: _themeMode,
      primaryColor: _colorController.text,
      logoUrl: _logoController.text,
    );
    await provider.saveSettings(newSettings);
    // Update ThemeProvider for immediate effect
    if (_themeMode == 'dark') {
      await themeProvider.setThemeMode(ThemeMode.dark);
    } else {
      await themeProvider.setThemeMode(ThemeMode.light);
    }
    try {
      final color = _colorController.text;
      if (color.isNotEmpty && color.startsWith('#')) {
        await themeProvider.setCustomPrimaryColor(Color(int.parse(color.replaceFirst('#', '0xff'))));
      } else {
        await themeProvider.setCustomPrimaryColor(null);
      }
    } catch (_) {
      await themeProvider.setCustomPrimaryColor(null);
    }
    if (provider.error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Theme & Color saved!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final parameterProvider = context.watch<ParameterProvider>();
    // General settings controllers
    String supportEmail = '';
    String supportPhone = '';
    String maintenance = 'false';
    for (final p in parameterProvider.parameters) {
      if (p.key == 'support_email') supportEmail = p.value;
      if (p.key == 'support_phone') supportPhone = p.value;
      if (p.key == 'maintenance_mode') maintenance = p.value;
    }
    final emailController = TextEditingController(text: supportEmail);
    final phoneController = TextEditingController(text: supportPhone);
    bool maintenanceMode = maintenance == 'true';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Settings'),
        backgroundColor: Colors.deepOrange,
        elevation: 0,
        toolbarHeight: 70,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('General', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 16),
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: 'Support Email', prefixIcon: Icon(Icons.email)),
                    onSubmitted: (val) {
                      if (val.isNotEmpty) {
                        final idx = parameterProvider.parameters.indexWhere((p) => p.key == 'support_email');
                        if (idx >= 0) {
                          parameterProvider.updateParameter(idx, parameterProvider.parameters[idx].copyWith(value: val));
                        } else {
                          parameterProvider.addParameter(Parameter(key: 'support_email', value: val));
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: phoneController,
                    decoration: const InputDecoration(labelText: 'Support Phone', prefixIcon: Icon(Icons.phone)),
                    onSubmitted: (val) {
                      if (val.isNotEmpty) {
                        final idx = parameterProvider.parameters.indexWhere((p) => p.key == 'support_phone');
                        if (idx >= 0) {
                          parameterProvider.updateParameter(idx, parameterProvider.parameters[idx].copyWith(value: val));
                        } else {
                          parameterProvider.addParameter(Parameter(key: 'support_phone', value: val));
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Text('Maintenance Mode', style: TextStyle(fontSize: 16)),
                      const SizedBox(width: 12),
                      Switch(
                        value: maintenanceMode,
                        onChanged: (val) {
                          final idx = parameterProvider.parameters.indexWhere((p) => p.key == 'maintenance_mode');
                          if (idx >= 0) {
                            parameterProvider.updateParameter(idx, parameterProvider.parameters[idx].copyWith(value: val.toString()));
                          } else {
                            parameterProvider.addParameter(Parameter(key: 'maintenance_mode', value: val.toString()));
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Branding & Theme', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Text('Theme Mode', style: TextStyle(fontSize: 16)),
                      const SizedBox(width: 16),
                      DropdownButton<String>(
                        value: _themeMode,
                        items: const [
                          DropdownMenuItem(value: 'light', child: Text('Light')),
                          DropdownMenuItem(value: 'dark', child: Text('Dark')),
                        ],
                        onChanged: (val) {
                          if (val != null) setState(() => _themeMode = val);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Text('Primary Color', style: TextStyle(fontSize: 16)),
                      const SizedBox(width: 16),
                      SizedBox(
                        width: 100,
                        child: TextField(
                          controller: _colorController,
                          decoration: const InputDecoration(hintText: '#673AB7'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Text('Logo URL', style: TextStyle(fontSize: 16)),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          controller: _logoController,
                          decoration: const InputDecoration(hintText: 'https://...'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.save),
                      label: const Text('Save Theme & Color'),
                      style: ElevatedButton.styleFrom(minimumSize: const Size(180, 44)),
                      onPressed: _saveThemeSettings,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
