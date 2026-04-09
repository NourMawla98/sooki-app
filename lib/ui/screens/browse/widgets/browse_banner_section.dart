import 'package:flutter/material.dart';

import '../../../../backend_integration/apis/banner_api.dart';
import '../../../../backend_integration/dependency_injection/dependency_injection.dart';
import '../../../../backend_integration/dtos/banner/banner_dto.dart';
import '../../../../enums/banner_type.dart';
import '../../../../themes/themes.dart';
import '../../../reusable_components/banners/promo_banner.dart';

/// Banner section widget for the Browse screen.
///
/// Handles fetching banners from the API and displaying them
/// in a carousel format using [PromoBanner].
class BrowseBannerSection extends StatefulWidget {
  const BrowseBannerSection({super.key});

  @override
  State<BrowseBannerSection> createState() => _BrowseBannerSectionState();
}

class _BrowseBannerSectionState extends State<BrowseBannerSection> {
  late final BannerApi _bannerApi;
  List<BannerDto>? _banners;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _bannerApi = serviceLocator<BannerApi>();
    _loadBanners();
  }

  Future<void> _loadBanners() async {
    final result = await _bannerApi.getBanners(type: BannerType.browsePage);

    if (!mounted) return;

    result.fold(
      (failure) => setState(() {
        _error = failure.message;
        _isLoading = false;
      }),
      (banners) => setState(() {
        _banners = banners;
        _isLoading = false;
      }),
    );
  }

  void _onShopNowPressed(String redirectionRoute) {
    if (redirectionRoute.isNotEmpty) {
      Navigator.pushNamed(context, redirectionRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const _BannerLoadingState();
    }

    if (_error != null) {
      return _BannerErrorState(
        error: _error!,
        onRetry: () {
          setState(() {
            _isLoading = true;
            _error = null;
          });
          _loadBanners();
        },
      );
    }

    if (_banners == null || _banners!.isEmpty) {
      return const SizedBox.shrink();
    }

    return PromoBanner(banners: _banners!, onShopNowPressed: _onShopNowPressed);
  }
}

/// Shimmer skeleton loading state for the banner.
///
/// Mimics the real banner layout with animated shimmer placeholders
/// for badge, title, description, and button.
class _BannerLoadingState extends StatefulWidget {
  const _BannerLoadingState();

  @override
  State<_BannerLoadingState> createState() => _BannerLoadingStateState();
}

class _BannerLoadingStateState extends State<_BannerLoadingState>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 330,
      decoration: BoxDecoration(
        color: AppColors.primaryPurple.withValues(alpha: 0.15),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(36),
          bottomRight: Radius.circular(36),
        ),
      ),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return ShaderMask(
            shaderCallback: (bounds) {
              return LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  AppColors.gray300.withValues(alpha: 0.3),
                  AppColors.gray200.withValues(alpha: 0.6),
                  AppColors.gray300.withValues(alpha: 0.3),
                ],
                stops: [
                  (_controller.value - 0.3).clamp(0.0, 1.0),
                  _controller.value,
                  (_controller.value + 0.3).clamp(0.0, 1.0),
                ],
              ).createShader(bounds);
            },
            blendMode: BlendMode.srcATop,
            child: child!,
          );
        },
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Badge placeholder
                Container(
                  width: 160,
                  height: 28,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                const SizedBox(height: 16),
                // Title line 1
                Container(
                  width: 220,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const SizedBox(height: 10),
                // Title line 2
                Container(
                  width: 180,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const SizedBox(height: 12),
                // Description placeholder
                Container(
                  width: 240,
                  height: 14,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 32),
                // Button placeholder
                Container(
                  width: 120,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(360),
                  ),
                ),
                const SizedBox(height: 24),
                // Dot indicators placeholder
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    3,
                    (i) => Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Error state with retry button
class _BannerErrorState extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const _BannerErrorState({required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 330,
      decoration: BoxDecoration(
        color: AppColors.primaryPurple.withValues(alpha: 0.08),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(36),
          bottomRight: Radius.circular(36),
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Failed to load banners',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: onRetry,
              child: Text(
                'Retry',
                style: AppTextStyles.buttonMedium.copyWith(
                  color: AppColors.primaryPurple,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
