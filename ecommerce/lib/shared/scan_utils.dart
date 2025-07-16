import 'package:flutter/material.dart';
import '../pages/products_page/products_page_widgets/products_data_provider.dart';
import '../pages/products_page/products_page_widgets/product_details_dialog_widget.dart';

mixin ScanHistoryMixin<T extends StatefulWidget> on State<T> {
  final List<String> scanHistory = [];

  void handleBarcodeResult(BuildContext context, String result) {
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
    if (found.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) => ProductDetailsDialogWidget(product: found),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No product found for barcode: $result')),
      );
    }
  }

  void showScanHistoryDialog(BuildContext context) {
    final products = ProductsDataProvider.getDemoProducts();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Scan History'),
          content: SizedBox(
            width: double.maxFinite,
            child: scanHistory.isEmpty
                ? const Text('No scans yet.')
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: scanHistory.length,
                    itemBuilder: (context, index) {
                      final code = scanHistory[index];
                      final found = products.firstWhere(
                        (p) => p['barcode'] == code,
                        orElse: () => {},
                      );
                      return ListTile(
                        leading: const Icon(Icons.qr_code),
                        title: Text(code),
                        subtitle: found.isNotEmpty
                            ? Text(found['name'] is Map ? found['name']['en'] ?? '' : found['name'] ?? '')
                            : const Text('Not found'),
                        onTap: found.isNotEmpty
                            ? () {
                                Navigator.of(context).pop();
                                showDialog(
                                  context: context,
                                  builder: (context) => ProductDetailsDialogWidget(product: found),
                                );
                              }
                            : null,
                      );
                    },
                  ),
          ),
          actions: [
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
