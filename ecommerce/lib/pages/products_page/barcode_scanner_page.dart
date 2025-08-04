import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

class BarcodeScannerPage extends StatefulWidget {
  final void Function(String barcode)? onScanned;
  const BarcodeScannerPage({super.key, this.onScanned});

  @override
  State<BarcodeScannerPage> createState() => _BarcodeScannerPageState();
}


class _BarcodeScannerPageState extends State<BarcodeScannerPage> with WidgetsBindingObserver {
  String? _errorMessage;
  bool _scanned = false;
  final MobileScannerController _controller = MobileScannerController();
  bool _torchOn = false;

  @override
  @override
  void initState() {
    super.initState();
    _checkCameraPermission();
    // Fallback: forcibly pop after 5 seconds if not scanned
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted && !_scanned) {
        debugPrint('[Scan] Fallback timeout reached, popping BarcodeScannerPage with null');
        _scanned = true;
        Navigator.of(context).pop();
      }
    });
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
        _errorMessage = 'permanently_denied';
      });
    }
  }

  // Re-check permission when returning from app settings
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkCameraPermission();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('[Scan] BarcodeScannerPage build called');
    return Scaffold(
      appBar: AppBar(title: const Text('Scan Product Barcode')),
      body: Stack(
        children: [
          if (_errorMessage == null)
            MobileScanner(
              controller: _controller,
              onDetect: (BarcodeCapture capture) {
                debugPrint('[Scan] MobileScanner onDetect called');
                final barcode = capture.barcodes.isNotEmpty ? capture.barcodes.first : null;
                final value = barcode?.rawValue;
                debugPrint('[Scan] Detected barcode value: $value');
                if (!_scanned && value != null) {
                  setState(() => _scanned = true);
                  debugPrint('[Scan] Barcode detected, will pop with value: $value');
                  // Delay pop to show feedback
                  Future.delayed(const Duration(milliseconds: 600), () {
                    if (mounted) {
                      debugPrint('[Scan] Actually popping BarcodeScannerPage with value: $value');
                      widget.onScanned?.call(value);
                      Navigator.of(context).pop(value);
                    }
                  });
                }
              },
              // Ensure scanner is enabled
              fit: BoxFit.cover,
            ),
          // Scan area overlay (centered frame)
          if (_errorMessage == null)
            Center(
              child: Container(
                width: 260,
                height: 180,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.deepPurple, width: 4),
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.deepPurple.withOpacity(0.08),
                ),
                child: Center(
                  child: Text(
                    'Align barcode here',
                    style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          // Settings button overlay (top left) - always visible
          Positioned(
            top: 24,
            left: 24,
            child: ElevatedButton.icon(
              icon: Icon(Icons.settings, color: Colors.white),
              label: Text('Settings', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black.withOpacity(0.7),
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                elevation: 0,
              ),
              onPressed: () async {
                await openAppSettings();
              },
            ),
          ),
          // Error message overlay
    if (_errorMessage != null)
      Positioned.fill(
        child: Container(
          color: Colors.black.withOpacity(0.7),
          child: Center(
            child: _errorMessage == 'permanently_denied'
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error, color: Colors.red, size: 48),
                      const SizedBox(height: 16),
                      const Text(
                        'Camera permission permanently denied.\nPlease enable it in app settings.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.settings),
                        label: const Text('Open Settings'),
                        onPressed: () async {
                          await openAppSettings();
                        },
                      ),
                    ],
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error, color: Colors.red, size: 48),
                      const SizedBox(height: 16),
                      Text(
                        _errorMessage ?? '',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
          ),
        ),
      ),
          // ...removed green checkmark and border overlay...
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
