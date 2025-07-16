import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../pages/products_page/barcode_scanner_page.dart';
import '../pages/base_page/base_page_widgets/floating_action_buttons_widget.dart';
import 'scan_utils.dart';

/// Controller/mixin for unified scan FAB logic
mixin UnifiedScanFabMixin<T extends StatefulWidget> on State<T>, ScanHistoryMixin<T> {
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
                leading: const Icon(Icons.layers),
                title: const Text('Bulk Scan'),
                onTap: () async {
                  Navigator.of(context).pop();
                  await handleBulkScan(context);
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
                child: Text(status.isPermanentlyDenied ? 'Open Settings' : 'OK'),
              ),
            ],
          ),
        );
      }
      return;
    }
    final result = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (context) => BarcodeScannerPage(),
      ),
    );
    if (result != null) {
      handleBarcodeResult(context, result);
    }
  }

  Future<void> handleScanFromPhoto(BuildContext context) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile == null) {
        // User cancelled
        return;
      }
      final controller = MobileScannerController();
      final barcodeCapture = await controller.analyzeImage(pickedFile.path);
      if (barcodeCapture != null && barcodeCapture.barcodes.isNotEmpty && barcodeCapture.barcodes.first.rawValue != null) {
        handleBarcodeResult(context, barcodeCapture.barcodes.first.rawValue!);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No barcode found in the selected image.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to scan image: $e')),
      );
    }
  }

  Future<void> handleBulkScan(BuildContext context) async {
    final List<String> bulkResults = [];
    bool continueScanning = true;
    while (continueScanning) {
      final result = await Navigator.of(context).push<String>(
        MaterialPageRoute(
          builder: (context) => BarcodeScannerPage(),
        ),
      );
      if (result != null && result.isNotEmpty) {
        if (!bulkResults.contains(result)) {
          bulkResults.add(result);
        }
        continueScanning = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Bulk Scan'),
                content: Text('Scanned: $result\n\nScan another?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Finish'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Scan Another'),
                  ),
                ],
              ),
            ) ?? false;
      } else {
        continueScanning = false;
      }
    }
    if (bulkResults.isNotEmpty) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Bulk Scan Results'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: bulkResults.length,
              itemBuilder: (context, index) {
                final code = bulkResults[index];
                return ListTile(
                  leading: const Icon(Icons.qr_code),
                  title: Text(code),
                  trailing: IconButton(
                    icon: const Icon(Icons.info_outline),
                    onPressed: () {
                      handleBarcodeResult(context, code);
                    },
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  for (final code in bulkResults) {
                    if (!scanHistory.contains(code)) {
                      scanHistory.insert(0, code);
                      if (scanHistory.length > 20) scanHistory.removeLast();
                    }
                  }
                });
                Navigator.of(context).pop();
              },
              child: const Text('Add All to History'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        ),
      );
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
