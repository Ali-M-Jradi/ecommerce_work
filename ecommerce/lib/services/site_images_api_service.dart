import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// Carries which base URL succeeded and its response
class _HttpResult {
  final String base;
  final http.Response response;
  _HttpResult(this.base, this.response);
}

class SiteImagesApiService {
  static String baseUrl = 'https://localhost:7184';
  // Use HTTP port 5000 for mobile dev (preferred) and HTTPS 7184 as fallback
  static const List<String> alternativeUrls = [
    'http://192.168.137.1:5000',   // Windows hotspot IP - HTTP (preferred for mobile)
    'http://192.168.100.54:5000',  // Ethernet IP - HTTP (preferred for mobile)
    'https://192.168.137.1:7184', // Windows hotspot IP - HTTPS fallback
    'https://192.168.100.54:7184', // Ethernet IP - HTTPS fallback
    'http://localhost:5000',       // HTTP localhost
    'https://localhost:7184',      // HTTPS localhost fallback
    'http://10.0.2.2:5000',        // Android emulator host - HTTP
    'http://127.0.0.1:5000',       // Localhost IP - HTTP
  ];
  static const String imagesEndpoint = '/api/site-images'; // Can also use '/api/site-images/manifest' for caching/version checks
  static const Duration _networkTimeout = Duration(seconds: 2);
  static const String _prefsLastWorkingBaseUrlKey = 'last_working_base_url';

