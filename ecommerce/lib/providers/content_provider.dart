import 'package:flutter/material.dart';
import '../models/content_item.dart';
import '../services/content_service.dart';

class ContentProvider extends ChangeNotifier {
  List<ContentItem> _items = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<ContentItem> get items => List.unmodifiable(_items);
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasContent => _items.isNotEmpty;

  ContentProvider() {
    loadContent();
  }

  /// Load content from API
  Future<void> loadContent() async {
    if (_isLoading) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final contentItems = await ContentService.fetchContentItems();
      _items = contentItems;
      
      // Update the ContentManager with new items
      ContentManager.setItems(_items);
      
      _error = null;
      print('Loaded ${_items.length} content items');
      
      // Notify theme provider about new colors if available
      _notifyThemeProviderOfColors();
      
    } catch (e) {
      print('Error loading content: $e');
      
      // Check if it's a specific network error
      if (e.toString().contains('HandshakeException')) {
        _error = 'API connection error: SSL handshake failed. This is normal for localhost development. Using mock data instead.';
        print('SSL handshake error detected - likely due to localhost development. Continuing with mock data.');
      } else if (e.toString().contains('SocketException')) {
        _error = 'Network error: Cannot reach API server at http://localhost:89. Make sure your server is running.';
      } else {
        _error = 'Failed to load content: $e';
      }
      
      // Don't stop the app, it should continue with mock data
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

  /// Get carousel images
  List<String> getCarouselImages() {
    return ContentManager.getCarouselImages();
  }

  /// Get moving banner texts
  List<String> getMovingBannerTexts() {
    return ContentManager.getMovingBannerTexts();
  }

  /// Update content item
  Future<bool> updateContentItem(ContentItem item) async {
    try {
      final success = await ContentService.updateContentItem(item);
      if (success) {
        // Update local item
        final index = _items.indexWhere((i) => i.id == item.id);
        if (index != -1) {
          _items[index] = item;
          ContentManager.setItems(_items);
          notifyListeners();
        }
      }
      return success;
    } catch (e) {
      print('Error updating content item: $e');
      return false;
    }
  }

  /// Add content item
  Future<bool> addContentItem(ContentItem item) async {
    try {
      final newItem = await ContentService.createContentItem(item);
      if (newItem != null) {
        _items.add(newItem);
        ContentManager.setItems(_items);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print('Error adding content item: $e');
      return false;
    }
  }

  /// Delete content item
  Future<bool> deleteContentItem(int itemId) async {
    try {
      final success = await ContentService.deleteContentItem(itemId);
      if (success) {
        _items.removeWhere((item) => item.id == itemId);
        ContentManager.setItems(_items);
        notifyListeners();
      }
      return success;
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
}
