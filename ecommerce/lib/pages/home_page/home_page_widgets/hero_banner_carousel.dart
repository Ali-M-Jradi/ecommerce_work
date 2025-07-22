import 'package:flutter/material.dart';
import 'dart:async';
import 'package:ecommerce/localization/app_localizations_helper.dart';

class HeroBannerCarousel extends StatefulWidget {
  const HeroBannerCarousel({super.key});

  @override
  State<HeroBannerCarousel> createState() => _HeroBannerCarouselState();

}
class _HeroBannerCarouselState extends State<HeroBannerCarousel> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  Timer? _autoPlayTimer;

  // Banner data with featured product campaigns based on your website
  late List<Map<String, dynamic>> banners;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Initialize banners with localized strings
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    banners = [
      {
        'title': AppLocalizationsHelper.of(context).laRochePosay,
        'subtitle': AppLocalizationsHelper.of(context).laboratoireDermatologique,
        'description': AppLocalizationsHelper.of(context).tolerianeEffaclar,
        'buttonText': AppLocalizationsHelper.of(context).shopCollection,
        'products': [
          'assets/images/WhatsApp Image 2025-07-01 at 12.15.01_267ad068.jpg',
          'assets/images/WhatsApp Image 2025-07-01 at 12.15.01_33c0f20c.jpg',
        ],
        'backgroundColor': isDark ? colorScheme.primaryContainer : colorScheme.background,
        'textColor': isDark ? colorScheme.onPrimaryContainer : colorScheme.onBackground,
        'subtitleColor': isDark ? colorScheme.onPrimary : colorScheme.onBackground.withOpacity(0.85),
        'descColor': isDark ? colorScheme.onPrimary.withOpacity(0.8) : colorScheme.onBackground.withOpacity(0.7),
        'buttonColor': isDark ? colorScheme.secondary : colorScheme.primary,
        'action': () {
          // Navigate to La Roche-Posay products
        },
      },
      {
        'title': AppLocalizationsHelper.of(context).dermocosmetique,
        'subtitle': AppLocalizationsHelper.of(context).byPhMariam,
        'description': AppLocalizationsHelper.of(context).premiumFrenchPharmacy,
        'buttonText': AppLocalizationsHelper.of(context).exploreBrands,
        'products': [
          'assets/images/WhatsApp Image 2025-07-01 at 12.15.02_1f1fc92c.jpg',
          'assets/images/WhatsApp Image 2025-07-01 at 12.15.02_21a37162.jpg',
        ],
        'backgroundColor': isDark ? colorScheme.tertiaryContainer : colorScheme.secondaryContainer,
        'textColor': isDark ? colorScheme.onTertiaryContainer : colorScheme.onSecondaryContainer,
        'subtitleColor': isDark ? colorScheme.onTertiary : colorScheme.onSecondaryContainer.withOpacity(0.85),
        'descColor': isDark ? colorScheme.onTertiary.withOpacity(0.8) : colorScheme.onSecondaryContainer.withOpacity(0.7),
        'buttonColor': isDark ? colorScheme.primary : colorScheme.tertiary,
        'action': () {
          // Navigate to all products
        },
      },
      {
        'title': AppLocalizationsHelper.of(context).specialOffers,
        'subtitle': AppLocalizationsHelper.of(context).limitedTimeOnly,
        'description': AppLocalizationsHelper.of(context).specialOffersDesc,
        'buttonText': AppLocalizationsHelper.of(context).viewOffers,
        'products': [
          'assets/images/cosmetics-beauty-products-skincare-social-media-instagram-post-square-banner-template_611904-184.avif',
          'assets/images/three_leaves.png',
        ],
        'backgroundColor': isDark ? colorScheme.surface : colorScheme.tertiaryContainer,
        'textColor': isDark ? colorScheme.onSurface : colorScheme.onTertiaryContainer,
        'subtitleColor': isDark ? colorScheme.onSurface : colorScheme.onTertiaryContainer.withOpacity(0.85),
        'descColor': isDark ? colorScheme.onSurface.withOpacity(0.8) : colorScheme.onTertiaryContainer.withOpacity(0.7),
        'buttonColor': isDark ? colorScheme.error : colorScheme.secondary,
        'action': () {
          // Navigate to offers page
        },
      },
    ];
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
    return Container(
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

          // Navigation dots
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
                    width: _currentIndex == index ? 32 : 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: _currentIndex == index
                          ? banners[_currentIndex]['buttonColor']
                          : Color.alphaBlend(
                              banners[_currentIndex]['buttonColor'].withAlpha((0.3 * 255).round()),
                              Theme.of(context).colorScheme.surface,
                            ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Manual navigation arrows
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
                    color: Color.alphaBlend(Colors.black.withAlpha((0.3 * 255).round()), Theme.of(context).colorScheme.surface),
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
                    color: Color.alphaBlend(Colors.black.withAlpha((0.3 * 255).round()), Theme.of(context).colorScheme.surface),
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
      ),
    );
  }

  Widget _buildBannerSlide(BuildContext context, Map<String, dynamic> banner) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: banner['backgroundColor'],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          bool isSmallScreen = constraints.maxWidth < 600;
          if (isSmallScreen) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          banner['title'],
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: banner['textColor'],
                            letterSpacing: 1,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          banner['subtitle'],
                          style: TextStyle(
                            fontSize: 14,
                            color: banner['subtitleColor'],
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          banner['description'],
                          style: TextStyle(
                            fontSize: 12,
                            color: banner['descColor'],
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: banner['action'],
                          style: ElevatedButton.styleFrom(
                            backgroundColor: banner['buttonColor'],
                            foregroundColor: banner['backgroundColor'],
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                banner['buttonText'],
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: banner['backgroundColor'],
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Icon(
                                Icons.chevron_right,
                                size: 14,
                                color: banner['backgroundColor'],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (banner['products'] != null && banner['products'].isNotEmpty)
                    Container(
                      height: 120,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: banner['products'].take(2).map<Widget>((product) => 
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: isDark ? colorScheme.surfaceVariant : colorScheme.surface,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: isDark
                                      ? Color.alphaBlend(Colors.black.withAlpha((0.18 * 255).round()), colorScheme.surface)
                                      : Color.alphaBlend(Colors.black.withAlpha((0.08 * 255).round()), colorScheme.surface),
                                  blurRadius: 10,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                product,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ).toList(),
                      ),
                    ),
                ],
              ),
            );
          } else {
            return Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (banner['products'] != null && banner['products'].isNotEmpty)
                          ...banner['products'].take(2).map<Widget>((product) => 
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                color: isDark ? colorScheme.surfaceVariant : colorScheme.surface,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: isDark
                                        ? Color.alphaBlend(Colors.black.withAlpha((0.18 * 255).round()), colorScheme.surface)
                                        : Color.alphaBlend(Colors.black.withAlpha((0.08 * 255).round()), colorScheme.surface),
                                    blurRadius: 10,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  product,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ).toList(),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Text(
                            banner['title'],
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: banner['textColor'],
                              letterSpacing: 1,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Flexible(
                          child: Text(
                            banner['subtitle'],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: banner['subtitleColor'],
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Flexible(
                          child: Text(
                            banner['description'],
                            style: TextStyle(
                              height: 1.5,
                              color: banner['descColor'],
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                          ),
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: banner['action'],
                          style: ElevatedButton.styleFrom(
                            backgroundColor: banner['buttonColor'],
                            foregroundColor: banner['backgroundColor'],
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                banner['buttonText'],
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: banner['backgroundColor'],
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Icon(
                                Icons.chevron_right,
                                size: 16,
                                color: banner['backgroundColor'],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
