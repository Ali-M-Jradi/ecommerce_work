import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SiteImagesApiService {
  static String baseUrl = 'http://192.168.100.54:89';
  // Essential URLs only
  static const List<String> alternativeUrls = [
    'http://192.168.100.54:89', // Your network IP
  'http://192.168.137.1:89',  // Windows Mobile Hotspot host
    'http://10.0.2.2:89',       // Android emulator host
    'http://127.0.0.1:89',      // Localhost
    'http://localhost:89',      // Localhost alternate
  ];
  static const String imagesEndpoint = '/api/site-images';
  static const String manifestEndpoint = '/api/site-images/manifest';

  // Local persistence keys
  static const String _prefsManifestHashKey = 'site_images_manifest_hash';
  static const String _prefsFilenamesKey = 'site_images_filenames_json';
  static const String _prefsLastWorkingBaseUrlKey = 'site_images_last_working_base_url';

  static const Duration _networkTimeout = Duration(seconds: 2);

  static Future<List<String>> _prioritizedUrls() async {
    final prefs = await SharedPreferences.getInstance();
    final last = prefs.getString(_prefsLastWorkingBaseUrlKey);
    if (last == null || last.isEmpty) return alternativeUrls;
    // Move last working to front while preserving order of others and uniqueness
    final set = <String>{};
    final ordered = <String>[];
    void add(String u) {
      if (set.add(u)) ordered.add(u);
    }
    add(last);
    for (final u in alternativeUrls) {
      add(u);
    }
    return ordered;
  }
  
  /// Fetches site images from the API
  static Future<List<Map<String, dynamic>>> fetchSiteImages() async {
    Exception? lastException;
    final urls = await _prioritizedUrls();
    // Try each URL until one works
    for (final url in urls) {
      try {
        final uri = Uri.parse('$url$imagesEndpoint');
        print('🌐 DEBUG: Attempting to fetch from: $uri');
        
        final response = await http.get(
          uri,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'User-Agent': 'Flutter-Mobile-App/1.0',
            'Origin': 'flutter-app',
          },
        ).timeout(_networkTimeout);
        
        print('📡 DEBUG: Response status: ${response.statusCode}');
        print('📄 DEBUG: Response body: ${response.body}');
        
        if (response.statusCode == 200) {
          // Update the base URL to the working one for image URL construction
          baseUrl = url;
          try {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString(_prefsLastWorkingBaseUrlKey, baseUrl);
          } catch (_) {}
          
          final dynamic jsonData = json.decode(response.body);
          
          if (jsonData is List) {
            // Check if it's a list of strings (your API format) or maps
            if (jsonData.isNotEmpty) {
              if (jsonData[0] is String) {
                // Convert array of strings to array of maps with filename field
                return jsonData.map<Map<String, dynamic>>((filename) => {
                  'filename': filename.toString(),
                }).toList();
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
        } else {
          print('❌ DEBUG: HTTP Error ${response.statusCode}: ${response.body}');
          lastException = Exception('Failed to load images from $url. Status: ${response.statusCode}');
        }
      } catch (e) {
        print('❌ DEBUG: Connection failed to $url: $e');
        lastException = Exception('Connection failed to $url: $e');
        continue; // Try next URL
      }
    }
    
    // If all URLs failed, throw the last exception
    throw lastException ?? Exception('Network error: All connection attempts failed');
  }

  /// Manifest model (robust parsing for various shapes)
  static Future<_Manifest?> fetchManifest() async {
    Exception? lastException;
    final urls = await _prioritizedUrls();
    for (final url in urls) {
      try {
        final uri = Uri.parse('$url$manifestEndpoint');
        print('🌐 DEBUG: Fetching manifest from: $uri');
        final response = await http
            .get(
              uri,
              headers: {
                'Accept': 'application/json',
                'User-Agent': 'Flutter-Mobile-App/1.0',
              },
            )
            .timeout(_networkTimeout);

        print('📡 DEBUG: Manifest status: ${response.statusCode}');
        if (response.statusCode == 200) {
          baseUrl = url; // update working base
          try {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString(_prefsLastWorkingBaseUrlKey, baseUrl);
          } catch (_) {}
          final dynamic jsonData = json.decode(response.body);
          return _Manifest.fromDynamic(jsonData);
        } else if (response.statusCode == 304) {
          // Not Modified – treat as unchanged; we'll read from prefs
          baseUrl = url;
          return null;
        } else {
          lastException = Exception('Manifest HTTP ${response.statusCode}');
        }
      } catch (e) {
        print('❌ DEBUG: Manifest fetch failed for $url: $e');
        lastException = Exception('Manifest fetch failed for $url: $e');
        continue;
      }
    }
    if (lastException != null) throw lastException;
    return null;
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
    print('🎯 DEBUG: getCarouselImages() with manifest support');
    final prefs = await SharedPreferences.getInstance();
    final cachedHash = prefs.getString(_prefsManifestHashKey);
    final cachedFilenamesJson = prefs.getString(_prefsFilenamesKey);

    // 1) Try manifest endpoint (preferred)
    try {
      final manifest = await fetchManifest();
      if (manifest != null) {
        final filenames = manifest.files.isNotEmpty
            ? manifest.files
            : (manifest.fallbackFilesFromUnknown.isNotEmpty
                ? manifest.fallbackFilesFromUnknown
                : <String>[]);

        // Determine version
        final version = manifest.manifestHash?.isNotEmpty == true
            ? manifest.manifestHash!
            : _stableHashFromList(filenames);

        // Persist
        await prefs.setString(_prefsManifestHashKey, version);
        await prefs.setString(_prefsFilenamesKey, json.encode(filenames));

        // Build versioned URLs
        final urls = filenames
            .map((f) => _buildVersionedUrl(getImageUrlFromItem({'filename': f}), version))
            .where((u) => u.isNotEmpty)
            .toList();
        print('🎯 DEBUG: Manifest returned ${urls.length} urls (v=$version)');
        if (urls.isNotEmpty) return urls;
      } else {
        // 304/unchanged path – use cached filenames/version
        if (cachedFilenamesJson != null && cachedHash != null) {
          final filenames = List<String>.from(json.decode(cachedFilenamesJson));
          final urls = filenames
              .map((f) => _buildVersionedUrl(getImageUrlFromItem({'filename': f}), cachedHash))
              .where((u) => u.isNotEmpty)
              .toList();
          print('🎯 DEBUG: Manifest unchanged; using cached ${urls.length} urls (v=$cachedHash)');
          if (urls.isNotEmpty) return urls;
        }
      }
    } catch (e) {
      print('⚠️ DEBUG: Manifest unavailable, fallback to legacy list: $e');
    }

    // 2) Fallback to legacy images list endpoint
    try {
      final apiImages = await fetchSiteImages();
      final filenames = apiImages
          .map((item) => getImageUrlFromItem(item))
          .where((url) => url.isNotEmpty)
          .toList();

      // Legacy list may return full URLs; extract filename portion for versioning
      final fileNamesOnly = filenames.map((u) => _extractFilename(u)).toList();
      final version = _stableHashFromList(fileNamesOnly);

      // Persist
      await prefs.setString(_prefsManifestHashKey, version);
      await prefs.setString(_prefsFilenamesKey, json.encode(fileNamesOnly));

      // Rebuild as versioned URLs (ensures cache-busting only on change)
      final urls = fileNamesOnly
          .map((f) => _buildVersionedUrl(getImageUrlFromItem({'filename': f}), version))
          .where((u) => u.isNotEmpty)
          .toList();
      print('🎯 DEBUG: Legacy list produced ${urls.length} urls (v=$version)');
      return urls;
    } catch (e) {
      print('⚠️ DEBUG: Legacy list failed: $e');
    }

    // 3) Offline fallback: use cached filenames if available
    if (cachedFilenamesJson != null && cachedHash != null) {
      try {
        final filenames = List<String>.from(json.decode(cachedFilenamesJson));
        final urls = filenames
            .map((f) => _buildVersionedUrl(getImageUrlFromItem({'filename': f}), cachedHash))
            .where((u) => u.isNotEmpty)
            .toList();
        print('📦 DEBUG: Using cached ${urls.length} urls (v=$cachedHash)');
        if (urls.isNotEmpty) return urls;
      } catch (_) {}
    }

    // 4) Final placeholder fallback
    print('🎯 DEBUG: Using placeholder images');
    return [
      'https://picsum.photos/800/400?random=1&t=${DateTime.now().millisecondsSinceEpoch}',
      'https://picsum.photos/800/400?random=2&t=${DateTime.now().millisecondsSinceEpoch}',
      'https://picsum.photos/800/400?random=3&t=${DateTime.now().millisecondsSinceEpoch}',
      'https://picsum.photos/800/400?random=4&t=${DateTime.now().millisecondsSinceEpoch}',
    ];
  }

  /// Immediate cached URLs for fast first paint (may be empty). Does not hit network.
  static Future<List<String>> getCachedCarouselImages() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedHash = prefs.getString(_prefsManifestHashKey);
      final cachedFilenamesJson = prefs.getString(_prefsFilenamesKey);
      if (cachedHash == null || cachedFilenamesJson == null) return [];
      final filenames = List<String>.from(json.decode(cachedFilenamesJson));
      // Rebuild using current baseUrl guess; when network succeeds baseUrl will be updated
      final urls = filenames
          .map((f) => _buildVersionedUrl(getImageUrlFromItem({'filename': f}), cachedHash))
          .where((u) => u.isNotEmpty)
          .toList();
      return urls;
    } catch (_) {
      return [];
    }
  }

  // Build URL with version query param
  static String _buildVersionedUrl(String url, String version) {
    if (url.isEmpty) return '';
    final hasQuery = url.contains('?');
    final sep = hasQuery ? '&' : '?';
    return '$url${sep}v=$version';
  }

  // Extract filename from a URL or path
  static String _extractFilename(String urlOrPath) {
    final withoutQuery = urlOrPath.split('?').first;
    final parts = withoutQuery.split('/');
    return parts.isNotEmpty ? parts.last : withoutQuery;
  }

  // Stable hash (djb2) from list of strings
  static String _stableHashFromList(List<String> items) {
    final sorted = [...items]..sort();
    final input = sorted.join('|');
    int hash = 5381;
    for (int i = 0; i < input.length; i++) {
      hash = ((hash << 5) + hash) + input.codeUnitAt(i);
      hash &= 0x7fffffff; // keep positive 31-bit
    }
    return hash.toRadixString(16);
  }
}

