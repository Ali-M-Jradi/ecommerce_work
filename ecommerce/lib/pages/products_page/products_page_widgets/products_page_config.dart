/// Configuration class for Products Page settings and constants
class ProductsPageConfig {
  // App Information
  static const String appName = 'DERMOCOSMETIQUE by PH.MARIAM';
  static const String pageTitle = 'Products';

  // Grid Configuration
  static const int gridCrossAxisCount = 2;
  static const double gridChildAspectRatio = 0.75;
  static const double gridCrossAxisSpacing = 12.0;
  static const double gridMainAxisSpacing = 12.0;

  // Spacing and Padding
  static const double defaultPadding = 16.0;
  static const double cardSpacing = 12.0;
  static const double smallSpacing = 8.0;
  static const double tinySpacing = 4.0;

  // FAB (Floating Action Button) Configuration
  static const double fabHideThreshold = 200.0; // Distance from bottom to hide FABs
  static const String loyaltyButtonText = 'Loyalty Program';
  static const String contactButtonText = 'Contact Us';

  // Text Limits
  static const int productNameMaxLength = 50;
  static const int productDescriptionMaxLength = 100;

  // Animation Durations
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  static const Duration shortAnimationDuration = Duration(milliseconds: 150);

  // Scroll Behavior
  static const double scrollThreshold = 100.0;
  static const bool enableOverscrollGlow = false;

  // Product Configuration
  static const double minProductPrice = 0.0;
  static const double maxProductPrice = 1000.0;
  static const double defaultRating = 0.0;
  static const double maxRating = 5.0;
  static const double ratingIncrement = 0.5;

  // Image Configuration
  static const String defaultProductImage = 'assets/images/cosmetics-beauty-products-skincare-social-media-instagram-post-square-banner-template_611904-184.avif';
  static const double cardImageHeight = 120.0;
  static const double dialogImageHeight = 200.0;

  // Search Configuration
  static const int minSearchLength = 2;
  static const int maxSearchResults = 50;

  // Error Messages
  static const String networkErrorMessage = 'Network error. Please check your connection.';
  static const String noProductsFoundMessage = 'No products found.';
  static const String loadingErrorMessage = 'Error loading products.';

  // Success Messages
  static const String addToCartSuccessMessage = 'Product added to cart!';
  static const String addToFavoritesSuccessMessage = 'Product added to favorites!';
  static const String ratingUpdatedMessage = 'Rating updated successfully!';

  // Features Flags (for future development)
  static const bool enableSearch = false; // Not implemented yet
  static const bool enableFilters = false; // Not implemented yet
  static const bool enableWishlist = false; // Not implemented yet
  static const bool enableReviews = false; // Not implemented yet
  static const bool enableRecommendations = false; // Not implemented yet

  // API Configuration (for future use)
  static const String baseApiUrl = 'https://api.dermocosmetique.com';
  static const String productsEndpoint = '/products';
  static const int apiTimeout = 30; // seconds

  // Cache Configuration
  static const Duration cacheExpiration = Duration(minutes: 15);
  static const int maxCacheSize = 100; // number of items

  // Debug Configuration
  static const bool debugMode = false;
  static const bool showPerformanceLogs = false;
}
