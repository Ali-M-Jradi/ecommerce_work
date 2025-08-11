class ContentItem {
  final int id;
  final String contentData;
  final String pageName;
  final String section;
  final String description;

  ContentItem({
    required this.id,
    required this.contentData,
    required this.pageName,
    required this.section,
    required this.description,
  });

  factory ContentItem.fromJson(Map<String, dynamic> json) {
    return ContentItem(
      id: json['id'] ?? 0,
      contentData: json['contentData'] ?? '',
      pageName: json['pageName'] ?? '',
      section: json['section'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'contentData': contentData,
      'pageName': pageName,
      'section': section,
      'description': description,
    };
  }

  @override
  String toString() {
    return 'ContentItem(id: $id, pageName: $pageName, section: $section, description: $description)';
  }
}

/// Helper class to manage content items
class ContentManager {
  static List<ContentItem> _items = [];
  
  static void setItems(List<ContentItem> items) {
    _items = items;
  }

  /// Get content by page, section, and description
  static String getContent(String page, String section, String description, [String defaultValue = '']) {
    try {
      final item = _items.firstWhere(
        (item) => item.pageName.toLowerCase() == page.toLowerCase() && 
                  item.section.toLowerCase() == section.toLowerCase() && 
                  item.description.toLowerCase() == description.toLowerCase(),
      );
      return item.contentData.isNotEmpty ? item.contentData : defaultValue;
    } catch (e) {
      return defaultValue;
    }
  }

  /// Get all content for a specific page
  static List<ContentItem> getPageContent(String page) {
    return _items.where((item) => item.pageName.toLowerCase() == page.toLowerCase()).toList();
  }

  /// Get all content for a specific section
  static List<ContentItem> getSectionContent(String page, String section) {
    return _items.where((item) => 
      item.pageName.toLowerCase() == page.toLowerCase() && 
      item.section.toLowerCase() == section.toLowerCase()
    ).toList();
  }

  /// Get color content
  static String getColor(String colorType, [String defaultValue = '#056099']) {
    return getContent('AllPages', 'Color', colorType, defaultValue);
  }

  /// Get social media content
  static String getSocialMedia(String platform, [String defaultValue = '']) {
    return getContent('footer', 'SocialMedia', platform, defaultValue);
  }

  /// Get home page content
  static String getHomeContent(String section, String description, [String defaultValue = '']) {
    return getContent('home', section, description, defaultValue);
  }

  /// Get carousel images
  static List<String> getCarouselImages() {
    final carouselItems = getSectionContent('home', 'CarouselImage');
    return carouselItems.map((item) => item.contentData).where((data) => data.isNotEmpty).toList();
  }

  /// Get moving banner texts
  static List<String> getMovingBannerTexts() {
    final movingItems = getSectionContent('home', 'MovingBanner');
    final texts = movingItems.where((item) => item.description.startsWith('MovingText')).toList();
    texts.sort((a, b) => a.description.compareTo(b.description));
    return texts.map((item) => item.contentData).toList();
  }

  /// Check if items are loaded
  static bool get hasContent => _items.isNotEmpty;

  /// Get all items (for debugging)
  static List<ContentItem> get allItems => List.unmodifiable(_items);
}
