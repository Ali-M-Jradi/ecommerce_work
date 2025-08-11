import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'dart:async';
import '../../../services/content_service.dart';

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
      _details = 'Testing image: ${widget.imagePath}';
    });

    final imageUrl = widget.imagePath.contains('http') 
        ? widget.imagePath  
        : '${ContentService.imageBaseUrl}${widget.imagePath}';

    try {
      final client = http.Client();
      
      setState(() {
        _details = 'Requesting: $imageUrl';
      });
      
      final response = await client.get(
        Uri.parse(imageUrl),
        headers: {
          'Accept': 'image/*',
          'User-Agent': 'Flutter Debug/1.0',
        },
      ).timeout(const Duration(seconds: 10));
      
      client.close();
      
      if (response.statusCode == 200) {
        setState(() {
          _status = 'Success ✅';
          _details = 'Status: ${response.statusCode}\n'
                    'Size: ${response.bodyBytes.length} bytes\n'
                    'Content-Type: ${response.headers['content-type'] ?? 'Unknown'}\n'
                    'URL: $imageUrl';
          _imageBytes = response.bodyBytes;
          _isLoading = false;
        });
      } else {
        setState(() {
          _status = 'HTTP Error ❌';
          _details = 'Status: ${response.statusCode}\n'
                    'URL: $imageUrl\n'
                    'Response: ${response.body.length > 200 ? '${response.body.substring(0, 200)}...' : response.body}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _status = 'Exception ❌';
        _details = 'Error: $e\nURL: $imageUrl';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _status.contains('Success') 
              ? Colors.green 
              : _status.contains('Error') || _status.contains('Exception')
                  ? Colors.red
                  : Colors.orange,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status row
          Row(
            children: [
              Text(
                _status,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _status.contains('Success') 
                      ? Colors.green 
                      : _status.contains('Error') || _status.contains('Exception')
                          ? Colors.red
                          : Colors.orange,
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
          
          // Image filename
          Text(
            'Image: ${widget.imagePath}',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Details
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                _details,
                style: TextStyle(
                  fontSize: 11,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                ),
              ),
            ),
          ),
          
          // Show image preview if loaded successfully
          if (_imageBytes != null) ...[
            const SizedBox(height: 8),
            Container(
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green, width: 1),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.memory(
                  _imageBytes!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.red.withOpacity(0.1),
                      child: Center(
                        child: Text(
                          'Image decode error',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
