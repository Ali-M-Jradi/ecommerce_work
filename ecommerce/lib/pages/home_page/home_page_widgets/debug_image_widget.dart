import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:typed_data';

// Debug widget for testing image assets
class DebugImageWidget extends StatefulWidget {
  final String imagePath;
  
  const DebugImageWidget({
    super.key, 
    required this.imagePath,
  });

  @override
  State<DebugImageWidget> createState() => _DebugImageWidgetState();
}

class _DebugImageWidgetState extends State<DebugImageWidget> {
  String _status = 'Not started';
  String _details = '';
  Uint8List? _imageBytes;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _testImage();
  }

  Future<void> _testImage() async {
    if (widget.imagePath.isEmpty) {
      setState(() {
        _status = 'Empty path';
        _details = 'No image path provided';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _status = 'Loading...';
      _details = 'Testing local asset: ${widget.imagePath}';
    });

    final assetPath = widget.imagePath.contains('assets/') 
        ? widget.imagePath  
        : 'assets/images/${widget.imagePath}';

    try {
      setState(() {
        _details = 'Loading asset: $assetPath';
      });
      
      final byteData = await rootBundle.load(assetPath);
      final bytes = byteData.buffer.asUint8List();

      setState(() {
        _status = 'Success';
        _details = 'Asset loaded: $assetPath\nSize: ${bytes.length} bytes';
        _imageBytes = bytes;
        _isLoading = false;
      });

    } catch (e) {
      setState(() {
        _status = 'Failed';
        _details = 'Asset not found: $assetPath\nError: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Debug: ${widget.imagePath}',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            
            // Status indicator
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: _getStatusColor(),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  _status,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: _getStatusColor(),
                  ),
                ),
                const Spacer(),
                if (_isLoading)
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
              ],
            ),
            
            const SizedBox(height: 8),
            
            // Details
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.3),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                _details,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontFamily: 'monospace',
                ),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Image preview
            if (_imageBytes != null) ...[
              Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.memory(
                    _imageBytes!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.red.withOpacity(0.1),
                        child: const Center(
                          child: Icon(
                            Icons.broken_image,
                            color: Colors.red,
                            size: 32,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ] else if (_status == 'Failed') ...[
              Container(
                height: 80,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  border: Border.all(
                    color: Colors.red.withOpacity(0.3),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.broken_image,
                        color: Colors.red,
                        size: 24,
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Asset not found',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getStatusColor() {
    switch (_status) {
      case 'Success':
        return Colors.green;
      case 'Failed':
      case 'Empty path':
        return Colors.red;
      case 'Loading...':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
