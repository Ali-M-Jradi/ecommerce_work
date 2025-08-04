import 'package:flutter/material.dart';

class Currency {
  int id;
  String symbol;
  String descriptionAr;
  String descriptionEn;
  String descriptionFr;
  double exchangeRate;

  Currency({
    required this.id,
    required this.symbol,
    required this.descriptionAr,
    required this.descriptionEn,
    required this.descriptionFr,
    required this.exchangeRate,
  });
}

class CurrenciesPage extends StatefulWidget {
  const CurrenciesPage({super.key});

  @override
  State<CurrenciesPage> createState() => _CurrenciesPageState();
}

class _CurrenciesPageState extends State<CurrenciesPage> {
  final List<Currency> _currencies = [
    Currency(
      id: 1,
      symbol: 'FCFA',
      descriptionAr: 'FCFA',
      descriptionEn: 'FCFA',
      descriptionFr: 'FCFA',
      exchangeRate: 0.0,
    ),
  ];
  int _nextId = 2;

  void _showCurrencyDialog({Currency? currency}) {
    final isEdit = currency != null;
    final symbolController = TextEditingController(text: currency?.symbol ?? '');
    final descArController = TextEditingController(text: currency?.descriptionAr ?? '');
    final descEnController = TextEditingController(text: currency?.descriptionEn ?? '');
    final descFrController = TextEditingController(text: currency?.descriptionFr ?? '');
    final exchangeRateController = TextEditingController(text: currency?.exchangeRate.toString() ?? '0');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEdit ? 'Edit Currency' : 'Add Currency'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: symbolController,
                decoration: const InputDecoration(labelText: 'Code'),
              ),
              TextField(
                controller: descArController,
                decoration: const InputDecoration(labelText: 'مواصفات'),
              ),
              TextField(
                controller: descEnController,
                decoration: const InputDecoration(labelText: 'Description (EN)'),
              ),
              TextField(
                controller: descFrController,
                decoration: const InputDecoration(labelText: 'Description (FR)'),
              ),
              TextField(
                controller: exchangeRateController,
                decoration: const InputDecoration(labelText: 'Exchange Rate'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final symbol = symbolController.text.trim();
              final descAr = descArController.text.trim();
              final descEn = descEnController.text.trim();
              final descFr = descFrController.text.trim();
              final rate = double.tryParse(exchangeRateController.text) ?? 0.0;
              setState(() {
                if (isEdit) {
                  final idx = _currencies.indexWhere((c) => c.id == currency.id);
                  if (idx != -1) {
                    _currencies[idx] = Currency(
                      id: currency.id,
                      symbol: symbol,
                      descriptionAr: descAr,
                      descriptionEn: descEn,
                      descriptionFr: descFr,
                      exchangeRate: rate,
                    );
                  }
                } else {
                  _currencies.add(Currency(
                    id: _nextId++,
                    symbol: symbol,
                    descriptionAr: descAr,
                    descriptionEn: descEn,
                    descriptionFr: descFr,
                    exchangeRate: rate,
                  ));
                }
              });
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(isEdit ? 'Currency updated!' : 'Currency added!')),
              );
            },
            child: Text(isEdit ? 'Save' : 'Add'),
          ),
        ],
      ),
    );
  }

  void _deleteCurrency(int id) {
    setState(() {
      _currencies.removeWhere((c) => c.id == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Currency deleted!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Currencies')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Currency List', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text('Add Currency'),
                      onPressed: () => _showCurrencyDialog(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columnSpacing: 20,
                      headingRowColor: MaterialStateProperty.all(Theme.of(context).colorScheme.primary.withOpacity(0.1)),
                      columns: const [
                        DataColumn(label: Text('ID')),
                        DataColumn(label: Text('Symbol')),
                        DataColumn(label: Text('مواصفات')),
                        DataColumn(label: Text('Description (EN)')),
                        DataColumn(label: Text('Description (FR)')),
                        DataColumn(label: Text('Exchange Rate')),
                        DataColumn(label: Text('Edit')),
                        DataColumn(label: Text('Delete')),
                      ],
                      rows: _currencies.map((c) => DataRow(cells: [
                        DataCell(Text(c.id.toString())),
                        DataCell(Text(c.symbol)),
                        DataCell(Text(c.descriptionAr)),
                        DataCell(Text(c.descriptionEn)),
                        DataCell(Text(c.descriptionFr)),
                        DataCell(Text(c.exchangeRate.toStringAsFixed(6))),
                        DataCell(IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _showCurrencyDialog(currency: c),
                        )),
                        DataCell(IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteCurrency(c.id),
                        )),
                      ])).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
