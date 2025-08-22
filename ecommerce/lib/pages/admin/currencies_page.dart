import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../models/currency.dart';
import '../../providers/currency_provider.dart';

class CurrenciesPage extends StatefulWidget {
  const CurrenciesPage({super.key});

  @override
  State<CurrenciesPage> createState() => _CurrenciesPageState();
}

class _CurrenciesPageState extends State<CurrenciesPage> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Currencies Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCurrencyDialog(context),
            tooltip: 'Add Currency',
          ),
        ],
      ),
      body: Consumer<CurrencyProvider>(
        builder: (context, provider, _) {
          final filteredCurrencies = provider.currencies
              .where((currency) =>
                  currency.code.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                  currency.nameEn.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                  currency.nameAr.contains(_searchQuery) ||
                  currency.nameFr.toLowerCase().contains(_searchQuery.toLowerCase()))
              .toList();

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with search
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.monetization_on, color: Theme.of(context).primaryColor),
                            const SizedBox(width: 8),
                            const Expanded(
                              child: Text(
                                'Currency Management',
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            if (provider.defaultCurrency != null)
                              Flexible(
                                child: Chip(
                                  avatar: const Icon(Icons.star, size: 16, color: Colors.amber),
                                  label: Text('Default: ${provider.defaultCurrency!.code}'),
                                  backgroundColor: Colors.amber.shade50,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.search),
                            hintText: 'Search currencies...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            isDense: true,
                          ),
                          onChanged: (value) => setState(() => _searchQuery = value),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Currencies list
                Expanded(
                  child: filteredCurrencies.isEmpty
                      ? _buildEmptyState()
                      : LayoutBuilder(
                          builder: (context, constraints) {
                            final isWide = constraints.maxWidth > 600;
                            return isWide
                                ? _buildDataTable(filteredCurrencies, provider)
                                : _buildMobileList(filteredCurrencies, provider);
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.monetization_on_outlined, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'No currencies found',
            style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 8),
          Text(
            'Add currencies to manage exchange rates',
            style: TextStyle(color: Colors.grey.shade500),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => _showCurrencyDialog(context),
            icon: const Icon(Icons.add),
            label: const Text('Add Currency'),
          ),
        ],
      ),
    );
  }

  Widget _buildDataTable(List<Currency> currencies, CurrencyProvider provider) {
    return Card(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Code')),
            DataColumn(label: Text('Symbol')),
            DataColumn(label: Text('Name (EN)')),
            DataColumn(label: Text('Name (AR)')),
            DataColumn(label: Text('Name (FR)')),
            DataColumn(label: Text('Exchange Rate')),
            DataColumn(label: Text('Status')),
            DataColumn(label: Text('Actions')),
          ],
          rows: currencies.map((currency) => DataRow(
            cells: [
              DataCell(
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      currency.code,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: currency.isDefault ? Colors.amber.shade700 : null,
                      ),
                    ),
                    if (currency.isDefault) ...[
                      const SizedBox(width: 4),
                      Icon(Icons.star, size: 16, color: Colors.amber.shade700),
                    ],
                  ],
                ),
              ),
              DataCell(Text(currency.symbol)),
              DataCell(Text(currency.nameEn)),
              DataCell(Text(currency.nameAr)),
              DataCell(Text(currency.nameFr)),
              DataCell(Text(currency.exchangeRate.toStringAsFixed(4))),
              DataCell(
                Chip(
                  label: Text(
                    currency.isActive ? 'Active' : 'Inactive',
                    style: TextStyle(
                      color: currency.isActive ? Colors.green.shade700 : Colors.red.shade700,
                      fontSize: 12,
                    ),
                  ),
                  backgroundColor: currency.isActive ? Colors.green.shade50 : Colors.red.shade50,
                ),
              ),
              DataCell(
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, size: 20),
                      onPressed: () => _showCurrencyDialog(context, currency: currency),
                      tooltip: 'Edit',
                    ),
                    if (!currency.isDefault)
                      IconButton(
                        icon: Icon(Icons.star_border, size: 20, color: Colors.amber.shade700),
                        onPressed: () => _setAsDefault(currency, provider),
                        tooltip: 'Set as Default',
                      ),
                    IconButton(
                      icon: Icon(
                        currency.isActive ? Icons.visibility_off : Icons.visibility,
                        size: 20,
                        color: currency.isActive ? Colors.orange : Colors.green,
                      ),
                      onPressed: () => _toggleStatus(currency, provider),
                      tooltip: currency.isActive ? 'Deactivate' : 'Activate',
                    ),
                    if (!currency.isDefault)
                      IconButton(
                        icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                        onPressed: () => _confirmDelete(currency, provider),
                        tooltip: 'Delete',
                      ),
                  ],
                ),
              ),
            ],
          )).toList(),
        ),
      ),
    );
  }

  Widget _buildMobileList(List<Currency> currencies, CurrencyProvider provider) {
    return ListView.separated(
      itemCount: currencies.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final currency = currencies[index];
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      currency.code,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(width: 8),
                    Text(currency.symbol, style: const TextStyle(fontSize: 16)),
                    if (currency.isDefault) ...[
                      const SizedBox(width: 8),
                      Icon(Icons.star, size: 16, color: Colors.amber.shade700),
                    ],
                    const Spacer(),
                    Chip(
                      label: Text(
                        currency.isActive ? 'Active' : 'Inactive',
                        style: TextStyle(
                          color: currency.isActive ? Colors.green.shade700 : Colors.red.shade700,
                          fontSize: 12,
                        ),
                      ),
                      backgroundColor: currency.isActive ? Colors.green.shade50 : Colors.red.shade50,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text('English: ${currency.nameEn}'),
                Text('عربي: ${currency.nameAr}'),
                Text('Français: ${currency.nameFr}'),
                Text('Exchange Rate: ${currency.exchangeRate.toStringAsFixed(4)}'),
                const SizedBox(height: 12),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showCurrencyDialog(context, currency: currency),
                      tooltip: 'Edit',
                    ),
                    if (!currency.isDefault)
                      IconButton(
                        icon: Icon(Icons.star_border, color: Colors.amber.shade700),
                        onPressed: () => _setAsDefault(currency, provider),
                        tooltip: 'Set as Default',
                      ),
                    IconButton(
                      icon: Icon(
                        currency.isActive ? Icons.visibility_off : Icons.visibility,
                        color: currency.isActive ? Colors.orange : Colors.green,
                      ),
                      onPressed: () => _toggleStatus(currency, provider),
                      tooltip: currency.isActive ? 'Deactivate' : 'Activate',
                    ),
                    if (!currency.isDefault)
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _confirmDelete(currency, provider),
                        tooltip: 'Delete',
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showCurrencyDialog(BuildContext context, {Currency? currency}) {
    showDialog(
      context: context,
      builder: (context) => _CurrencyDialog(currency: currency),
    );
  }

  void _setAsDefault(Currency currency, CurrencyProvider provider) async {
    try {
      await provider.setDefaultCurrency(currency.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${currency.code} set as default currency')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _toggleStatus(Currency currency, CurrencyProvider provider) async {
    try {
      await provider.toggleCurrencyStatus(currency.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${currency.code} ${currency.isActive ? 'deactivated' : 'activated'}'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _confirmDelete(Currency currency, CurrencyProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Currency'),
        content: Text('Are you sure you want to delete ${currency.code}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await provider.deleteCurrency(currency.id);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${currency.code} deleted')),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _CurrencyDialog extends StatefulWidget {
  final Currency? currency;

  const _CurrencyDialog({this.currency});

  @override
  State<_CurrencyDialog> createState() => _CurrencyDialogState();
}

class _CurrencyDialogState extends State<_CurrencyDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _codeController;
  late TextEditingController _symbolController;
  late TextEditingController _nameEnController;
  late TextEditingController _nameArController;
  late TextEditingController _nameFrController;
  late TextEditingController _exchangeRateController;
  bool _isDefault = false;
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    final currency = widget.currency;
    _codeController = TextEditingController(text: currency?.code ?? '');
    _symbolController = TextEditingController(text: currency?.symbol ?? '');
    _nameEnController = TextEditingController(text: currency?.nameEn ?? '');
    _nameArController = TextEditingController(text: currency?.nameAr ?? '');
    _nameFrController = TextEditingController(text: currency?.nameFr ?? '');
    _exchangeRateController = TextEditingController(
      text: currency?.exchangeRate.toString() ?? '1.0',
    );
    _isDefault = currency?.isDefault ?? false;
    _isActive = currency?.isActive ?? true;
  }

  @override
  void dispose() {
    _codeController.dispose();
    _symbolController.dispose();
    _nameEnController.dispose();
    _nameArController.dispose();
    _nameFrController.dispose();
    _exchangeRateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.currency == null ? 'Add Currency' : 'Edit Currency',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _codeController,
                        decoration: const InputDecoration(
                          labelText: 'Currency Code',
                          hintText: 'e.g., USD',
                          border: OutlineInputBorder(),
                        ),
                        textCapitalization: TextCapitalization.characters,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Currency code is required';
                          }
                          if (value.trim().length != 3) {
                            return 'Currency code must be 3 characters';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _symbolController,
                        decoration: const InputDecoration(
                          labelText: 'Symbol',
                          hintText: 'e.g., \$',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Symbol is required';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameEnController,
                  decoration: const InputDecoration(
                    labelText: 'Name (English)',
                    hintText: 'e.g., US Dollar',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'English name is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameArController,
                  decoration: const InputDecoration(
                    labelText: 'Name (Arabic)',
                    hintText: 'e.g., دولار أمريكي',
                    border: OutlineInputBorder(),
                  ),
                  textDirection: TextDirection.rtl,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameFrController,
                  decoration: const InputDecoration(
                    labelText: 'Name (French)',
                    hintText: 'e.g., Dollar Américain',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _exchangeRateController,
                  decoration: const InputDecoration(
                    labelText: 'Exchange Rate (to USD)',
                    hintText: 'e.g., 1.0',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                  ],
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Exchange rate is required';
                    }
                    final rate = double.tryParse(value.trim());
                    if (rate == null || rate <= 0) {
                      return 'Enter a valid positive number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: CheckboxListTile(
                        title: const Text('Set as Default'),
                        value: _isDefault,
                        onChanged: (value) => setState(() => _isDefault = value ?? false),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    ),
                    Expanded(
                      child: CheckboxListTile(
                        title: const Text('Active'),
                        value: _isActive,
                        onChanged: (value) => setState(() => _isActive = value ?? true),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _saveCurrency,
                      child: Text(widget.currency == null ? 'Add' : 'Update'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _saveCurrency() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = Provider.of<CurrencyProvider>(context, listen: false);
    final code = _codeController.text.trim().toUpperCase();

    // Check for duplicate codes
    if (provider.codeExists(code, widget.currency?.id)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Currency code $code already exists'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final currency = Currency(
      id: widget.currency?.id ?? '',
      code: code,
      symbol: _symbolController.text.trim(),
      nameEn: _nameEnController.text.trim(),
      nameAr: _nameArController.text.trim(),
      nameFr: _nameFrController.text.trim(),
      exchangeRate: double.parse(_exchangeRateController.text.trim()),
      isDefault: _isDefault,
      isActive: _isActive,
    );

    try {
      if (widget.currency == null) {
        await provider.addCurrency(currency);
      } else {
        await provider.updateCurrency(widget.currency!.id, currency);
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.currency == null 
                  ? 'Currency added successfully' 
                  : 'Currency updated successfully',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }
}
