import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

class BarcodeScannerPage extends StatefulWidget {
  final void Function(String barcode)? onScanned;
  const BarcodeScannerPage({Key? key, this.onScanned}) : super(key: key);

  @override
  State<BarcodeScannerPage> createState() => _BarcodeScannerPageState();
}


class _BarcodeScannerPageState extends State<BarcodeScannerPage> {
  String? _errorMessage;
  bool _scanned = false;
  final MobileScannerController _controller = MobileScannerController();
  bool _torchOn = false;

  @override
  void initState() {
    super.initState();
    _checkCameraPermission();
  }

  Future<void> _checkCameraPermission() async {
    final status = await Permission.camera.status;
    if (status.isGranted) {
      setState(() => _errorMessage = null);
    } else if (status.isDenied || status.isRestricted) {
      final result = await Permission.camera.request();
      if (!result.isGranted) {
        setState(() {
          _errorMessage = 'Camera permission is required to scan barcodes. Please enable it in settings.';
        });
      } else {
        setState(() => _errorMessage = null);
      }
    } else if (status.isPermanentlyDenied) {
      setState(() {
        _errorMessage = 'Camera permission is permanently denied. Please enable it from app settings.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan Product Barcode')),
      body: Stack(
        children: [
          if (_errorMessage == null)
            MobileScanner(
              controller: _controller,
              onDetect: (BarcodeCapture capture) {
                final barcode = capture.barcodes.isNotEmpty ? capture.barcodes.first : null;
                final value = barcode?.rawValue;
                if (!_scanned && value != null) {
                  setState(() => _scanned = true);
                  // Delay pop to show feedback
                  Future.delayed(const Duration(milliseconds: 600), () {
                    if (mounted) {
                      widget.onScanned?.call(value);
                      Navigator.of(context).pop(value);
                    }
                  });
                }
              },
            ),
          // Error message overlay
          if (_errorMessage != null)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.7),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.error, color: Colors.red, size: 60),
                      SizedBox(height: 16),
                      Text(
                        _errorMessage!,
                        style: TextStyle(color: Colors.white, fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () async {
                          if (_errorMessage?.contains('settings') == true) {
                            await openAppSettings();
                          } else {
                            Navigator.of(context).pop();
                          }
                        },
                        child: Text('Close'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          // Scan feedback overlay
          if (_scanned)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green, width: 8),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Icon(Icons.check_circle, color: Colors.green, size: 100),
                ),
              ),
            ),
          // Torch/flashlight toggle button
          if (_errorMessage == null)
            Positioned(
              top: 24,
              right: 24,
              child: FloatingActionButton(
                mini: true,
                backgroundColor: Colors.black.withOpacity(0.6),
                onPressed: () async {
                  await _controller.toggleTorch();
                  setState(() {
                    _torchOn = !_torchOn;
                  });
                },
                child: Icon(
                  _torchOn ? Icons.flash_on : Icons.flash_off,
                  color: Colors.white,
                ),
                tooltip: _torchOn ? 'Turn off flashlight' : 'Turn on flashlight',
              ),
            ),
          // User guidance overlay
          Positioned(
            left: 0,
            right: 0,
            bottom: 40,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Align the barcode within the frame',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
