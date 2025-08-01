import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import '../pages/products_page/products_page_widgets/products_data_provider.dart';
import '../pages/products_page/products_page_widgets/product_details_dialog_widget.dart';


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

  Future<void> _shareBarcode(BuildContext context, String code) async {
    // Use share_plus if available, fallback to clipboard
    try {
      // ignore: import_of_legacy_library_into_null_safe
      // ignore: unused_import
      await Share.share(code);
    } catch (_) {
      Clipboard.setData(ClipboardData(text: code));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Copied to clipboard (share unavailable)')),
      );
    }
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
              Icon(Icons.history, color: Colors.deepPurple, size: 28),
              SizedBox(width: 10),
              Text('Scan History'),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: scanHistory.isEmpty
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.info_outline, color: Colors.grey, size: 40),
                      SizedBox(height: 12),
                      Text('No scans yet.', style: TextStyle(color: Colors.grey[700], fontSize: 16)),
                    ],
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    itemCount: scanHistory.length,
                    separatorBuilder: (context, idx) => Divider(height: 1),
                    itemBuilder: (context, index) {
                      final code = scanHistory[index];
                      final found = products.firstWhere(
                        (p) => p['barcode'] == code,
                        orElse: () => {},
                      );
                      return ListTile(
                        leading: Icon(
                          found.isNotEmpty ? Icons.qr_code_2 : Icons.error_outline,
                          color: found.isNotEmpty ? Colors.deepPurple : Colors.red,
                        ),
                        title: Text(code, style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: found.isNotEmpty
                            ? Text(found['name'] is Map ? found['name']['en'] ?? '' : found['name'] ?? '', style: TextStyle(color: Colors.deepPurple))
                            : Text('Not found', style: TextStyle(color: Colors.red)),
                        trailing: found.isNotEmpty
                            ? Icon(Icons.chevron_right, color: Colors.deepPurple)
                            : null,
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
