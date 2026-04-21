import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../services/theme_service.dart';
import '../../../../themes/themes.dart';

class ImageGallery extends StatefulWidget {
  final List<String> imageUrls;
  final bool isVerified;
  final int? discountPercentage;
  final void Function(int index)? onHeroTap;
  final ValueChanged<int>? onIndexChanged;

  const ImageGallery({
    super.key,
    required this.imageUrls,
    this.isVerified = false,
    this.discountPercentage,
    this.onHeroTap,
    this.onIndexChanged,
  });

  @override
  State<ImageGallery> createState() => ImageGalleryState();
}

class ImageGalleryState extends State<ImageGallery> {
  late final PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void didUpdateWidget(covariant ImageGallery oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.imageUrls.length != oldWidget.imageUrls.length &&
        _currentIndex >= widget.imageUrls.length) {
      _currentIndex = 0;
      if (_pageController.hasClients) {
        _pageController.jumpToPage(0);
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void jumpToIndex(int index) {
    if (index < 0 || index >= widget.imageUrls.length) return;
    if (index == _currentIndex) return;
    if (!_pageController.hasClients) {
      _currentIndex = index;
      return;
    }
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  void _jumpTo(int index) => jumpToIndex(index);

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService.instance,
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;
        final count = widget.imageUrls.length;

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 0),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: SizedBox(
                      height: 260,
                      width: double.infinity,
                      child: count == 0
                          ? _imagePlaceholder()
                          : PageView.builder(
                              controller: _pageController,
                              physics: const ClampingScrollPhysics(),
                              itemCount: count,
                              onPageChanged: (i) {
                                setState(() => _currentIndex = i);
                                widget.onIndexChanged?.call(i);
                              },
                              itemBuilder: (context, i) => GestureDetector(
                                onTap: widget.onHeroTap == null
                                    ? null
                                    : () => widget.onHeroTap!(i),
                                child: _buildImage(widget.imageUrls[i]),
                              ),
                            ),
                    ),
                  ),
                if (widget.isVerified)
                  Positioned(
                    bottom: 12,
                    left: 12,
                    child: _VerifiedPill(isDark: isDark),
                  ),
                if (widget.discountPercentage != null)
                  Positioned(
                    bottom: 12,
                    right: 12,
                    child: _DiscountPill(
                      percent: widget.discountPercentage!,
                      isDark: isDark,
                    ),
                  ),
                ],
              ),
            ),
            if (count > 1) ...[
              const SizedBox(height: 10),
              Center(
                child: _AuroraDotIndicator(
                  count: count,
                  activeIndex: _currentIndex,
                  isDark: isDark,
                ),
              ),
            ],
            const SizedBox(height: 10),
            if (count > 1)
              SizedBox(
                height: 50,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.fromLTRB(14, 4, 14, 6),
                  itemCount: count,
                  separatorBuilder: (_, _) => const SizedBox(width: 6),
                  itemBuilder: (context, i) {
                    final isSelected = i == _currentIndex;
                    final borderColor = isSelected
                        ? AppColors.auroraElectricBlue
                        : (isDark
                            ? AppColors.white.withValues(alpha: 0.10)
                            : AppColors.primaryPurple.withValues(alpha: 0.18));
                    return GestureDetector(
                      onTap: () => _jumpTo(i),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(9),
                          border: Border.all(
                            color: borderColor,
                            width: isSelected ? 1.5 : 1,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: AppColors.auroraElectricBlue
                                        .withValues(alpha: 0.18),
                                    blurRadius: 0,
                                    spreadRadius: 2,
                                  ),
                                ]
                              : null,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(7),
                          child: _buildImage(widget.imageUrls[i]),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildImage(String url, {BoxFit fit = BoxFit.cover}) {
    if (url.startsWith('http')) {
      return Image.network(
        url,
        fit: fit,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (_, _, _) => _imagePlaceholder(),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: AppColors.gray200,
            child: const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.auroraElectricBlue,
              ),
            ),
          );
        },
      );
    }
    return Image.asset(
      url,
      fit: fit,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (_, _, _) => _imagePlaceholder(),
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      color: AppColors.gray200,
      child: const Center(
        child: FaIcon(
          FontAwesomeIcons.image,
          color: AppColors.gray400,
          size: 48,
        ),
      ),
    );
  }
}

class _AuroraDotIndicator extends StatelessWidget {
  const _AuroraDotIndicator({
    required this.count,
    required this.activeIndex,
    required this.isDark,
  });

  final int count;
  final int activeIndex;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final inactive = isDark
        ? AppColors.white.withValues(alpha: 0.22)
        : AppColors.primaryPurple.withValues(alpha: 0.30);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (i) {
        final isActive = i == activeIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          margin: const EdgeInsets.symmetric(horizontal: 2.5),
          width: isActive ? 18 : 5,
          height: 5,
          decoration: BoxDecoration(
            color: isActive ? AppColors.auroraElectricBlue : inactive,
            borderRadius: BorderRadius.circular(3),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: AppColors.auroraElectricBlue.withValues(alpha: 0.45),
                      blurRadius: 6,
                    ),
                  ]
                : null,
          ),
        );
      }),
    );
  }
}

class _VerifiedPill extends StatelessWidget {
  const _VerifiedPill({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.verifiedGreen.withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: AppColors.verifiedGreen.withValues(alpha: 0.55),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const FaIcon(
            FontAwesomeIcons.solidCircleCheck,
            size: 10,
            color: AppColors.verifiedGreen,
          ),
          const SizedBox(width: 5),
          Text(
            'VERIFIED',
            style: AppFonts.primary(
              fontSize: 9,
              fontWeight: FontWeight.w800,
              color: isDark
                  ? AppColors.verifiedGreen
                  : AppColors.verifiedGreen,
              letterSpacing: 0.5,
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}

class _DiscountPill extends StatelessWidget {
  const _DiscountPill({required this.percent, required this.isDark});
  final int percent;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.auroraElectricBlue.withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: AppColors.auroraElectricBlue.withValues(alpha: 0.55),
        ),
      ),
      child: Text(
        '-$percent%',
        style: AppFonts.primary(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          color: AppColors.auroraElectricBlue,
          letterSpacing: 0.4,
          height: 1.0,
        ),
      ),
    );
  }
}
