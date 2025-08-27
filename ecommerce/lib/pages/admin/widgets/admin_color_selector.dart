import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../services/color_service.dart';
import '../../../providers/color_provider.dart';
// theme provider not required here after auto-apply

class AdminColorSelector extends StatefulWidget {
  const AdminColorSelector({super.key});

  @override
  State<AdminColorSelector> createState() => _AdminColorSelectorState();
}

class _AdminColorSelectorState extends State<AdminColorSelector> {
  ColorOption? _mainColor;
  ColorOption? _secondaryColor;
  ColorOption? _thirdColor;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<ColorProvider>();
      provider.loadColors().then((_) {
        final mainThemeColors = provider.getMainThemeColors();
        setState(() {
          _mainColor = mainThemeColors['MainColor'];
          _secondaryColor = mainThemeColors['SecondaryColor'];
          _thirdColor = mainThemeColors['ThirdColor'];
        });
      });
    });
  }

  Future<void> _applyColors() async {
  // removed - palette is applied automatically from ColorProvider during app startup
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ColorProvider>(
      builder: (context, colorProvider, child) {
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header (responsive)
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final narrow = constraints.maxWidth < 360;
                      if (narrow) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.palette, color: Theme.of(context).colorScheme.primary),
                                const SizedBox(width: 12),
                                const Expanded(
                                  child: Text(
                                    'App Color Palette',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                           
                          ],
                        );
                      }

                      return Row(
                        children: [
                          Icon(Icons.palette, color: Theme.of(context).colorScheme.primary),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'App Color Palette',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                         
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  if (colorProvider.isLoading)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else if (colorProvider.error != null)
                    Center(
                      child: Column(
                        children: [
                          Text('Error: ${colorProvider.error}', 
                               style: const TextStyle(color: Colors.red)),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () => colorProvider.loadColors(),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    )
                  else ...[
                    // Only show the three theme colors (tap to change)
                    if (_mainColor != null)
                      _buildSingleColorTile('MainColor', _mainColor!, provider: colorProvider),
                    if (_secondaryColor != null)
                      _buildSingleColorTile('SecondaryColor', _secondaryColor!, provider: colorProvider),
                    if (_thirdColor != null)
                      _buildSingleColorTile('ThirdColor', _thirdColor!, provider: colorProvider),
                    const SizedBox(height: 16),
                  
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Build a single color tile for display
  Widget _buildSingleColorTile(String label, ColorOption color, {required ColorProvider provider}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ClipRect(
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
                decoration: BoxDecoration(
                  color: color.color,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.06),
                    width: 1,
                  ),
                ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('$label: ${color.displayName}', style: const TextStyle(fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis, maxLines: 1),
                  Text(color.hexValue, style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6), fontSize: 12), overflow: TextOverflow.ellipsis, maxLines: 1),
                ],
              ),
            ),
            // Removed inline edit icon and direct color-change functionality
            // Color tiles are read-only — use the global branding controls to update colors.
          ],
        ),
      ),
    );
  }
  // ...existing code...
}
