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
    // TODO: Navigate to the redirection route
    // Navigator.pushNamed(context, redirectionRoute);
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

    return PromoBanner(
      banners: _banners!,
      onShopNowPressed: _onShopNowPressed,
    );
  }
}

/// Loading state placeholder for the banner
class _BannerLoadingState extends StatelessWidget {
  const _BannerLoadingState();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 380,
      decoration: const BoxDecoration(
        color: AppColors.gray200,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Center(
        child: CircularProgressIndicator(
          color: AppColors.primaryPurple,
          strokeWidth: 2,
        ),
      ),
    );
  }
}

/// Error state with retry button
class _BannerErrorState extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const _BannerErrorState({
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 380,
      decoration: const BoxDecoration(
        color: AppColors.gray200,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
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
