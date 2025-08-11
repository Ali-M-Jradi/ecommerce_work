import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../../../providers/content_provider.dart';
import '../../../services/content_service.dart';

class HeroBannerCarousel extends StatefulWidget {
  const HeroBannerCarousel({super.key});

  @override
  State<HeroBannerCarousel> createState() => _HeroBannerCarouselState();

}
class _HeroBannerCarouselState extends State<HeroBannerCarousel> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  Timer? _autoPlayTimer;
  bool _bannersInitialized = false;

  // Banner data with featured product campaigns based on your website
  late List<Map<String, dynamic>> banners;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Get dynamic carousel images from ContentProvider - ONLY use API images
    final contentProvider = Provider.of<ContentProvider>(context, listen: false);
    final dynamicImages = contentProvider.getCarouselImages();
    
    print('didChangeDependencies: Found ${dynamicImages.length} carousel images');
    for (var img in dynamicImages) {
      print('  - $img');
    }
    
    // Initialize banners if not yet set
    if (!_bannersInitialized) {
      if (dynamicImages.isEmpty) {
        banners = [];
        print('No carousel images found, using empty banners');
      } else {
        banners = dynamicImages.map((imageUrl) => {
          'imageUrl': imageUrl,
        }).toList();
        print('Initialized ${banners.length} banners from API images');
      }
      _bannersInitialized = true;
    }
  }

  @override
  void initState() {
    super.initState();
    _startAutoPlay();
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoPlay() {
    _autoPlayTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_currentIndex < banners.length - 1) {
        _currentIndex++;
      } else {
        _currentIndex = 0;
      }
      
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentIndex,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _stopAutoPlay() {
    _autoPlayTimer?.cancel();
  }

  void _resumeAutoPlay() {
    _startAutoPlay();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ContentProvider>(
      builder: (context, contentProvider, child) {
        // Rebuild when content changes and update banners dynamically
        final dynamicImages = contentProvider.getCarouselImages();
        
        print('🔄 Consumer rebuild triggered');
        print('📸 Found ${dynamicImages.length} carousel images:');
        for (int i = 0; i < dynamicImages.length; i++) {
          print('  ${i + 1}. ${dynamicImages[i]}');
        }
        
        // Update banners when images change
        if (dynamicImages.length != banners.length || 
            (dynamicImages.isNotEmpty && banners.isEmpty)) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              // Recreate banners from new images
              if (dynamicImages.isEmpty) {
                banners = [];
              } else {
                banners = dynamicImages.map((imageUrl) => {
                  'imageUrl': imageUrl,
                }).toList();
              }
              
              // Reset current index if needed
              if (_currentIndex >= banners.length) {
                _currentIndex = 0;
              }
            });
          });
        }
        
        // If no banners (no API images), show a placeholder or empty container
        if (banners.isEmpty) {
          return Container(
            height: 400,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.image_not_supported,
                    size: 64,
                    color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No carousel images available',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.7),
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add images via Content Management',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.5),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        
        return SizedBox(
          height: 400,
          width: double.infinity,
          child: Stack(
            children: [
              // Page View for banners
              PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemCount: banners.length,
                itemBuilder: (context, index) {
                  return _buildBannerSlide(context, banners[index]);
                },
              ),

              // Simple navigation dots
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    banners.length,
                    (index) => GestureDetector(
                      onTap: () {
                        _stopAutoPlay();
                        _pageController.animateToPage(
                          index,
                          duration: const Duration(milliseconds: 350),
                          curve: Curves.easeInOut,
                        );
                        _resumeAutoPlay();
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentIndex == index ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentIndex == index
                              ? Colors.white
                              : Colors.white.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Simple navigation arrows (only show if we have multiple banners)
              if (banners.length > 1) ...[
                Positioned(
                  left: 16,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        _stopAutoPlay();
                        if (_currentIndex > 0) {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 350),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          _pageController.animateToPage(
                            banners.length - 1,
                            duration: const Duration(milliseconds: 350),
                            curve: Curves.easeInOut,
                          );
                        }
                        _resumeAutoPlay();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.chevron_left,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ),

                Positioned(
                  right: 16,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        _stopAutoPlay();
                        if (_currentIndex < banners.length - 1) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 350),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          _pageController.animateToPage(
                            0,
                            duration: const Duration(milliseconds: 350),
                            curve: Curves.easeInOut,
                          );
                        }
                        _resumeAutoPlay();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.chevron_right,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildBannerSlide(BuildContext context, Map<String, dynamic> banner) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: _buildCarouselImage(banner['imageUrl']),
      ),
    );
  }

  /// Build carousel image - loads from API endpoint with HTTP client to avoid HandshakeException
  Widget _buildCarouselImage(String imagePath) {
    // Debug output
    print('🖼️ Building carousel image for: $imagePath');
    
    // Check if it's a network image (API filename) or empty
    if (imagePath.isNotEmpty) {
      // Use your API's image URL structure
      final imageUrl = imagePath.contains('http') 
          ? imagePath  // Full URL
          : '${ContentService.imageBaseUrl}$imagePath'; // Construct URL from filename
      
      print('🌐 Final image URL: $imageUrl'); // Debug log
      
      // Use FutureBuilder with custom HTTP client to avoid HandshakeException
      return FutureBuilder<Uint8List?>(
        future: _loadImageBytes(imageUrl),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              color: Theme.of(context).colorScheme.surface,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Loading image...',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      imagePath.split('_').last, // Show filename
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError || !snapshot.hasData) {
            print('❌ Error loading image: $imageUrl - Error: ${snapshot.error}'); // Debug log
            
            // Fallback to placeholder on error
            return Container(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.broken_image,
                      size: 64,
                      color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Image not available',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Check server connection',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.5),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'URL: $imageUrl',
                      style: TextStyle(
                        fontSize: 10,
                        color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.4),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Error: ${snapshot.error ?? 'Unknown'}',
                      style: TextStyle(
                        fontSize: 10,
                        color: Theme.of(context).colorScheme.error.withOpacity(0.6),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          } else {
            print('✅ Successfully loaded image: $imageUrl (${snapshot.data!.length} bytes)');
            
            // Successfully loaded image bytes
            return Image.memory(
              snapshot.data!,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              errorBuilder: (context, error, stackTrace) {
                print('❌ Image.memory error: $error');
                return Container(
                  color: Theme.of(context).colorScheme.error.withOpacity(0.1),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error,
                          size: 64,
                          color: Theme.of(context).colorScheme.error,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Memory loading error',
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      );
    } else {
      // Empty image placeholder
      return Container(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.image_not_supported,
                size: 64,
                color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.5),
              ),
              const SizedBox(height: 16),
              Text(
                'No image specified',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  /// Load image bytes using HTTP client (avoids HandshakeException for localhost)
  Future<Uint8List?> _loadImageBytes(String imageUrl) async {
    print('🚀 Starting image load: $imageUrl');
    
    try {
      // Create a new client for each request
      final client = http.Client();
      
      print('📡 Sending HTTP GET request...');
      
      final response = await client.get(
        Uri.parse(imageUrl),
        headers: {
          'Accept': 'image/*',
          'User-Agent': 'Flutter App/1.0',
        },
      ).timeout(const Duration(seconds: 15));
      
      client.close();
      
      print('📊 Response status: ${response.statusCode}');
      print('📝 Response headers: ${response.headers}');
      print('📏 Response body length: ${response.bodyBytes.length} bytes');
      
      if (response.statusCode == 200) {
        print('✅ Successfully loaded image: $imageUrl (${response.bodyBytes.length} bytes)');
        return response.bodyBytes;
      } else {
        print('❌ HTTP Error: Status ${response.statusCode}');
        print('❌ Response body: ${response.body}');
        return null;
      }
      
    } on http.ClientException catch (e) {
      print('❌ HTTP Client Exception: $e');
      return null;
    } on FormatException catch (e) {
      print('❌ URL Format Exception: $e');
      return null;
    } on TimeoutException catch (e) {
      print('❌ Timeout Exception: $e (URL: $imageUrl)');
      return null;
    } catch (e, stackTrace) {
      print('❌ Unexpected Exception loading image: $imageUrl');
      print('❌ Error: $e');
      print('❌ Stack trace: $stackTrace');
      return null;
    }
  }
}
