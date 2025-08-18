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
  late TextEditingController _primaryColorController;
  late TextEditingController _secondaryColorController;
  late TextEditingController _logoController;
  String _themeMode = 'light';
  bool _isLoading = false;

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
        
        // Initialize with current theme colors if available
        String primaryColorHex = '';
        if (themeProvider.customPrimaryColor != null) {
          primaryColorHex = _colorToHex(themeProvider.customPrimaryColor);
        } else if (settings?.primaryColor?.isNotEmpty == true) {
          primaryColorHex = settings!.primaryColor!;
        } else {
          primaryColorHex = '#673AB7'; // Default primary color
        }
        
        String secondaryColorHex = '';
        if (themeProvider.customSecondaryColor != null) {
          secondaryColorHex = _colorToHex(themeProvider.customSecondaryColor);
        } else if (settings?.secondaryColor?.isNotEmpty == true) {
          secondaryColorHex = settings!.secondaryColor!;
        } else {
          secondaryColorHex = '#E91E63'; // Default secondary color
        }
        
        _primaryColorController.text = primaryColorHex;
        _secondaryColorController.text = secondaryColorHex;
        _logoController.text = settings?.logoUrl ?? '';
        
        print('[AdminSettings] Initialized with primary: $primaryColorHex, secondary: $secondaryColorHex');
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
      
      print('[AdminSettings] Setting colors - Primary: $primaryColor, Secondary: $secondaryColor');
      
      await themeProvider.setAllThemeColors(
        primaryColor: primaryColor,
        secondaryColor: secondaryColor,
      );

      if (provider.error == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Theme & Colors saved successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${provider.error}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving theme: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _resetToDefaults() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Theme'),
        content: const Text('This will reset all colors to their default values. Are you sure?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await context.read<ThemeProvider>().resetColors();
              setState(() {
                _primaryColorController.clear();
                _secondaryColorController.clear();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Colors reset to defaults')),
              );
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Branding & Theme', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      TextButton.icon(
                        icon: const Icon(Icons.refresh, size: 16),
                        label: const Text('Reset'),
                        onPressed: _resetToDefaults,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Theme Mode
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
                  const SizedBox(height: 20),
                  
                  // Color Section
                  const Text('Color Palette', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                  const SizedBox(height: 12),
                  
                  // Primary Color
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: _hexToColor(_primaryColorController.text) ?? Colors.grey,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text('Primary Color', style: TextStyle(fontSize: 14)),
                      const SizedBox(width: 16),
                      SizedBox(
                        width: 120,
                        child: TextField(
                          controller: _primaryColorController,
                          decoration: const InputDecoration(
                            hintText: '#673AB7',
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          ),
                          onChanged: (_) => setState(() {}), // Refresh color preview
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  
                  // Secondary Color
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: _hexToColor(_secondaryColorController.text) ?? Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text('Secondary Color', style: TextStyle(fontSize: 14)),
                      const SizedBox(width: 6),
                      SizedBox(
                        width: 120,
                        child: TextField(
                          controller: _secondaryColorController,
                          decoration: const InputDecoration(
                            hintText: '#E91E63',
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          ),
                          onChanged: (_) => setState(() {}), // Refresh color preview
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  // Logo URL
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
                  const SizedBox(height: 24),
                  
                  // Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton.icon(
                        icon: const Icon(Icons.preview, size: 16),
                        label: const Text('Preview'),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Preview functionality coming soon!'),
                              backgroundColor: _hexToColor(_primaryColorController.text) ?? Theme.of(context).primaryColor,
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        icon: _isLoading 
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : const Icon(Icons.save),
                        label: Text(_isLoading ? 'Saving...' : 'Save Theme & Colors'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(180, 44),
                          backgroundColor: _hexToColor(_primaryColorController.text),
                        ),
                        onPressed: _isLoading ? null : _saveThemeSettings,
                      ),
                    ],
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
