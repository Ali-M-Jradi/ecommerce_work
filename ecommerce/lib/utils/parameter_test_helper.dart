import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/parameter_provider.dart';
import '../models/parameter.dart';

/// Helper class to quickly test parameter functionality
class ParameterTestHelper {
  
  /// Set up test parameters for demonstration
  static Future<void> setupTestParameters(BuildContext context) async {
    final paramProvider = Provider.of<ParameterProvider>(context, listen: false);
    
    // Clear existing parameters for clean test
    while (paramProvider.parameters.isNotEmpty) {
      paramProvider.deleteParameter(0);
    }
    
    // Add test parameters
    final testParams = [
      Parameter(key: 'maintenance_mode', value: 'false'),
      Parameter(key: 'welcome_message', value: 'Welcome to our amazing cosmetics store!'),
      Parameter(key: 'free_shipping_threshold', value: '50'),
      Parameter(key: 'max_cart_items', value: '5'),
      Parameter(key: 'min_order_value', value: '25'),
      Parameter(key: 'discount_rate', value: '0.1'),
      Parameter(key: 'shipping_tax', value: '5'),
      Parameter(key: 'support_email', value: 'support@cosmetics.com'),
      Parameter(key: 'support_phone', value: '+1-555-BEAUTY'),
    ];
    
    for (final param in testParams) {
      paramProvider.addParameter(param);
    }
  }
  
  /// Toggle maintenance mode for testing
  static void toggleMaintenanceMode(BuildContext context) {
    final paramProvider = Provider.of<ParameterProvider>(context, listen: false);
    final params = paramProvider.parameters;
    
    for (int i = 0; i < params.length; i++) {
      if (params[i].key == 'maintenance_mode') {
        final currentValue = params[i].value;
        final newValue = currentValue == 'true' ? 'false' : 'true';
        paramProvider.updateParameter(i, Parameter(key: 'maintenance_mode', value: newValue));
        break;
      }
    }
  }
  
  /// Show test dialog with quick parameter changes
  static void showTestDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.7,
            maxWidth: MediaQuery.of(context).size.width * 0.9,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.science,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Parameter Testing',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Scrollable content
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Test the parameter integration:',
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      
                      // Setup Test Parameters Button
                      ElevatedButton.icon(
                        icon: const Icon(Icons.settings),
                        onPressed: () => setupTestParameters(context),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        label: const Text('Setup Test Parameters'),
                      ),
                      const SizedBox(height: 12),
                      
                      // Toggle Maintenance Mode Button
                      ElevatedButton.icon(
                        icon: const Icon(Icons.construction),
                        onPressed: () => toggleMaintenanceMode(context),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        label: const Text('Toggle Maintenance Mode'),
                      ),
                      const SizedBox(height: 20),
                      
                      // Quick Test Instructions
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Quick Test Guide:',
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '1. Setup Test Parameters\n'
                              '2. Toggle Maintenance Mode\n'
                              '3. Navigate to homepage to see welcome message\n'
                              '4. Add items to cart to test limits\n'
                              '5. Check free shipping progress',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Actions
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
