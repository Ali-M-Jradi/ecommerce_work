// import 'dart:convert';
// import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/content_item.dart';

class ContentService {
  static const String baseUrl = 'http://localhost:89/api'; // Your actual API URL
  static const String imageBaseUrl = 'http://localhost:89/images/'; // Your image server URL
  static const Duration timeoutDuration = Duration(seconds: 30);

  /// Create HTTP client that can handle insecure connections for localhost
  static http.Client _createHttpClient() {
    final client = http.Client();
    return client;
  }

  /// Fetch all content items from the API
  static Future<List<ContentItem>> fetchContentItems() async {
    final client = _createHttpClient();
    
    try {
      // Use your actual API endpoint
      final response = await client.get(
        Uri.parse('$baseUrl/site-content'),
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(timeoutDuration);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map<ContentItem>((json) => ContentItem.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load content: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching content items: $e');
      // Return mock data as fallback if API fails
      final mockData = await _getMockData();
      return mockData.map<ContentItem>((json) => ContentItem.fromJson(json)).toList();
    } finally {
      client.close();
    }
  }

  /// Update content item via API
  static Future<bool> updateContentItem(ContentItem item) async {
    final client = _createHttpClient();
    
    try {
      final response = await client.put(
        Uri.parse('$baseUrl/site-content/${item.id}'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(item.toJson()),
      ).timeout(timeoutDuration);

      return response.statusCode == 200;
    } catch (e) {
      print('Error updating content item: $e');
      return false;
    } finally {
      client.close();
    }
  }

  /// Create new content item via API
  static Future<ContentItem?> createContentItem(ContentItem item) async {
    final client = _createHttpClient();
    
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/site-content'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(item.toJson()),
      ).timeout(timeoutDuration);

      if (response.statusCode == 201 || response.statusCode == 200) {
        return ContentItem.fromJson(json.decode(response.body));
      }
      return null;
    } catch (e) {
      print('Error creating content item: $e');
      return null;
    } finally {
      client.close();
    }
  }

  /// Test API connection
  static Future<bool> testConnection() async {
    final client = _createHttpClient();
    
    try {
      print('Testing connection to: $baseUrl/site-content');
      final response = await client.get(
        Uri.parse('$baseUrl/site-content'),
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      print('Connection test response: ${response.statusCode}');
      return response.statusCode == 200;
    } catch (e) {
      print('Connection test failed: $e');
      return false;
    } finally {
      client.close();
    }
  }

  /// Delete content item via API
  static Future<bool> deleteContentItem(int itemId) async {
    final client = _createHttpClient();
    
    try {
      final response = await client.delete(
        Uri.parse('$baseUrl/site-content/$itemId'),
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(timeoutDuration);

      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      print('Error deleting content item: $e');
      return false;
    } finally {
      client.close();
    }
  }

  /// Mock data based on your API response
  static Future<List<Map<String, dynamic>>> _getMockData() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    return [
      {
        "id": 1,
        "contentData": "03815860 - 01275019",
        "pageName": "home",
        "section": "UpperBanner",
        "description": "PhoneNumber"
      },
      {
        "id": 2,
        "contentData": "Beirut, Lebanon",
        "pageName": "home",
        "section": "UpperBanner",
        "description": "Location"
      },
      {
        "id": 3,
        "contentData": "Test1",
        "pageName": "footer",
        "section": "SocialMedia",
        "description": "FaceBook"
      },
      {
        "id": 4,
        "contentData": "ifj",
        "pageName": "footer",
        "section": "SocialMedia",
        "description": "Instagram"
      },
      {
        "id": 5,
        "contentData": "geeg",
        "pageName": "footer",
        "section": "SocialMedia",
        "description": "Whatsapp"
      },
      {
        "id": 6,
        "contentData": "503075a9-9071-4067-9b48-d810bd386328_logo 5.png",
        "pageName": "footer",
        "section": "Logo",
        "description": "Logo image"
      },
      {
        "id": 8,
        "contentData": "c64754d0-7e70-42f4-ba08-a916f7fa39df_banner2.jpg",
        "pageName": "home",
        "section": "UpperBanner",
        "description": "UpperBannerPhoto"
      },
      {
        "id": 9,
        "contentData": "Free Shipping",
        "pageName": "home",
        "section": "MovingBanner",
        "description": "MovingText1"
      },
      {
        "id": 10,
        "contentData": "24/7 Support",
        "pageName": "home",
        "section": "MovingBanner",
        "description": "MovingText2"
      },
      {
        "id": 11,
        "contentData": "Money Back Warranty",
        "pageName": "home",
        "section": "MovingBanner",
        "description": "MovingText3"
      },
      {
        "id": 12,
        "contentData": "All Products is Eco",
        "pageName": "home",
        "section": "MovingBanner",
        "description": "MovingText4"
      },
      {
        "id": 13,
        "contentData": "0a18e74f-a023-46b1-8966-4eb912f6789e_pback2.jpg",
        "pageName": "home",
        "section": "MovingBanner",
        "description": "LandingImage"
      },
      {
        "id": 14,
        "contentData": "Test it",
        "pageName": "home",
        "section": "NumberOne",
        "description": "NumberOneText1"
      },
      {
        "id": 15,
        "contentData": "Pellentesque in ipsum id orci porta dapibus. Vivamus magna                             justo, lacinia eget consectetur sed, convallis at tellus.",
        "pageName": "home",
        "section": "NumberOne",
        "description": "NumberOneText2"
      },
      {
        "id": 16,
        "contentData": "Pellentesque in ipsum id orci porta dapibus. Vivamus magna                             justo, lacinia eget consectetur sed, convallis at tellus.",
        "pageName": "home",
        "section": "NumberOne",
        "description": "NumberOneText3"
      },
      {
        "id": 17,
        "contentData": "bc670748-abbc-44ec-95be-5568ce110bd2_CrossFamily_HPbanner_V1_Desktop_2880x1000_4.webp",
        "pageName": "home",
        "section": "CarouselImage",
        "description": "image1"
      },
      {
        "id": 18,
        "contentData": "40f0910d-461e-4b2c-9bee-7884687947ab_showImageResized.webp",
        "pageName": "home",
        "section": "CarouselImage",
        "description": "image2"
      },
      {
        "id": 19,
        "contentData": "8679de9d-3877-42c0-a8a4-eaea0de2afd3_1.webp",
        "pageName": "home",
        "section": "CarouselImage",
        "description": "image3"
      },
      {
        "id": 20,
        "contentData": "9aaf47e2-f481-4f1b-9891-7c39a6e36903_201201_EUC_StageTeaser_Jackson5_Lotion_Desktop_clean.webp",
        "pageName": "home",
        "section": "CarouselImage",
        "description": "image4"
      },
      {
        "id": 21,
        "contentData": "4fe6020d-80fb-41c5-aa6c-aca7ac59d720_EUC-Website-HomePage-Dermopurifyer-StageTeaser-Desktop-4000x720-En.webp",
        "pageName": "home",
        "section": "CarouselImage",
        "description": "image5"
      },
      {
        "id": 22,
        "contentData": "becccec9-44b0-4142-8bca-b31857825222_gb_home_page_slider_hairloss_women_desktop_705x551_1.webp",
        "pageName": "home",
        "section": "CarouselImage",
        "description": "image6"
      },
      {
        "id": 23,
        "contentData": "#056099",
        "pageName": "AllPages",
        "section": "Color",
        "description": "MainColor"
      },
      {
        "id": 24,
        "contentData": "#ffffff",
        "pageName": "AllPages",
        "section": "Color",
        "description": "SecondaryColor"
      },
      {
        "id": 25,
        "contentData": "wereg",
        "pageName": "AboutUS",
        "section": "Paragraphs",
        "description": "Main"
      },
      {
        "id": 26,
        "contentData": "regregr",
        "pageName": "AboutUS",
        "section": "Paragraphs",
        "description": "Second"
      },
      {
        "id": 27,
        "contentData": "95801e9a-5ca8-4089-b80a-86a2fc7eddb3_LOGO 1 WITHOUT BACKGROUND.png",
        "pageName": "AboutUS",
        "section": "Logo",
        "description": "LogoAboutUS"
      },
      {
        "id": 28,
        "contentData": "WebsiteIcon.png",
        "pageName": "Home",
        "section": "Icon",
        "description": "WebsiteIcon"
      },
      {
        "id": 29,
        "contentData": "6c8b080d-b727-42d9-9771-981e8fb975ea_associations_patients.jpg",
        "pageName": "Home",
        "section": "CarouselImage",
        "description": "image7"
      },
      {
        "id": 30,
        "contentData": "97a5a0b4-1a87-46b0-9896-ba7b133af13a_DU_HOME-PAGE_VISUEL-DERMATOLOGIST_DESKTOP_HEADER.png",
        "pageName": "Home",
        "section": "CarouselImage",
        "description": "image8"
      },
      {
        "id": 31,
        "contentData": "hh",
        "pageName": "home",
        "section": "NumberOne",
        "description": "NumberOneHeader1"
      },
      {
        "id": 32,
        "contentData": "hh",
        "pageName": "home",
        "section": "NumberOne",
        "description": "NumberOneHeader2"
      },
      {
        "id": 33,
        "contentData": "hh",
        "pageName": "home",
        "section": "NumberOne",
        "description": "NumberOneHeader3"
      },
      {
        "id": 34,
        "contentData": "hadi70612300@gmail.com",
        "pageName": "footer",
        "section": "SocialMedia",
        "description": "Email"
      },
      {
        "id": 35,
        "contentData": "#222022",
        "pageName": "AllPages",
        "section": "Color",
        "description": "ThirdColor"
      },
      {
        "id": 36,
        "contentData": "e513003e-ad81-4267-8021-7316fbd1a6fd_logo 4.png",
        "pageName": "footer",
        "section": "lightLogo",
        "description": "lightLogo"
      }
    ];
  }
}
