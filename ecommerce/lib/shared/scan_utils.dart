import 'package:flutter/material.dart';
import '../pages/products_page/products_page_widgets/products_data_provider.dart';
import '../pages/products_page/products_page_widgets/product_details_dialog_widget.dart';
import '../models/product.dart';


mixin ScanHistoryMixin<T extends StatefulWidget> on State<T> {
  final List<String> scanHistory = [];

  Map<String, dynamic> handleBarcodeResult(BuildContext context, String result) {
    if (!scanHistory.contains(result)) {
      setState(() {
        scanHistory.insert(0, result);
        if (scanHistory.length > 20) scanHistory.removeLast();
      });
    }
    final products = ProductsDataProvider.getDemoProducts();
    final found = products.firstWhere(
      (p) => p['barcode'] == result,
      orElse: () => {},
    );
    return found;
  }


  void showScanHistoryDialog(BuildContext context) {
    final products = ProductsDataProvider.getDemoProducts();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Icon(Icons.history, color: Theme.of(context).colorScheme.primary, size: 28),
              const SizedBox(width: 10),
              const Text('Scan History'),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: scanHistory.isEmpty
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.info_outline, color: Colors.grey, size: 40),
                      const SizedBox(height: 12),
                      Text('No scans yet.', style: TextStyle(color: Colors.grey[700], fontSize: 16)),
                    ],
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    itemCount: scanHistory.length,
                    separatorBuilder: (context, idx) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final code = scanHistory[index];
                      final found = products.firstWhere(
                        (p) => p['barcode'] == code,
                        orElse: () => {},
                      );
                      return ListTile(
                        leading: Icon(
                          found.isNotEmpty ? Icons.qr_code_2 : Icons.error_outline,
                          color: found.isNotEmpty ? Theme.of(context).colorScheme.primary : Colors.red,
                        ),
                        title: Text(code, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: found.isNotEmpty
                            ? Text(found['name'] is Map ? found['name']['en'] ?? '' : found['name'] ?? '', style: TextStyle(color: Theme.of(context).colorScheme.onSurface))
                            : const Text('Not found', style: TextStyle(color: Colors.red)),
                        trailing: found.isNotEmpty
                            ? Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.primary)
                            : null,
                        onTap: found.isNotEmpty
                            ? () {
                                Navigator.of(context).pop();
                                showDialog(
                                  context: context,
                                  builder: (context) => ProductDetailsDialogWidget(product: Product.fromMap(found)),
                                );
                              }
                            : null,
                      );
                    },
                  ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  scanHistory.clear();
                });
                Navigator.of(context).pop();
              },
              child: const Text('Clear History'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
