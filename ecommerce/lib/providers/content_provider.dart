import 'package:flutter/material.dart';
import 'package:ecommerce/models/content_item.dart';
import 'package:ecommerce/services/site_images_api_service.dart';

/// Provides app content and carousel images (mock content; real images via API)
class ContentProvider extends ChangeNotifier {
	// Content state (mocked)
	List<ContentItem> _items = [];
	bool _isLoading = false;
	String? _error;

	// API carousel state
	List<String> _apiCarouselImages = [];
	bool _isLoadingCarousel = false;
	String? _carouselError;

	// Getters
	List<ContentItem> get items => List.unmodifiable(_items);
	bool get isLoading => _isLoading;
	String? get error => _error;
	bool get hasContent => _items.isNotEmpty;

	List<String> get apiCarouselImages => List.unmodifiable(_apiCarouselImages);
	bool get isLoadingCarousel => _isLoadingCarousel;
	String? get carouselError => _carouselError;
	bool get hasApiCarouselImages => _apiCarouselImages.isNotEmpty;

	ContentProvider() {
		// Load basic content (mock) and API carousel images on startup
		loadContent();
		loadApiCarouselImages();
	}

	// ----- Content (mock) -----
	Future<void> loadContent() async {
		if (_isLoading) return;
		_isLoading = true;
		_error = null;
		notifyListeners();
		try {
			await Future.delayed(const Duration(milliseconds: 200));
			final data = await _mockData();
			_items = data.map((j) => ContentItem.fromJson(j)).toList();
			ContentManager.setItems(_items);
		} catch (e) {
			_error = 'Failed to load content: $e';
		} finally {
			_isLoading = false;
			notifyListeners();
		}
	}

	Future<void> refreshContent() async {
		_items.clear();
		await loadContent();
	}

	// Accessors used around the app/admin pages
	String getContent(String page, String section, String description, [String defaultValue = '']) {
		return ContentManager.getContent(page, section, description, defaultValue);
	}

	List<ContentItem> getPageContent(String page) => ContentManager.getPageContent(page);
	List<ContentItem> getSectionContent(String page, String section) => ContentManager.getSectionContent(page, section);
	String getColor(String colorType, [String defaultValue = '#056099']) => ContentManager.getColor(colorType, defaultValue);
	String getSocialMedia(String platform, [String defaultValue = '']) => ContentManager.getSocialMedia(platform, defaultValue);
	String getHomeContent(String section, String description, [String defaultValue = '']) => ContentManager.getHomeContent(section, description, defaultValue);
	List<String> getMovingBannerTexts() => ContentManager.getMovingBannerTexts();

	// UI helpers
	Color getPrimaryColor() {
		final hex = getColor('MainColor', '#056099');
		return _parseHexColor(hex, const Color(0xff056099));
	}
	Color getSecondaryColor() {
		final hex = getColor('SecondaryColor', '#ffffff');
		return _parseHexColor(hex, const Color(0xffffffff));
	}
	Color getThirdColor() {
		final hex = getColor('ThirdColor', '#222022');
		return _parseHexColor(hex, const Color(0xff222022));
	}
	String getFooterLogo(bool isLight) {
		return isLight
				? getContent('footer', 'lightLogo', 'lightLogo', 'assets/images/logo_light.png')
				: getContent('footer', 'Logo', 'Logo image', 'assets/images/logo.png');
	}
	Map<String, String> getSocialMediaLinks() => {
				'facebook': getSocialMedia('FaceBook', ''),
				'instagram': getSocialMedia('Instagram', ''),
				'whatsapp': getSocialMedia('Whatsapp', ''),
				'email': getSocialMedia('Email', ''),
			};

		Map<String, String> getContactInfo() => {
					'phone': getHomeContent('UpperBanner', 'PhoneNumber', ''),
					'location': getHomeContent('UpperBanner', 'Location', ''),
					'email': getSocialMedia('Email', ''),
				};

	// CRUD (mock only)
	Future<bool> updateContentItem(ContentItem item) async {
		try {
			final i = _items.indexWhere((x) => x.id == item.id);
			if (i != -1) {
				_items[i] = item;
				ContentManager.setItems(_items);
				notifyListeners();
				return true;
			}
			return false;
		} catch (_) {
			return false;
		}
	}

	Future<bool> addContentItem(ContentItem item) async {
		try {
			final newId = _items.isNotEmpty ? _items.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1 : 1;
			final newItem = ContentItem(
				id: newId,
				contentData: item.contentData,
				pageName: item.pageName,
				section: item.section,
				description: item.description,
			);
			_items.add(newItem);
			ContentManager.setItems(_items);
			notifyListeners();
			return true;
		} catch (_) {
			return false;
		}
	}

	Future<bool> deleteContentItem(int itemId) async {
		try {
			_items.removeWhere((x) => x.id == itemId);
			ContentManager.setItems(_items);
			notifyListeners();
			return true;
		} catch (_) {
			return false;
		}
	}

	// ----- Carousel images (API) -----
	Future<void> loadApiCarouselImages() async {
		if (_isLoadingCarousel) return;
		_isLoadingCarousel = true;
		_carouselError = null;
		notifyListeners();
		try {
			final urls = await SiteImagesApiService.getCarouselImages();
			_apiCarouselImages = urls;
		} catch (e) {
			_carouselError = 'Failed to load carousel images: $e';
			_apiCarouselImages = [];
		} finally {
			_isLoadingCarousel = false;
			notifyListeners();
		}
	}

	Future<void> refreshApiCarouselImages() async {
		_apiCarouselImages.clear();
		await loadApiCarouselImages();
	}

	List<String> getCarouselImages() => _apiCarouselImages;

	// ----- Helpers -----
	Color _parseHexColor(String hex, Color fallback) {
		try {
			return Color(int.parse(hex.replaceFirst('#', '0xff')));
		} catch (_) {
			return fallback;
		}
	}

	// Minimal mock dataset used throughout the app
	Future<List<Map<String, dynamic>>> _mockData() async {
		return [
			{
				'id': 1,
				'contentData': '03815860 - 01275019',
				'pageName': 'home',
				'section': 'UpperBanner',
				'description': 'PhoneNumber'
			},
			{
				'id': 2,
				'contentData': 'Beirut, Lebanon',
				'pageName': 'home',
				'section': 'UpperBanner',
				'description': 'Location'
			},
			{
				'id': 23,
				'contentData': '#056099',
				'pageName': 'AllPages',
				'section': 'Color',
				'description': 'MainColor'
			},
			{
				'id': 24,
				'contentData': '#ffffff',
				'pageName': 'AllPages',
				'section': 'Color',
				'description': 'SecondaryColor'
			},
			{
				'id': 35,
				'contentData': '#222022',
				'pageName': 'AllPages',
				'section': 'Color',
				'description': 'ThirdColor'
			},
			{
				'id': 34,
				'contentData': 'hadi70612300@gmail.com',
				'pageName': 'footer',
				'section': 'SocialMedia',
				'description': 'Email'
			},
			{
				'id': 3,
				'contentData': 'Test1',
				'pageName': 'footer',
				'section': 'SocialMedia',
				'description': 'FaceBook'
			},
			{
				'id': 4,
				'contentData': 'ifj',
				'pageName': 'footer',
				'section': 'SocialMedia',
				'description': 'Instagram'
			},
			{
				'id': 5,
				'contentData': 'geeg',
				'pageName': 'footer',
				'section': 'SocialMedia',
				'description': 'Whatsapp'
			},
		];
	}
}

