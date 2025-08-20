import 'dart:convert';
import 'package:http/http.dart' as http;

class SiteImagesApiService {
  static String baseUrl = 'http://192.168.100.54:89';
  // Essential URLs only
  static const List<String> alternativeUrls = [
    'http://192.168.100.54:89', // Your network IP
    'http://10.0.2.2:89',       // Android emulator host
    'http://127.0.0.1:89',      // Localhost
    'http://localhost:89',      // Localhost alternate
  ];
  static const String imagesEndpoint = '/api/site-images';
  
  /// Fetches site images from the API
  static Future<List<Map<String, dynamic>>> fetchSiteImages() async {
    Exception? lastException;
    
    // Try each URL until one works
    for (final url in alternativeUrls) {
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
        ).timeout(const Duration(seconds: 5));
        
        print('📡 DEBUG: Response status: ${response.statusCode}');
        print('📄 DEBUG: Response body: ${response.body}');
        
        if (response.statusCode == 200) {
          // Update the base URL to the working one for image URL construction
          baseUrl = url;
          
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
