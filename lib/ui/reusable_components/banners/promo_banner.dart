import 'dart:async';

import 'package:flutter/material.dart';

import '../../../backend_integration/dtos/banner/banner_dto.dart';
import '../../../themes/themes.dart';
import '../indicators/dot_indicator.dart';
import 'banner_badge.dart';

/// A promotional banner with image carousel.
///
/// Features:
/// - Edge-to-edge layout with only bottom corners rounded
/// - Scrolls through imageUrls as background images
/// - Auto-scroll and manual swipe support
/// - Dot indicators for current image
class PromoBanner extends StatefulWidget {
  final List<BannerDto> banners;
  final Function(String redirectionRoute)? onShopNowPressed;
  final double height;
  final Duration autoScrollDuration;
  final bool enableAutoScroll;

  const PromoBanner({
    super.key,
    required this.banners,
    this.onShopNowPressed,
    this.height = 330,
    this.autoScrollDuration = const Duration(seconds: 4),
    this.enableAutoScroll = true,
  });

  @override
  State<PromoBanner> createState() => _PromoBannerState();
}

class _PromoBannerState extends State<PromoBanner> {
  late final PageController _pageController;
  Timer? _autoScrollTimer;
  int _currentPage = 0;

  // Get all images from the first banner (or combine from all banners)
  List<String> get _allImages {
    if (widget.banners.isEmpty) return [];
    // Use images from the first banner
    return widget.banners.first.imageUrls;
  }

  BannerDto? get _banner =>
      widget.banners.isNotEmpty ? widget.banners.first : null;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoScrollIfNeeded();
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoScrollIfNeeded() {
    if (widget.enableAutoScroll && _allImages.length > 1) {
      _autoScrollTimer = Timer.periodic(widget.autoScrollDuration, (_) {
        if (!mounted) return;
        final nextPage = (_currentPage + 1) % _allImages.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  void _onPageChanged(int page) {
    setState(() => _currentPage = page);
  }

  @override
  Widget build(BuildContext context) {
    if (_banner == null || _allImages.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: widget.height,
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.primaryPurple,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Image carousel
            PageView.builder(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              itemCount: _allImages.length,
              itemBuilder: (context, index) =>
                  _BackgroundImage(imageUrl: _allImages[index]),
            ),

            // Gradient overlay for text readability
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.black.withValues(alpha: 0.2),
                    AppColors.black.withValues(alpha: 0.5),
                  ],
                ),
              ),
            ),

            // Content overlay (centered)
            _BannerContent(
              banner: _banner!,
              onShopNowPressed: widget.onShopNowPressed,
            ),

            // Dot indicators
            if (_allImages.length > 1)
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: DotIndicator(
                  itemCount: _allImages.length,
                  currentIndex: _currentPage,
                  activeColor: AppColors.white,
                  inactiveColor: AppColors.white.withValues(alpha: 0.5),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _BackgroundImage extends StatelessWidget {
  final String imageUrl;

  const _BackgroundImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (context, error, stackTrace) =>
          Container(color: AppColors.primaryPurple),
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          color: AppColors.primaryPurple,
          child: Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                  : null,
              color: AppColors.white,
              strokeWidth: 2,
            ),
          ),
        );
      },
    );
  }
}

class _BannerContent extends StatelessWidget {
  final BannerDto banner;
  final Function(String redirectionRoute)? onShopNowPressed;

  const _BannerContent({required this.banner, this.onShopNowPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Badge (shows title field)
            if (banner.title.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: BannerBadge(
                  text: banner.title,
                  backgroundColor: AppColors.bannerBadgeYellow,
                  textColor: AppColors.primaryPurple,
                  fontSize: 13,
                ),
              ),

            // Main text (shows subtitle field)
            if (banner.subtitle != null && banner.subtitle!.isNotEmpty)
              Text(
                banner.subtitle!,
                style: AppTextStyles.heading1.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 28,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

            // Description
            if (banner.description != null && banner.description!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  banner.description!,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.white.withValues(alpha: 0.9),
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

            // Shop Now button
            if (banner.redirectionRoute != null &&
                banner.redirectionRoute!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 32),
                child: _ShopNowButton(
                  onPressed: () =>
                      onShopNowPressed?.call(banner.redirectionRoute!),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ShopNowButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _ShopNowButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.accentRed,
      borderRadius: BorderRadius.circular(360),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(360),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
          child: Text(
            'Shop Now',
            style: AppTextStyles.buttonMedium.copyWith(
              color: AppColors.white,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}
