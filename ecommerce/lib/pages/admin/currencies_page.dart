import 'package:flutter/material.dart';

class CurrenciesPage extends StatelessWidget {
  const CurrenciesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Currencies')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // AddOrEditCurrency Form
            Container(
              padding: const EdgeInsets.all(24),
              margin: const EdgeInsets.only(bottom: 32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('AddOrEditCurrency', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _CurrencyTextField(label: 'Code')),
                      const SizedBox(width: 8),
                      Expanded(child: _CurrencyTextField(label: 'مواصفات')),
                      const SizedBox(width: 8),
                      Expanded(child: _CurrencyTextField(label: 'Description (EN)')),
                      const SizedBox(width: 8),
                      Expanded(child: _CurrencyTextField(label: 'Description (FR)')),
                      const SizedBox(width: 8),
                      Expanded(child: _CurrencyTextField(label: 'Exchange Rate', initialValue: '0')),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      ),
                      child: const Text('SAVE'),
                    ),
                  ),
                ],
              ),
            ),
            // Table
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: DataTable(
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
                rows: [
                  DataRow(cells: [
                    const DataCell(Text('1')),
                    const DataCell(Text('FCFA')),
                    const DataCell(Text('FCFA')),
                    const DataCell(Text('FCFA')),
                    const DataCell(Text('FCFA')),
                    const DataCell(Text('0.000000')),
                    DataCell(IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {},
                    )),
                    DataCell(IconButton(
                      icon: Icon(Icons.close, color: Colors.red),
                      onPressed: () {},
                    )),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CurrencyTextField extends StatelessWidget {
  final String label;
  final String? initialValue;
  const _CurrencyTextField({required this.label, this.initialValue});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: initialValue != null ? TextEditingController(text: initialValue) : null,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        isDense: true,
      ),
    );
  }
}
