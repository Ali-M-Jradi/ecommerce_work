import 'package:flutter/material.dart';
import '../models/content_item.dart';
import '../services/site_images_api_service.dart';

class ContentProvider extends ChangeNotifier {
  List<ContentItem> _items = [];
  bool _isLoading = false;
  String? _error;
  
  // API Carousel state
  List<String> _apiCarouselImages = [];
  bool _isLoadingCarousel = false;
  String? _carouselError;

  // Getters
  List<ContentItem> get items => List.unmodifiable(_items);
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasContent => _items.isNotEmpty;
  
  // API Carousel getters
  List<String> get apiCarouselImages => List.unmodifiable(_apiCarouselImages);
  bool get isLoadingCarousel => _isLoadingCarousel;
  String? get carouselError => _carouselError;
  bool get hasApiCarouselImages => _apiCarouselImages.isNotEmpty;

  ContentProvider() {
    loadContent();
    loadApiCarouselImages(); // Load API carousel images on init
  }

  /// Load content from mock data (no API)
  Future<void> loadContent() async {
    if (_isLoading) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Simulate loading delay
      await Future.delayed(const Duration(milliseconds: 500));
      
      final contentItems = await _getMockData();
      _items = contentItems.map<ContentItem>((json) => ContentItem.fromJson(json)).toList();
      
      // Update the ContentManager with new items
      ContentManager.setItems(_items);
      
      _error = null;
      print('Loaded ${_items.length} content items from mock data');
      
      // Notify theme provider about new colors if available
      _notifyThemeProviderOfColors();
      
    } catch (e) {
      print('Error loading content: $e');
      _error = 'Failed to load content: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Notify theme provider about API colors (call this after loading content)
  void _notifyThemeProviderOfColors() {
    // This will be called from main app to sync theme colors
    // We'll implement this connection in the main app
  }

  /// Load carousel images from API
  Future<void> loadApiCarouselImages() async {
    if (_isLoadingCarousel) return;
    
    _isLoadingCarousel = true;
    _carouselError = null;
    notifyListeners();

    try {
      print('🔄 Loading carousel images from API...');
      // Using real SiteImagesApiService - make sure your server is running on port 89
      print('🌐 Connecting to site-images API...');
      final apiImages = await SiteImagesApiService.getCarouselImages();
      _apiCarouselImages = apiImages;
      _carouselError = null;
      print('✅ Successfully loaded ${_apiCarouselImages.length} carousel images from API');
    } catch (e) {
      print('❌ Error loading carousel images from API: $e');
      _carouselError = 'Failed to load carousel images: $e';
      _apiCarouselImages = []; // Clear on error
    } finally {
      _isLoadingCarousel = false;
      notifyListeners();
    }
  }

  /// Refresh carousel images from API
  Future<void> refreshApiCarouselImages() async {
    _apiCarouselImages.clear();
    await loadApiCarouselImages();
  }

  /// Refresh content (force reload)
  Future<void> refreshContent() async {
    _items.clear();
    await loadContent();
  }

  /// Get content by criteria
  String getContent(String page, String section, String description, [String defaultValue = '']) {
    return ContentManager.getContent(page, section, description, defaultValue);
  }

  /// Get page content
  List<ContentItem> getPageContent(String page) {
    return ContentManager.getPageContent(page);
  }

  /// Get section content
  List<ContentItem> getSectionContent(String page, String section) {
    return ContentManager.getSectionContent(page, section);
  }

  /// Get color content
  String getColor(String colorType, [String defaultValue = '#056099']) {
    return ContentManager.getColor(colorType, defaultValue);
  }

  /// Get social media content
  String getSocialMedia(String platform, [String defaultValue = '']) {
    return ContentManager.getSocialMedia(platform, defaultValue);
  }

  /// Get home page content
  String getHomeContent(String section, String description, [String defaultValue = '']) {
    return ContentManager.getHomeContent(section, description, defaultValue);
  }

  /// Get carousel images (API only)
  List<String> getCarouselImages() {
    print('📸 Returning ${_apiCarouselImages.length} carousel images from API');
    return _apiCarouselImages;
  }

  /// Get moving banner texts
  List<String> getMovingBannerTexts() {
    return ContentManager.getMovingBannerTexts();
  }

  /// Update content item (mock implementation)
  Future<bool> updateContentItem(ContentItem item) async {
    try {
      // Mock update - just update locally
      final index = _items.indexWhere((i) => i.id == item.id);
      if (index != -1) {
        _items[index] = item;
        ContentManager.setItems(_items);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print('Error updating content item: $e');
      return false;
    }
  }

  /// Add content item (mock implementation)
  Future<bool> addContentItem(ContentItem item) async {
    try {
      // Mock add - just add locally with new ID
      final newItem = ContentItem(
        id: _items.isNotEmpty ? _items.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1 : 1,
        contentData: item.contentData,
        pageName: item.pageName,
        section: item.section,
        description: item.description,
      );
      _items.add(newItem);
      ContentManager.setItems(_items);
      notifyListeners();
      return true;
    } catch (e) {
      print('Error adding content item: $e');
      return false;
    }
  }

  /// Delete content item (mock implementation)
  Future<bool> deleteContentItem(int itemId) async {
    try {
      // Mock delete - just remove locally
      _items.removeWhere((item) => item.id == itemId);
      ContentManager.setItems(_items);
      notifyListeners();
      return true;
    } catch (e) {
      print('Error deleting content item: $e');
      return false;
    }
  }

  /// Helper methods for specific content types

  /// Get primary theme color
  Color getPrimaryColor() {
    final colorString = getColor('MainColor', '#056099');
    try {
      return Color(int.parse(colorString.replaceFirst('#', '0xff')));
    } catch (e) {
      return const Color(0xff056099); // Default blue
    }
  }

  /// Get secondary theme color
  Color getSecondaryColor() {
    final colorString = getColor('SecondaryColor', '#ffffff');
    try {
      return Color(int.parse(colorString.replaceFirst('#', '0xff')));
    } catch (e) {
      return const Color(0xffffffff); // Default white
    }
  }

  /// Get third theme color
  Color getThirdColor() {
    final colorString = getColor('ThirdColor', '#222022');
    try {
      return Color(int.parse(colorString.replaceFirst('#', '0xff')));
    } catch (e) {
      return const Color(0xff222022); // Default dark
    }
  }

  /// Get footer logo
  String getFooterLogo(bool isLight) {
    if (isLight) {
      return getContent('footer', 'lightLogo', 'lightLogo', 'assets/images/logo_light.png');
    } else {
      return getContent('footer', 'Logo', 'Logo image', 'assets/images/logo.png');
    }
  }

  /// Get contact info
  Map<String, String> getContactInfo() {
    return {
      'phone': getHomeContent('UpperBanner', 'PhoneNumber', ''),
      'location': getHomeContent('UpperBanner', 'Location', ''),
      'email': getSocialMedia('Email', ''),
    };
  }

  /// Get social media links
  Map<String, String> getSocialMediaLinks() {
    return {
      'facebook': getSocialMedia('FaceBook', ''),
      'instagram': getSocialMedia('Instagram', ''),
      'whatsapp': getSocialMedia('Whatsapp', ''),
      'email': getSocialMedia('Email', ''),
    };
  }
  
  /// Mock data for testing without API
  Future<List<Map<String, dynamic>>> _getMockData() async {
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
        "contentData": "three_leaves.png",
        "pageName": "footer",
        "section": "Logo",
        "description": "Logo image"
      },
      {
        "id": 8,
        "contentData": "banner2.jpg",
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
        "contentData": "pback2.jpg",
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
        "contentData": "Pellentesque in ipsum id orci porta dapibus. Vivamus magna justo, lacinia eget consectetur sed, convallis at tellus.",
        "pageName": "home",
        "section": "NumberOne",
        "description": "NumberOneText2"
      },
      {
        "id": 16,
        "contentData": "Pellentesque in ipsum id orci porta dapibus. Vivamus magna justo, lacinia eget consectetur sed, convallis at tellus.",
        "pageName": "home",
        "section": "NumberOne",
        "description": "NumberOneText3"
      },
      {
        "id": 17,
        "contentData": "cosmetics-beauty-products-skincare-social-media-instagram-post-square-banner-template_611904-184.avif",
        "pageName": "home",
        "section": "CarouselImage",
        "description": "image1"
      },
      {
        "id": 18,
        "contentData": "digital-art-style-mental-health-day-awareness-illustration.png",
        "pageName": "home",
        "section": "CarouselImage",
        "description": "image2"
      },
      {
        "id": 19,
        "contentData": "gift_icon.jpg",
        "pageName": "home",
        "section": "CarouselImage",
        "description": "image3"
      },
      {
        "id": 20,
        "contentData": "three_leaves.png",
        "pageName": "home",
        "section": "CarouselImage",
        "description": "image4"
      },
      {
        "id": 21,
        "contentData": "whatsapp_icon.jpg",
        "pageName": "home",
        "section": "CarouselImage",
        "description": "image5"
      },
      {
        "id": 22,
        "contentData": "cosmetics-beauty-products-skincare-social-media-instagram-post-square-banner-template_611904-184.avif",
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
        "contentData": "three_leaves.png",
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
        "contentData": "three_leaves.png",
        "pageName": "footer",
        "section": "lightLogo",
        "description": "lightLogo"
      }
    ];
  }
}
