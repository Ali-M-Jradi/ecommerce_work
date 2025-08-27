import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/admin/settings_provider.dart';
import 'package:ecommerce/models/admin/customization_settings.dart';
import '../../../providers/parameter_provider.dart';
import '../../utils/app_colors.dart';
import '../../../providers/theme_provider.dart';
import '../../models/parameter.dart';
import 'widgets/admin_color_selector.dart';
// ...existing imports
// imports cleaned

class AdminSettingsPage extends StatefulWidget {
  const AdminSettingsPage({super.key});

  @override
  State<AdminSettingsPage> createState() => _AdminSettingsPageState();
}

class _AdminSettingsPageState extends State<AdminSettingsPage> {
  late TextEditingController _primaryColorController;
  late TextEditingController _secondaryColorController;
  late TextEditingController _logoController;
  String _themeMode = 'light';
  bool _isLoading = false;
  // removed preview/contrast helpers — simplified admin flow

  // Contrast helpers removed — preview now shows theme samples and admins should use accessible API-provided palettes

  @override
  void initState() {
    super.initState();
    _primaryColorController = TextEditingController();
    _secondaryColorController = TextEditingController();
    _logoController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<SettingsProvider>().loadSettings();
      final settings = context.read<SettingsProvider>().settings;
      final themeProvider = context.read<ThemeProvider>();

      setState(() {
        _themeMode = settings?.themeMode ?? 'light';

        // Initialize with current theme colors if available; prefer ThemeProvider, then saved settings, else empty (API will populate)
        String primaryColorHex = '';
        if (themeProvider.customPrimaryColor != null) {
          primaryColorHex = _colorToHex(themeProvider.customPrimaryColor);
        } else if (settings?.primaryColor?.isNotEmpty == true) {
          primaryColorHex = settings!.primaryColor!;
        }

        String secondaryColorHex = '';
        if (themeProvider.customSecondaryColor != null) {
          secondaryColorHex = _colorToHex(themeProvider.customSecondaryColor);
        } else if (settings?.secondaryColor?.isNotEmpty == true) {
          secondaryColorHex = settings!.secondaryColor!;
        }

        _primaryColorController.text = primaryColorHex;
        _secondaryColorController.text = secondaryColorHex;
        _logoController.text = settings?.logoUrl ?? '';

        print(
          '[AdminSettings] Initialized with primary: $primaryColorHex, secondary: $secondaryColorHex',
        );
      });
    });
  }

  String _colorToHex(Color? color) {
    if (color == null) return '';
    return '#${color.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
  }

  Color? _hexToColor(String hex) {
    if (hex.isEmpty || !hex.startsWith('#')) return null;
    try {
      return Color(int.parse(hex.replaceFirst('#', '0xff')));
    } catch (_) {
      return null;
    }
  }

  @override
  void dispose() {
    _primaryColorController.dispose();
    _secondaryColorController.dispose();
    _logoController.dispose();
    super.dispose();
  }

  void _saveThemeSettings() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final provider = context.read<SettingsProvider>();
      final themeProvider = context.read<ThemeProvider>();

      // Create new settings with secondary color included
      final newSettings = CustomizationSettings(
        themeMode: _themeMode,
        primaryColor: _primaryColorController.text,
        secondaryColor: _secondaryColorController.text, // Now included
        logoUrl: _logoController.text,
      );

      print('[AdminSettings] Saving settings: ${newSettings.toJson()}');

      // Save settings to admin provider
      await provider.saveSettings(newSettings);

      // Update ThemeProvider for immediate effect
      if (_themeMode == 'dark') {
        await themeProvider.setThemeMode(ThemeMode.dark);
      } else {
        await themeProvider.setThemeMode(ThemeMode.light);
      }

      // Set colors
      final primaryColor = _hexToColor(_primaryColorController.text);
      final secondaryColor = _hexToColor(_secondaryColorController.text);

      print(
        '[AdminSettings] Setting colors - Primary: $primaryColor, Secondary: $secondaryColor',
      );

      await themeProvider.setAllThemeColors(
        primaryColor: primaryColor,
        secondaryColor: secondaryColor,
      );

      if (provider.error == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Theme & Colors saved successfully!'),
            backgroundColor: AppColors.success(context),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${provider.error}'),
            backgroundColor: AppColors.error(context),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving theme: $e'),
          backgroundColor: AppColors.error(context),
        ),
      );
    } finally {
      setState(() => _isLoading = false);
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
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
        toolbarHeight: 70,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'General',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'Support Email',
                      prefixIcon: Icon(Icons.email),
                    ),
                    onSubmitted: (val) {
                      if (val.isNotEmpty) {
                        final idx = parameterProvider.parameters.indexWhere(
                          (p) => p.key == 'support_email',
                        );
                        if (idx >= 0) {
                          parameterProvider.updateParameter(
                            idx,
                            parameterProvider.parameters[idx].copyWith(
                              value: val,
                            ),
                          );
                        } else {
                          parameterProvider.addParameter(
                            Parameter(key: 'support_email', value: val),
                          );
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Support Phone',
                      prefixIcon: Icon(Icons.phone),
                    ),
                    onSubmitted: (val) {
                      if (val.isNotEmpty) {
                        final idx = parameterProvider.parameters.indexWhere(
                          (p) => p.key == 'support_phone',
                        );
                        if (idx >= 0) {
                          parameterProvider.updateParameter(
                            idx,
                            parameterProvider.parameters[idx].copyWith(
                              value: val,
                            ),
                          );
                        } else {
                          parameterProvider.addParameter(
                            Parameter(key: 'support_phone', value: val),
                          );
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Text(
                        'Maintenance Mode',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 12),
                      Switch(
                        value: maintenanceMode,
                        onChanged: (val) {
                          final idx = parameterProvider.parameters.indexWhere(
                            (p) => p.key == 'maintenance_mode',
                          );
                          if (idx >= 0) {
                            parameterProvider.updateParameter(
                              idx,
                              parameterProvider.parameters[idx].copyWith(
                                value: val.toString(),
                              ),
                            );
                          } else {
                            parameterProvider.addParameter(
                              Parameter(
                                key: 'maintenance_mode',
                                value: val.toString(),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LayoutBuilder(builder: (context, constraints) {
                    final title = const Text(
                      'Branding & Theme',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      overflow: TextOverflow.ellipsis,
                    );
                    return title;
                  }),

                  // Theme Mode
                  Row(
                    children: [
                      const Text('Theme Mode', style: TextStyle(fontSize: 16)),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: DropdownButton<String>(
                            value: _themeMode,
                            items: const [
                              DropdownMenuItem(
                                value: 'light',
                                child: Text('Light'),
                              ),
                              DropdownMenuItem(
                                value: 'dark',
                                child: Text('Dark'),
                              ),
                            ],
                            onChanged: (val) {
                              if (val != null) setState(() => _themeMode = val);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Enhanced API-based Color Selector
                  AdminColorSelector(),

                  const SizedBox(height: 12),

                  // Action Buttons (improved layout)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Save action on the right
                        ElevatedButton.icon(
                          icon: _isLoading
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.save),
                          label: Text(_isLoading ? 'Saving...' : 'Save'),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(110, 44),
                            backgroundColor: Theme.of(context).colorScheme.primary,
                          ),
                          onPressed: _isLoading ? null : _saveThemeSettings,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
