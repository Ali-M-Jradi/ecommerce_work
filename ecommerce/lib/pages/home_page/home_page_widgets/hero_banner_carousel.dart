import 'package:flutter/material.dart';
import 'dart:async';
import 'package:extended_image/extended_image.dart';
import '../../../services/site_images_api_service.dart';

class HeroBannerCarousel extends StatefulWidget {
  const HeroBannerCarousel({super.key});

  @override
  State<HeroBannerCarousel> createState() => _HeroBannerCarouselState();
}

class _HeroBannerCarouselState extends State<HeroBannerCarousel> {
  final PageController _pageController = PageController();
  Timer? _timer;
  int _currentPage = 0;
  bool _isLoading = true;
  String? _error;
  List<String> _carouselImages = [];

  // Helper function to check if filename indicates WebP format
  bool _isWebPImage(String filename) {
    return filename.toLowerCase().endsWith('.webp');
  }

  @override
  void initState() {
    super.initState();
  _loadCachedThenRefresh();
    _startAutoPlay();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoPlay() {
    _timer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      if (_pageController.hasClients) {
        if (_carouselImages.isNotEmpty) {
          _currentPage = (_currentPage + 1) % _carouselImages.length;
          _pageController.animateToPage(
            _currentPage,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      }
    });
  }

  Future<void> _fetchImages() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final images = await SiteImagesApiService.getCarouselImages();
      setState(() {
        _carouselImages = images;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load carousel images: $e';
        _carouselImages = [];
        _isLoading = false;
      });
    }
  }

  // Show cached URLs instantly (if any), then refresh from network in background.
  Future<void> _loadCachedThenRefresh() async {
    try {
      final cached = await SiteImagesApiService.getCachedCarouselImages();
      if (mounted && cached.isNotEmpty) {
        setState(() {
          _carouselImages = cached;
          _isLoading = false; // show immediately
          _error = null;
        });
      }
    } catch (_) {}

    // Network refresh in background
    try {
      final fresh = await SiteImagesApiService.getCarouselImages();
      if (!mounted) return;
      // Update only if changed (length or any element differs)
      final changed = fresh.length != _carouselImages.length ||
          fresh.asMap().entries.any((e) => e.value != _carouselImages[e.key]);
      if (changed) {
        setState(() {
          _carouselImages = fresh;
          _isLoading = false;
          _error = null;
        });
      } else if (_carouselImages.isEmpty) {
        // If no cached images were available, ensure we show network ones
        setState(() {
          _carouselImages = fresh;
          _isLoading = false;
          _error = null;
        });
      }
    } catch (e) {
      if (!mounted) return;
      if (_carouselImages.isEmpty) {
        setState(() {
          _error = 'Failed to load carousel images: $e';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print('🔄 HeroBannerCarousel rebuild');
    print('📸 Found ${_carouselImages.length} carousel images');

    // Loading state
    if (_isLoading) {
      return _buildLoadingState();
    }

    // Error state
    if (_error != null) {
      return _buildErrorState(_error!);
    }

    // Empty state
    if (_carouselImages.isEmpty) {
      return _buildEmptyState();
    }

    return _buildCarousel(_carouselImages);
  }

  Widget _buildLoadingState() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Loading images...',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).colorScheme.errorContainer,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Theme.of(context).colorScheme.onErrorContainer,
            ),
            const SizedBox(height: 16),
            Text(
              'Error loading carousel',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onErrorContainer,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onErrorContainer.withOpacity(0.7),
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.photo_library_outlined,
              size: 48,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'No images received from API',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Check if http://127.0.0.1:89/api/site-images is running',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.7),
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                _fetchImages();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Retry API Call'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCarousel(List<String> carouselImages) {
    return SizedBox(
      height: 200,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              itemCount: carouselImages.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: _buildCarouselImage(carouselImages[index]),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          _buildPageIndicator(carouselImages.length),
        ],
      ),
    );
  }

  Widget _buildCarouselImage(String imagePath) {
    print('🖼️ Building carousel image for: $imagePath');
    
    if (imagePath.isEmpty) {
      return _buildImagePlaceholder('Empty image path');
    }

    // Check if it's an API URL (starts with http) or local asset
    if (imagePath.startsWith('http')) {
      print('🌐 Loading from API: $imagePath');
      return _buildNetworkImage(imagePath, imagePath);
    } else {
      // Local asset path
      final imageSource = 'assets/images/$imagePath';
      print('📱 Loading from assets: $imageSource');
      return _buildAssetImage(imageSource);
    }
  }

  Widget _buildNetworkImage(String imageUrl, String filename) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: ExtendedImage.network(
          imageUrl,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          cache: true,
          enableLoadState: true,
          loadStateChanged: (ExtendedImageState state) {
            switch (state.extendedImageLoadState) {
              case LoadState.loading:
                return Container(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Loading from API...',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.7),
                            fontSize: 10,
                          ),
                        ),
                        Text(
                          _isWebPImage(filename) ? 'WebP format' : 'Standard format',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.5),
                            fontSize: 8,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              case LoadState.completed:
                print('✅ Successfully loaded from API: $filename');
                return ExtendedRawImage(
                  image: state.extendedImageInfo?.image,
                  fit: BoxFit.cover,
                );
              case LoadState.failed:
                print('❌ Failed to load from API: $imageUrl');
                return _buildImagePlaceholder('API server not available\n${_isWebPImage(filename) ? 'WebP format' : 'Standard format'}');
            }
          },
        ),
      ),
    );
  }

  Widget _buildAssetImage(String assetPath) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          assetPath,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          errorBuilder: (context, error, stackTrace) {
            print('❌ Error loading asset: $assetPath - $error');
            return _buildImagePlaceholder('Asset load error');
          },
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder([String? message]) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_off,
              size: 48,
              color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.5),
            ),
            const SizedBox(height: 8),
            Text(
              message ?? 'Image not available from API',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.7),
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              'Requires image server endpoint',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.5),
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageIndicator(int itemCount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        itemCount,
        (index) => Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPage == index
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.3),
          ),
        ),
      ),
    );
  }
}
