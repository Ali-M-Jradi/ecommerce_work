import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../pages/products_page/barcode_scanner_page.dart';
import '../pages/base_page/base_page_widgets/floating_action_buttons_widget.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import '../pages/products_page/products_page_widgets/product_details_dialog_widget.dart';
import 'scan_utils.dart';
import '../../main.dart'; // Import navigatorKey for global navigation
import '../models/product.dart';

/// Controller/mixin for unified scan FAB logic
/// Unified scan FAB logic with feedback
mixin UnifiedScanFabMixin<T extends StatefulWidget>
    on State<T>, ScanHistoryMixin<T> {
  Future<void> showScanOptionsModal(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.qr_code_scanner),
                title: const Text('Scan with Camera'),
                onTap: () async {
                  Navigator.of(context).pop();
                  await handleScanWithCamera(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Scan from Photo'),
                onTap: () async {
                  Navigator.of(context).pop();
                  await handleScanFromPhoto(context);
                },
              ),

              ListTile(
                leading: const Icon(Icons.history),
                title: const Text('Scan History'),
                onTap: () {
                  Navigator.of(context).pop();
                  showScanHistoryDialog(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> handleScanWithCamera(BuildContext context) async {
    final status = await Permission.camera.status;
    bool granted = false;
    if (status.isGranted) {
      granted = true;
    } else if (status.isDenied || status.isRestricted) {
      final result = await Permission.camera.request();
      granted = result.isGranted;
    } else if (status.isPermanentlyDenied) {
      granted = false;
    }
    if (!granted) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Camera Permission Required'),
            content: Text(
              status.isPermanentlyDenied
                  ? 'Camera permission is permanently denied. Please enable it from app settings.'
                  : 'Camera access is required to scan barcodes. Please enable camera permission in your device settings.',
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  if (status.isPermanentlyDenied) {
                    await openAppSettings();
                  } else {
                    Navigator.of(context).pop();
                  }
                },
                child: Text(
                  status.isPermanentlyDenied ? 'Open Settings' : 'OK',
                ),
              ),
            ],
          ),
        );
      }
      return;
    }
    // No loading indicator
    String? scanResult = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (context) => const BarcodeScannerPage()),
    );
    debugPrint('[Scan] BarcodeScannerPage returned result: $scanResult');
    final globalContext = navigatorKey.currentState?.context ?? context;
    if (scanResult != null) {
      debugPrint('[Scan] handleScanWithCamera received non-null result: $scanResult');
      final found = handleBarcodeResult(context, scanResult);
      debugPrint('[Scan] handleBarcodeResult found: $found');
      if (found.isNotEmpty) {
        debugPrint('[Scan] Showing ProductDetailsDialogWidget');
        showDialog(
          context: globalContext,
          useRootNavigator: true,
          builder: (context) => ProductDetailsDialogWidget(product: Product.fromMap(found)),
        );
      } else {
        debugPrint('[Scan] Showing Product Not Found dialog');
        showDialog(
          context: globalContext,
          useRootNavigator: true,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Row(
              children: [
                Icon(Icons.error_outline, color: Colors.red, size: 32),
                SizedBox(width: 12),
                Text('Product Not Found'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Barcode:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SelectableText(
                  scanResult,
                  style: const TextStyle(color: Colors.deepPurple),
                ),
                const SizedBox(height: 12),
                Text(
                  'No product matches this barcode.',
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: scanResult));
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Copied to clipboard')),
                  );
                },
                child: const Text('Copy'),
              ),
              TextButton(
                onPressed: () async {
                  await Share.share(scanResult);
                },
                child: const Text('Share'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          ),
        );
      }
    } else {
      debugPrint('[Scan] handleScanWithCamera received null result');
      showDialog(
        context: globalContext,
        useRootNavigator: true,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Row(
            children: [
              Icon(Icons.error_outline, color: Colors.red, size: 32),
              SizedBox(width: 12),
              Text('Scan Failed'),
            ],
          ),
          content: const Text('No barcode was detected. Please try again.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> handleScanFromPhoto(BuildContext context) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile == null) {
        Navigator.of(
          context,
          rootNavigator: true,
        ).pop(); // Remove loading indicator
        // User cancelled
        return;
      }
      final controller = MobileScannerController();
      final barcodeCapture = await controller.analyzeImage(pickedFile.path);
      Navigator.of(
        context,
        rootNavigator: true,
      ).pop(); // Remove loading indicator
      if (barcodeCapture != null &&
          barcodeCapture.barcodes.isNotEmpty &&
          barcodeCapture.barcodes.first.rawValue != null) {
        final result = barcodeCapture.barcodes.first.rawValue!;
        final found = handleBarcodeResult(context, result);
        if (found.isNotEmpty) {
          showDialog(
            context: context,
            builder: (context) => ProductDetailsDialogWidget(product: Product.fromMap(found)),
          );
        } else {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.red, size: 32),
                  SizedBox(width: 12),
                  Text('Product Not Found'),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Barcode:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SelectableText(
                    result,
                    style: const TextStyle(color: Colors.deepPurple),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No product matches this barcode.',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: result));
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Copied to clipboard')),
                    );
                  },
                  child: const Text('Copy'),
                ),
                TextButton(
                  onPressed: () async {
                    await Share.share(result);
                  },
                  child: const Text('Share'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Close'),
                ),
              ],
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No barcode found in the selected image.'),
          ),
        );
      }
    } catch (e) {
      Navigator.of(
        context,
        rootNavigator: true,
      ).pop(); // Remove loading indicator
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to scan image: $e')));
    }
  }
}

/// Unified FAB widget for all pages
class UnifiedScanFab extends StatelessWidget {
  final VoidCallback? onLoyaltyPressed;
  final VoidCallback? onContactPressed;
  final VoidCallback? onScanPressed;
  final String? heroTagPrefix;
  const UnifiedScanFab({
    super.key,
    this.onLoyaltyPressed,
    this.onContactPressed,
    this.onScanPressed,
    this.heroTagPrefix,
  });
  @override
  Widget build(BuildContext context) {
    return FloatingActionButtonsWidget(
      heroTagPrefix: heroTagPrefix,
      onLoyaltyPressed: onLoyaltyPressed,
      onContactPressed: onContactPressed,
      onScanBarcodePressed: onScanPressed,
    );
  }
}
