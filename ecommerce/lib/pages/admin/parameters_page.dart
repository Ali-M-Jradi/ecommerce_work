import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/parameter.dart';
import '../../providers/parameter_provider.dart';

class ParametersPage extends StatelessWidget {
  const ParametersPage({super.key});

  @override
  Widget build(BuildContext context) {
    const recommendedParameters = [
      {
        'key': 'shipping_tax',
        'desc': 'Shipping tax percentage (e.g. 5)',
      },
      {
        'key': 'free_shipping_threshold',
        'desc': 'Minimum order value for free shipping (e.g. 50)',
      },
      {
        'key': 'support_email',
        'desc': 'Customer support email address',
      },
      {
        'key': 'support_phone',
        'desc': 'Customer support phone number',
      },
      {
        'key': 'maintenance_mode',
        'desc': 'Show maintenance banner (true/false)',
      },
      {
        'key': 'app_version_message',
        'desc': 'Message to show users about app updates',
      },
      {
        'key': 'default_currency',
        'desc': 'Default currency code (e.g. USD)',
      },
      {
        'key': 'welcome_message',
        'desc': 'Welcome message for users',
      },
      {
        'key': 'discount_rate',
        'desc': 'Global discount rate (%)',
      },
      {
        'key': 'max_cart_items',
        'desc': 'Maximum items allowed in cart',
      },
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Parameters')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Consumer<ParameterProvider>(
            builder: (context, provider, _) {
              final isWide = constraints.maxWidth > 600;
              final searchController = TextEditingController();
              List<Parameter> filtered = provider.parameters;
              return StatefulBuilder(
                builder: (context, setState) {
                  void doSearch(String query) {
                    setState(() {
                      filtered = provider.parameters.where((p) =>
                        p.key.toLowerCase().contains(query.toLowerCase()) ||
                        p.value.toLowerCase().contains(query.toLowerCase()) ||
                        p.description.toLowerCase().contains(query.toLowerCase())
                      ).toList();
                    });
                  }
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Card(
                            color: Colors.blue.shade50,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Recommended Parameters', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                  const SizedBox(height: 8),
                                  ...recommendedParameters.map((p) => Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 120,
                                          child: Text(
                                            p['key']!,
                                            style: const TextStyle(fontWeight: FontWeight.w600),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Flexible(
                                                child: Text(
                                                  p['desc']!,
                                                  style: const TextStyle(color: Colors.black54),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              const SizedBox(width: 4),
                                              Tooltip(
                                                message: p['desc']!,
                                                child: IconButton(
                                                  icon: const Icon(Icons.info_outline, size: 16, color: Colors.blueGrey),
                                                  padding: EdgeInsets.zero,
                                                  constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
                                                  onPressed: () => _showRecommendedParameterInfo(context, p),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('App Parameters', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                              ElevatedButton.icon(
                                icon: const Icon(Icons.add),
                                label: const Text('Add'),
                                onPressed: () => _showEditDialog(context, provider),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: searchController,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.search),
                              hintText: 'Search parameters...',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            onChanged: doSearch,
                          ),
                          const SizedBox(height: 16),
                          if (filtered.isEmpty)
                            Container(
                              padding: const EdgeInsets.all(32),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.settings_outlined,
                                    size: 64,
                                    color: Colors.grey.shade400,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No parameters found',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey.shade600,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Add parameters to control app behavior',
                                    style: TextStyle(
                                      color: Colors.grey.shade500,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            )
                          else
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: filtered.length,
                              separatorBuilder: (_, __) => const SizedBox(height: 8),
                              itemBuilder: (context, idx) {
                                final param = filtered[idx];
                                final origIdx = provider.parameters.indexOf(param);
                                final valueController = TextEditingController(text: param.value);
                                // Fix: always treat description as non-null string
                                final descController = TextEditingController(text: param.description);
                                final paramDescription = param.description;
                                return Card(
                                  elevation: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                    child: isWide
                                        ? Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Flexible(
                                                          child: Text(param.key, style: const TextStyle(fontWeight: FontWeight.bold)),
                                                        ),
                                                        if (paramDescription.isNotEmpty) ...[
                                                          Tooltip(
                                                            message: paramDescription,
                                                            child: IconButton(
                                                              icon: const Icon(Icons.info_outline, size: 18, color: Colors.blueGrey),
                                                              padding: EdgeInsets.zero,
                                                              constraints: const BoxConstraints(),
                                                              onPressed: () => _showParameterInfo(context, param),
                                                            ),
                                                          ),
                                                        ],
                                                      ],
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Row(
                                                      children: [
                                                        Flexible(
                                                          child: TextField(
                                                            controller: valueController,
                                                            decoration: const InputDecoration(
                                                              labelText: 'Value',
                                                              border: OutlineInputBorder(),
                                                              isDense: true,
                                                            ),
                                                            onSubmitted: (val) {
                                                              provider.updateParameter(origIdx, param.copyWith(value: val));
                                                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Value updated')));
                                                            },
                                                          ),
                                                        ),
                                                        const SizedBox(width: 8),
                                                        Flexible(
                                                          child: TextField(
                                                            controller: descController,
                                                            decoration: const InputDecoration(
                                                              labelText: 'Description',
                                                              border: OutlineInputBorder(),
                                                              isDense: true,
                                                            ),
                                                            onSubmitted: (val) {
                                                              provider.updateParameter(origIdx, param.copyWith(description: val));
                                                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Description updated')));
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              IconButton(
                                                icon: const Icon(Icons.edit),
                                                tooltip: 'Edit key',
                                                onPressed: () => _showEditDialog(context, provider, param: param, index: origIdx),
                                              ),
                                              IconButton(
                                                icon: const Icon(Icons.delete, color: Colors.red),
                                                tooltip: 'Delete',
                                                onPressed: () => _confirmDelete(context, provider, origIdx),
                                              ),
                                            ],
                                          )
                                        : Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(param.key, style: const TextStyle(fontWeight: FontWeight.bold)),
                                                  if (paramDescription.isNotEmpty)
                                                    Tooltip(
                                                      message: paramDescription,
                                                      child: const Padding(
                                                        padding: EdgeInsets.only(left: 4.0),
                                                        child: Icon(Icons.info_outline, size: 16, color: Colors.blueGrey),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                              const SizedBox(height: 4),
                                              TextField(
                                                controller: valueController,
                                                decoration: const InputDecoration(
                                                  labelText: 'Value',
                                                  border: OutlineInputBorder(),
                                                  isDense: true,
                                                ),
                                                onSubmitted: (val) {
                                                  provider.updateParameter(origIdx, param.copyWith(value: val));
                                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Value updated')));
                                                },
                                              ),
                                              const SizedBox(height: 8),
                                              TextField(
                                                controller: descController,
                                                decoration: const InputDecoration(
                                                  labelText: 'Description',
                                                  border: OutlineInputBorder(),
                                                  isDense: true,
                                                ),
                                                onSubmitted: (val) {
                                                  provider.updateParameter(origIdx, param.copyWith(description: val));
                                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Description updated')));
                                                },
                                              ),
                                              Row(
                                                children: [
                                                  IconButton(
                                                    icon: const Icon(Icons.edit),
                                                    tooltip: 'Edit key',
                                                    onPressed: () => _showEditDialog(context, provider, param: param, index: origIdx),
                                                  ),
                                                  IconButton(
                                                    icon: const Icon(Icons.delete, color: Colors.red),
                                                    tooltip: 'Delete',
                                                    onPressed: () => _confirmDelete(context, provider, origIdx),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                  ),
                                );
                              },
                            ),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  void _showEditDialog(BuildContext context, ParameterProvider provider, {Parameter? param, int? index, String? defaultKey, String? defaultValue, String? defaultDescription}) {
    final keyController = TextEditingController(text: param?.key ?? defaultKey ?? '');
    final valueController = TextEditingController(text: param?.value ?? defaultValue ?? '');
    final descController = TextEditingController(text: param?.description ?? defaultDescription ?? '');
    final formKey = GlobalKey<FormState>();
    String? errorText;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Dialog(
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
                        param == null ? Icons.add : Icons.edit,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        param == null ? 'Add Parameter' : 'Edit Parameter',
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
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: keyController,
                            decoration: InputDecoration(
                              labelText: 'Key',
                              border: const OutlineInputBorder(),
                              hintText: 'e.g., maintenance_mode',
                              errorText: errorText,
                            ),
                            validator: (val) {
                              final key = val?.trim() ?? '';
                              if (key.isEmpty) return 'Key is required';
                              if (provider.keyExists(key, index)) return 'Key already exists';
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: valueController,
                            decoration: const InputDecoration(
                              labelText: 'Value',
                              border: OutlineInputBorder(),
                              hintText: 'e.g., true',
                            ),
                            validator: (val) => (val?.trim().isEmpty ?? true) ? 'Value is required' : null,
                            maxLines: 3,
                            minLines: 1,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: descController,
                            decoration: const InputDecoration(
                              labelText: 'Description',
                              border: OutlineInputBorder(),
                              hintText: 'Describe what this parameter controls',
                            ),
                            maxLines: 2,
                            minLines: 1,
                          ),
                        ],
                      ),
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
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState?.validate() ?? false) {
                            final key = keyController.text.trim();
                            final value = valueController.text.trim();
                            final desc = descController.text.trim();
                            if (param == null) {
                              provider.addParameter(Parameter(key: key, value: value, description: desc));
                            } else if (index != null) {
                              provider.updateParameter(index, Parameter(key: key, value: value, description: desc));
                            }
                            Navigator.pop(context);
                          } else {
                            setState(() {});
                          }
                        },
                        child: const Text('Save'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, ParameterProvider provider, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Parameter'),
        content: const Text('Are you sure you want to delete this parameter?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              provider.deleteParameter(index);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showRecommendedParameterInfo(BuildContext context, Map<String, String> paramData) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.lightbulb_outline, color: Colors.amber.shade700),
            const SizedBox(width: 8),
            const Flexible(child: Text('Recommended Parameter')),
          ],
        ),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Parameter Key
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 80,
                    child: Text('Key:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                  ),
                  Expanded(
                    child: SelectableText(
                      paramData['key'] ?? 'Unknown',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Recommended Value
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 80,
                    child: Text('Default:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                  ),
                  Expanded(
                    child: SelectableText(
                      paramData['value'] ?? '',
                      style: const TextStyle(fontFamily: 'monospace', color: Colors.green),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Description
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 80,
                    child: Text('About:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                  ),
                  Expanded(
                    child: SelectableText(
                      paramData['desc'] ?? 'No description available',
                      style: const TextStyle(color: Colors.black87),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Action hint
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.tips_and_updates, size: 16, color: Colors.blue.shade700),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'This is a recommended parameter for optimal app performance. You can add it using the "Add Parameter" button.',
                        style: TextStyle(fontSize: 12, color: Colors.blue.shade700),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Pre-fill the dialog with recommended parameter data
              final provider = Provider.of<ParameterProvider>(context, listen: false);
              _showEditDialog(
                context, 
                provider, 
                param: null, 
                index: null,
                defaultKey: paramData['key'] ?? '',
                defaultValue: paramData['value'] ?? '',
                defaultDescription: paramData['desc'] ?? '',
              );
            },
            child: const Text('Add This Parameter'),
          ),
        ],
      ),
    );
  }

  void _showParameterInfo(BuildContext context, Parameter param) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.info_outline, color: Colors.blue),
            SizedBox(width: 8),
            Flexible(child: Text('Parameter Info')),
          ],
        ),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Parameter Key
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 80,
                    child: Text('Key:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                  ),
                  Expanded(
                    child: SelectableText(
                      param.key,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Parameter Value
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 80,
                    child: Text('Value:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                  ),
                  Expanded(
                    child: SelectableText(
                      param.value,
                      style: const TextStyle(fontFamily: 'monospace'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Parameter Description
              if (param.description.isNotEmpty) ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: 80,
                      child: Text('Description:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                    ),
                    Expanded(
                      child: SelectableText(
                        param.description,
                        style: const TextStyle(color: Colors.black87),
                      ),
                    ),
                  ],
                ),
              ] else ...[
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 80,
                      child: Text('Description:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                    ),
                    Expanded(
                      child: Text(
                        'No description available',
                        style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