// Private manifest structure with robust parsing
class _Manifest {
  final String? manifestHash;
  final List<String> files;

  // In case the response is a different shape but contains recognizable arrays
  final List<String> fallbackFilesFromUnknown;

  _Manifest({this.manifestHash, required this.files, this.fallbackFilesFromUnknown = const []});

  factory _Manifest.fromDynamic(dynamic data) {
    String? hash;
    List<String> files = [];
    List<String> fallback = [];

    if (data is Map<String, dynamic>) {
      if (data['manifestHash'] is String) hash = data['manifestHash'] as String;

      // Common shapes: files: [ { name, hash }, ... ] OR files: [ 'banner1.webp', ... ]
      if (data['files'] is List) {
        final list = data['files'] as List;
        if (list.isNotEmpty) {
          if (list.first is String) {
            files = List<String>.from(list);
          } else if (list.first is Map) {
            files = list
                .map((e) => (e as Map)[
                        ['name', 'filename', 'file', 'url'].firstWhere(
                              (k) => e.containsKey(k),
                              orElse: () => 'name',
                            )
                      ]?.toString() ?? '')
                .where((s) => s.isNotEmpty)
                .toList();
          }
        }
      } else {
        // Try to find any list of strings as fallback
        for (final v in data.values) {
          if (v is List && v.isNotEmpty && v.first is String) {
            fallback = List<String>.from(v);
            break;
          }
        }
      }
    } else if (data is List) {
      // If endpoint returns just an array
      if (data.isNotEmpty && data.first is String) {
        files = List<String>.from(data);
      } else if (data.isNotEmpty && data.first is Map) {
        files = data
            .map((e) => (e as Map)[
                    ['name', 'filename', 'file', 'url'].firstWhere(
                          (k) => e.containsKey(k),
                          orElse: () => 'name',
                        )
                  ]?.toString() ?? '')
            .where((s) => s.isNotEmpty)
            .toList();
      }
    }

    return _Manifest(
      manifestHash: hash,
      files: files,
      fallbackFilesFromUnknown: fallback,
    );
  }
}
