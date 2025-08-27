import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

/// Service to manage app colors from site-content API
class ColorService {
  static const String baseUrl = 'https://localhost:7184/api';
  static const Duration timeoutDuration = Duration(seconds: 10);

  /// Create HTTP client with SSL bypass for localhost
  static http.Client _createHttpClient() {
    final client = HttpClient()
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    return IOClient(client);
  }

  /// Get all available colors from the API
  static Future<List<ColorOption>> getAvailableColors() async {
    final client = _createHttpClient();
    
    try {
      print('🎨 Fetching available colors from: $baseUrl/site-content');
      
      final response = await client.get(
        Uri.parse('$baseUrl/site-content'),
        headers: {
          'accept': '*/*',
          'Content-Type': 'application/json',
        },
      ).timeout(timeoutDuration);

      print('📊 Colors API Response Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        
        // Filter items that are colors (pageName: "AllPages", section: "Color")
        final colorItems = jsonData.where((item) => 
          item['pageName']?.toString().toLowerCase() == 'allpages' &&
          item['section']?.toString().toLowerCase() == 'color'
        ).toList();

        List<ColorOption> colors = [];
        for (var item in colorItems) {
          final colorName = item['description']?.toString() ?? '';
          final colorValue = item['contentData']?.toString() ?? '';
          
          if (colorName.isNotEmpty && colorValue.isNotEmpty && colorValue.startsWith('#')) {
            try {
              final color = Color(int.parse(colorValue.replaceFirst('#', '0xff')));
              colors.add(ColorOption(
                id: item['id'] ?? 0,
                name: colorName,
                displayName: _formatColorName(colorName),
                hexValue: colorValue,
                color: color,
              ));
            } catch (e) {
              print('⚠️ Invalid color format: $colorValue for $colorName');
            }
          }
        }

        print('✅ Found ${colors.length} valid colors from API');
        return colors;
      } else {
        throw Exception('Failed to load colors: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error fetching colors: $e');
      print('🔧 Falling back to default colors');
      
      // Return default colors as fallback
      return _getDefaultColors();
    } finally {
      client.close();
    }
  }

  /// Add a new color to the API
  @Deprecated('Color CRUD via UI removed — prefer site-content management API. Keep for migration only.')
  static Future<bool> addColor(String name, String hexValue) async {
    final client = _createHttpClient();
    
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/site-content'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'contentData': hexValue,
          'pageName': 'AllPages',
          'section': 'Color',
          'description': name,
        }),
      ).timeout(timeoutDuration);

      print('📊 Add color response: ${response.statusCode}');
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('❌ Error adding color: $e');
      return false;
    } finally {
      client.close();
    }
  }

  /// Update an existing color in the API
  @Deprecated('Color CRUD via UI removed — prefer site-content management API. Keep for migration only.')
  static Future<bool> updateColor(int id, String name, String hexValue) async {
    final client = _createHttpClient();
    
    try {
      final response = await client.put(
        Uri.parse('$baseUrl/site-content/$id'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'id': id,
          'contentData': hexValue,
          'pageName': 'AllPages',
          'section': 'Color',
          'description': name,
        }),
      ).timeout(timeoutDuration);

      return response.statusCode == 200;
    } catch (e) {
      print('❌ Error updating color: $e');
      return false;
    } finally {
      client.close();
    }
  }

  /// Delete a color from the API
  @Deprecated('Color CRUD via UI removed — prefer site-content management API. Keep for migration only.')
  static Future<bool> deleteColor(int id) async {
    final client = _createHttpClient();
    
    try {
      final response = await client.delete(
        Uri.parse('$baseUrl/site-content/$id'),
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(timeoutDuration);

      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      print('❌ Error deleting color: $e');
      return false;
    } finally {
      client.close();
    }
  }

  /// Format color name for display
  static String _formatColorName(String name) {
    switch (name.toLowerCase()) {
      case 'maincolor':
        return 'Main Brand Color';
      case 'secondarycolor':
        return 'Secondary Color';
      case 'thirdcolor':
        return 'Third Color';
      default:
        // Convert camelCase or PascalCase to readable format
        return name
            .replaceAllMapped(RegExp(r'([A-Z])'), (match) => ' ${match.group(1)}')
            .replaceAll('_', ' ')
            .trim()
            .split(' ')
            .map((word) => word.isNotEmpty ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}' : '')
            .join(' ');
    }
  }

  /// Get default colors as fallback
  static List<ColorOption> _getDefaultColors() {
    // Keep fallback minimal: only include the three authoritative theme colors
    return [
      ColorOption(
        id: -1,
        name: 'MainColor',
        displayName: 'Main Brand Color',
        hexValue: '#056099',
        color: const Color(0xff056099),
      ),
      ColorOption(
        id: -2,
        name: 'SecondaryColor',
        displayName: 'Secondary Color',
        hexValue: '#ffffff',
        color: const Color(0xffffffff),
      ),
      ColorOption(
        id: -3,
        name: 'ThirdColor',
        displayName: 'Third Color',
        hexValue: '#222022',
        color: const Color(0xff222022),
      ),
    ];
  }
}

/// Model for color option
class ColorOption {
  final int id;
  final String name;
  final String displayName;
  final String hexValue;
  final Color color;

  ColorOption({
    required this.id,
    required this.name,
    required this.displayName,
    required this.hexValue,
    required this.color,
  });

  /// Create copy with modified values
  ColorOption copyWith({
    int? id,
    String? name,
    String? displayName,
    String? hexValue,
    Color? color,
  }) {
    return ColorOption(
      id: id ?? this.id,
      name: name ?? this.name,
      displayName: displayName ?? this.displayName,
      hexValue: hexValue ?? this.hexValue,
      color: color ?? this.color,
    );
  }

  @override
  String toString() {
    return 'ColorOption(id: $id, name: $name, displayName: $displayName, hexValue: $hexValue)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ColorOption && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
