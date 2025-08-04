import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AttributesPage extends StatefulWidget {
  const AttributesPage({super.key});

  @override
  State<AttributesPage> createState() => _AttributesPageState();
}

class _AttributesPageState extends State<AttributesPage> {
  int _nextId = 3;
  final List<Map<String, dynamic>> _attributes = [
    {
      'id': 2,
      'description': 'color',
      'type': 'List',
      'displayStyle': 'CheckBox',
      'optionList': true,
    },
  ];

  final _descController = TextEditingController();
  String _type = 'Numeric';
  String _displayStyle = 'None';

  void _addAttribute() {
    if (_descController.text.trim().isEmpty) return;
    setState(() {
      _attributes.add({
        'id': _nextId++,
        'description': _descController.text.trim(),
        'type': _type,
        'displayStyle': _displayStyle,
        'optionList': _type == 'List',
      });
      _descController.clear();
      _type = 'Numeric';
      _displayStyle = 'None';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Attributes')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _attributes.length,
                separatorBuilder: (context, idx) => const SizedBox(height: 10),
                itemBuilder: (context, idx) {
                  final attr = _attributes[idx];
                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.outline.withOpacity(0.18),
                        width: 1.2,
                      ),
                    ),
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                attr['description']?.toString() ?? '',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                              const Spacer(),
                              IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                onPressed: () {},
                                tooltip: 'Edit',
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.close,
                                  color: Theme.of(context).colorScheme.error,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _attributes.remove(attr);
                                  });
                                },
                                tooltip: 'Delete',
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            children: [
                              _AttributeChip(
                                label: 'Type',
                                value: attr['type']?.toString() ?? '',
                                color: Theme.of(context).colorScheme.primaryContainer,
                              ),
                              _AttributeChip(
                                label: 'Display',
                                value: attr['displayStyle']?.toString() ?? '',
                                color: Theme.of(context).colorScheme.secondaryContainer,
                              ),
                              if (attr['optionList'] == true)
                                _AttributeChip(
                                  label: 'Option List',
                                  value: 'Yes',
                                  icon: Icons.list,
                                  color: Theme.of(context).colorScheme.tertiaryContainer,
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Theme.of(context).colorScheme.background,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Add Attribute',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _descController,
                        decoration: InputDecoration(
                          labelText: 'Description',
                          border: const OutlineInputBorder(),
                          isDense: true,
                          labelStyle: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                        ),
                        style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z0-9\s]'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Text(
                            'Type:',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Wrap(
                              spacing: 8,
                              children: [
                                ChoiceChip(
                                  label: const Text('Numeric'),
                                  selected: _type == 'Numeric',
                                  onSelected: (_) =>
                                      setState(() => _type = 'Numeric'),
                                  selectedColor: Theme.of(context).colorScheme.primaryContainer,
                                  labelStyle: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer),
                                ),
                                ChoiceChip(
                                  label: const Text('Text'),
                                  selected: _type == 'Text',
                                  onSelected: (_) =>
                                      setState(() => _type = 'Text'),
                                  selectedColor: Theme.of(context).colorScheme.primaryContainer,
                                  labelStyle: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer),
                                ),
                                ChoiceChip(
                                  label: const Text('Date'),
                                  selected: _type == 'Date',
                                  onSelected: (_) =>
                                      setState(() => _type = 'Date'),
                                  selectedColor: Theme.of(context).colorScheme.primaryContainer,
                                  labelStyle: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer),
                                ),
                                ChoiceChip(
                                  label: const Text('List'),
                                  selected: _type == 'List',
                                  onSelected: (_) =>
                                      setState(() => _type = 'List'),
                                  selectedColor: Theme.of(context).colorScheme.primaryContainer,
                                  labelStyle: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Text(
                            'Display Style:',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Wrap(
                              spacing: 8,
                              children: [
                                ChoiceChip(
                                  label: const Text('None'),
                                  selected: _displayStyle == 'None',
                                  onSelected: (_) =>
                                      setState(() => _displayStyle = 'None'),
                                  selectedColor: Theme.of(context).colorScheme.secondaryContainer,
                                  labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSecondaryContainer),
                                ),
                                ChoiceChip(
                                  label: const Text('option List'),
                                  selected: _displayStyle == 'option List',
                                  onSelected: (_) => setState(
                                    () => _displayStyle = 'option List',
                                  ),
                                  selectedColor: Theme.of(context).colorScheme.secondaryContainer,
                                  labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSecondaryContainer),
                                ),
                                ChoiceChip(
                                  label: const Text('CheckBox'),
                                  selected: _displayStyle == 'CheckBox',
                                  onSelected: (_) => setState(
                                    () => _displayStyle = 'CheckBox',
                                  ),
                                  selectedColor: Theme.of(context).colorScheme.secondaryContainer,
                                  labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSecondaryContainer),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.add_circle),
                          label: const Text('Add'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            foregroundColor: Theme.of(context).colorScheme.onPrimary,
                          ),
                          onPressed: _addAttribute,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AttributeChip extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;
  final Color? color;
  const _AttributeChip({
    required this.label,
    required this.value,
    this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: icon != null
          ? Icon(icon, size: 16, color: Theme.of(context).colorScheme.primary)
          : null,
      label: Text(
        '$label: $value',
        style: TextStyle(
          fontSize: 13,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      backgroundColor: color ?? Theme.of(context).colorScheme.surfaceVariant,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    );
  }
}