  static Future<List<String>> _getPrioritizedUrls() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final last = prefs.getString(_prefsLastWorkingBaseUrlKey);
      if (last == null || last.isEmpty) return List<String>.from(alternativeUrls);
      final list = List<String>.from(alternativeUrls);
      // Move last to front if present; otherwise prepend
      list.remove(last);
      return [last, ...list];
    } catch (_) {
      return List<String>.from(alternativeUrls);
    }
  }

  /// Internal helper to carry which base responded
  static Future<_HttpResult> _tryAllHosts(String endpoint, {Map<String, String>? headers}) async {
    final urls = await _getPrioritizedUrls();
    final completer = Completer<_HttpResult>();
    int remaining = urls.length;
    Exception? lastErr;

    for (final url in urls) {
      // Fire all attempts without awaiting (parallel)
      () async {
        final uri = Uri.parse('$url$endpoint');
        if (!completer.isCompleted) {
          print('🌐 DEBUG: Attempting to fetch from: $uri');
        }
        try {
          final response = await http
              .get(uri, headers: headers)
              .timeout(_networkTimeout);
          if (!completer.isCompleted || response.statusCode == 200) {
            print('📡 DEBUG: Response status ${response.statusCode} from $url');
          }
          if (response.statusCode == 200 && !completer.isCompleted) {
            // Persist last working base URL
            try {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString(_prefsLastWorkingBaseUrlKey, url);
            } catch (_) {}
            completer.complete(_HttpResult(url, response));
            return;
          } else {
            lastErr = Exception('HTTP ${response.statusCode} at $url');
          }
        } catch (e) {
          if (!completer.isCompleted) {
            print('❌ DEBUG: Connection failed to $url: $e');
          }
          lastErr = Exception('Failed $url: $e');
        } finally {
          remaining--;
          if (remaining == 0 && !completer.isCompleted) {
            completer.completeError(lastErr ?? Exception('All hosts failed'));
          }
        }
      }();
    }

    return completer.future;
  }
  
  /// Fetches site images from the API
  static Future<List<Map<String, dynamic>>> fetchSiteImages() async {
    try {
      final result = await _tryAllHosts(
        imagesEndpoint,
        headers: const {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'User-Agent': 'Flutter-Mobile-App/1.0',
          'Origin': 'flutter-app',
        },
      );

  // Update working base URL for subsequent image URL construction
  baseUrl = result.base;

      final dynamic jsonData = json.decode(result.response.body);
      if (jsonData is List) {
        // Check if it's a list of strings (your API format) or maps
        if (jsonData.isNotEmpty) {
          if (jsonData[0] is String) {
            // Convert array of strings to array of maps with filename field
            return jsonData
                .map<Map<String, dynamic>>((filename) => {
                      'filename': filename.toString(),
                    })
                .toList();
          } else {
            // If response is directly a list of maps
            return List<Map<String, dynamic>>.from(jsonData);
          }
        } else {
          return []; // Empty list
        }
      } else if (jsonData is Map && jsonData.containsKey('data')) {
        // If response has a 'data' wrapper
        final List<dynamic> imagesList = jsonData['data'];
        return List<Map<String, dynamic>>.from(imagesList);
      } else if (jsonData is Map && jsonData.containsKey('images')) {
        // If response has an 'images' wrapper
        final List<dynamic> imagesList = jsonData['images'];
        return List<Map<String, dynamic>>.from(imagesList);
      } else {
        // Try to extract any array from the response
        final Map<String, dynamic> dataMap = jsonData;
        for (final value in dataMap.values) {
          if (value is List) {
            return List<Map<String, dynamic>>.from(value);
          }
        }

        // If it's a single object, wrap it in a list
        return [Map<String, dynamic>.from(jsonData)];
      }
    } catch (e) {
      throw Exception('Network error: All connection attempts failed: $e');
    }
  }
  
  /// Extracts image URL from API response item and constructs full URL
  static String getImageUrlFromItem(Map<String, dynamic> item) {
    // Try common field names for image URLs/filenames
    final possibleFields = [
      'filename', 'imageUrl', 'image_url', 'url', 'name', 'file'
    ];
    
    String? imageValue;
    
    for (final field in possibleFields) {
      if (item.containsKey(field) && item[field] != null) {
        imageValue = item[field].toString().trim();
        break;
      }
    }
    
    // If no specific field found, use first string value
    if (imageValue == null || imageValue.isEmpty) {
      for (final value in item.values) {
        if (value is String && value.isNotEmpty) {
          imageValue = value.toString().trim();
          break;
        }
      }
    }
    
    if (imageValue == null || imageValue.isEmpty) {
      return '';
    }
    
    // If it's already a full URL, return as is
    if (imageValue.startsWith('http://') || imageValue.startsWith('https://')) {
      return imageValue;
    }
    
    // If it starts with '/', it's an absolute path on the server
    if (imageValue.startsWith('/')) {
      return '$baseUrl$imageValue';
    }
    
    // If it's just a filename, construct the full URL
    final cleanFilename = imageValue.replaceAll(RegExp(r'^[/\\]+'), '');
    return '$baseUrl/$cleanFilename';
  }
  
  /// Gets a formatted list of carousel images from API
  static Future<List<String>> getCarouselImages() async {
    print('🎯 DEBUG: getCarouselImages() called - starting API fetch...');
    try {
      print('🎯 DEBUG: About to call fetchSiteImages()...');
      final apiImages = await fetchSiteImages();
      print('🎯 DEBUG: fetchSiteImages() returned ${apiImages.length} images');
      
      final carouselImages = apiImages.map((item) {
        return getImageUrlFromItem(item);
      }).where((url) => url.isNotEmpty).toList();
      
      print('🎯 DEBUG: Processed ${carouselImages.length} valid carousel URLs');
      return carouselImages;
    } catch (e) {
      print('🎯 DEBUG: API fetch failed, using fallback: $e');
      // Fallback to placeholder images when API fails
      return [
        'https://picsum.photos/800/400?random=1&t=${DateTime.now().millisecondsSinceEpoch}',
        'https://picsum.photos/800/400?random=2&t=${DateTime.now().millisecondsSinceEpoch}',
        'https://picsum.photos/800/400?random=3&t=${DateTime.now().millisecondsSinceEpoch}',
        'https://picsum.photos/800/400?random=4&t=${DateTime.now().millisecondsSinceEpoch}',
      ];
    }
  }
}
