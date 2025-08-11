import 'package:http/http.dart' as http;
import 'dart:convert';

void main() async {
  print('🔍 Testing API and Image Loading...\n');
  
  // Test 1: Check API connection
  await testApiConnection();
  
  // Test 2: Check image URLs
  await testImageUrls();
}

Future<void> testApiConnection() async {
  print('1. Testing API Connection to http://localhost:89/api/site-content');
  
  try {
    final client = http.Client();
    final response = await client.get(
      Uri.parse('http://localhost:89/api/site-content'),
      headers: {'Content-Type': 'application/json'},
    ).timeout(Duration(seconds: 10));
    
    print('   Status Code: ${response.statusCode}');
    
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      print('   ✅ API Connection Successful - Found ${data.length} content items');
      
      // Find carousel images
      final carouselItems = data.where((item) => 
        item['pageName']?.toString().toLowerCase() == 'home' &&
        item['section']?.toString().toLowerCase() == 'carouselimage'
      ).toList();
      
      print('   📸 Found ${carouselItems.length} carousel images:');
      for (var item in carouselItems) {
        print('     - ${item['description']}: ${item['contentData']}');
      }
    } else {
      print('   ❌ API Error: Status ${response.statusCode}');
      print('   Response: ${response.body}');
    }
    
    client.close();
    
  } catch (e) {
    print('   ❌ API Connection Failed: $e');
  }
  
  print('');
}

Future<void> testImageUrls() async {
  print('2. Testing Image URL Loading');
  
  // Sample image URLs from the API data
  final testImages = [
    'bc670748-abbc-44ec-95be-5568ce110bd2_CrossFamily_HPbanner_V1_Desktop_2880x1000_4.webp',
    '40f0910d-461e-4b2c-9bee-7884687947ab_showImageResized.webp',
    '8679de9d-3877-42c0-a8a4-eaea0de2afd3_1.webp',
  ];
  
  for (String imageName in testImages) {
    await testSingleImage(imageName);
  }
}

Future<void> testSingleImage(String imageName) async {
  final imageUrl = 'http://localhost:89/images/$imageName';
  
  try {
    final client = http.Client();
    final response = await client.get(Uri.parse(imageUrl))
        .timeout(Duration(seconds: 15));
    
    if (response.statusCode == 200) {
      print('   ✅ Image loaded: $imageName (${response.bodyBytes.length} bytes)');
    } else {
      print('   ❌ Image failed: $imageName - Status ${response.statusCode}');
    }
    
    client.close();
    
  } catch (e) {
    print('   ❌ Image error: $imageName - Error: $e');
  }
}
