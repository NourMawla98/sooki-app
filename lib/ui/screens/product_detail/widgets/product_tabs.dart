import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../models/product.dart';
import '../../../../services/theme_service.dart';
import '../../../../themes/themes.dart';
import '../../../reusable_components/rating_stars/star_rating.dart';
import 'aurora_review_card.dart';

class ProductTabs extends StatefulWidget {
  final Product product;
  final List<Review> reviews;

  const ProductTabs({
    super.key,
    required this.product,
    required this.reviews,
  });

  @override
  State<ProductTabs> createState() => _ProductTabsState();
}

class _ProductTabsState extends State<ProductTabs> {
  static const int _pageSize = 10;
  static const double _prefetchThreshold = 220;
  static const Duration _fetchDelay = Duration(milliseconds: 400);

  int _activeIndex = 0;
  late final ScrollController _reviewsController;
  late List<Review> _loadedReviews;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _reviewsController = ScrollController()..addListener(_onReviewsScroll);
    _loadedReviews = widget.reviews.take(_pageSize).toList();
  }

  @override
  void dispose() {
    _reviewsController.removeListener(_onReviewsScroll);
    _reviewsController.dispose();
    super.dispose();
  }

  bool get _hasMore => _loadedReviews.length < widget.reviews.length;

  void _onReviewsScroll() {
    if (_isLoadingMore || !_hasMore) return;
    if (!_reviewsController.hasClients) return;
    if (_reviewsController.position.extentAfter > _prefetchThreshold) return;
    _fetchMore();
  }

  Future<void> _fetchMore() async {
    setState(() => _isLoadingMore = true);
    await Future.delayed(_fetchDelay);
    if (!mounted) return;
    final next = widget.reviews
        .skip(_loadedReviews.length)
        .take(_pageSize)
        .toList();
    setState(() {
      _loadedReviews = [..._loadedReviews, ...next];
      _isLoadingMore = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService.instance,
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _CustomTabBar(
                activeIndex: _activeIndex,
                reviewCount: widget.reviews.length,
                isDark: isDark,
                onTap: (i) => setState(() => _activeIndex = i),
              ),
            ),
            SizedBox(
              height: 520,
              child: IndexedStack(
                index: _activeIndex,
                children: [
                  _DetailsTab(product: widget.product, isDark: isDark),
                  _ReviewsTab(
                    product: widget.product,
                    totalReviewCount: widget.reviews.length,
                    reviews: _loadedReviews,
                    isLoadingMore: _isLoadingMore,
                    controller: _reviewsController,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _CustomTabBar extends StatelessWidget {
  const _CustomTabBar({
    required this.activeIndex,
    required this.reviewCount,
    required this.isDark,
    required this.onTap,
  });

  final int activeIndex;
  final int reviewCount;
  final bool isDark;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final divider = isDark
        ? AppColors.white.withValues(alpha: 0.08)
        : AppColors.primaryPurple.withValues(alpha: 0.12);

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: divider)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _TabButton(
              label: 'DETAILS',
              isActive: activeIndex == 0,
              isDark: isDark,
              onTap: () => onTap(0),
            ),
          ),
          Expanded(
            child: _TabButton(
              label: 'REVIEWS',
              count: reviewCount,
              isActive: activeIndex == 1,
              isDark: isDark,
              onTap: () => onTap(1),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.label,
    required this.isActive,
    required this.isDark,
    required this.onTap,
    this.count,
  });

  final String label;
  final int? count;
  final bool isActive;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final inactiveColor = (isDark ? AppColors.white : AppColors.primaryPurple)
        .withValues(alpha: 0.55);
    final pillBg = isDark
        ? AppColors.white.withValues(alpha: 0.06)
        : AppColors.primaryPurple.withValues(alpha: 0.06);
    final pillBorder = isDark
        ? AppColors.white.withValues(alpha: 0.10)
        : AppColors.primaryPurple.withValues(alpha: 0.18);
    final pillTextColor = (isDark ? AppColors.white : AppColors.primaryPurple)
        .withValues(alpha: 0.85);

    Widget labelWidget = Text(
      label,
      style: AppFonts.primary(
        fontSize: 12,
        fontWeight: FontWeight.w800,
        color: isActive ? AppColors.white : inactiveColor,
        letterSpacing: 0.8,
        height: 1.2,
      ),
    );

    if (isActive) {
      labelWidget = ShaderMask(
        shaderCallback: (bounds) => const LinearGradient(
          colors: [
            AppColors.auroraPink,
            AppColors.auroraElectricBlue,
          ],
        ).createShader(bounds),
        child: labelWidget,
      );
    }

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isActive ? AppColors.auroraPink : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            labelWidget,
            if (count != null) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: pillBg,
                  border: Border.all(color: pillBorder),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '$count',
                  style: AppFonts.primary(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: pillTextColor,
                    height: 1.1,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DetailsTab extends StatelessWidget {
  const _DetailsTab({required this.product, required this.isDark});

  final Product product;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final bodyColor = (isDark ? AppColors.white : AppColors.primaryPurple)
        .withValues(alpha: 0.85);
    final mutedLabel = (isDark ? AppColors.white : AppColors.primaryPurple)
        .withValues(alpha: 0.55);
    final cellBg = isDark
        ? AppColors.white.withValues(alpha: 0.04)
        : AppColors.primaryPurple.withValues(alpha: 0.04);
    final cellBorder = isDark
        ? AppColors.white.withValues(alpha: 0.10)
        : AppColors.primaryPurple.withValues(alpha: 0.18);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (product.description.isNotEmpty) ...[
            Text(
              product.description,
              style: AppFonts.primary(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: bodyColor,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 18),
          ],
          if (product.features.isNotEmpty) ...[
            _SectionLabel(label: 'KEY FEATURES', color: mutedLabel),
            const SizedBox(height: 10),
            ...product.features.map(
              (feature) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _AuroraCheckGlyph(),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        feature,
                        style: AppFonts.primary(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: bodyColor,
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
          ],
          if (product.specifications.isNotEmpty) ...[
            _SectionLabel(label: 'SPECIFICATIONS', color: mutedLabel),
            const SizedBox(height: 10),
            _SpecsTileGrid(
              specs: product.specifications,
              cellBg: cellBg,
              cellBorder: cellBorder,
              mutedLabel: mutedLabel,
            ),
          ],
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: AppFonts.primary(
        fontSize: 10,
        fontWeight: FontWeight.w800,
        color: color,
        letterSpacing: 1.4,
        height: 1.1,
      ),
    );
  }
}

class _AuroraCheckGlyph extends StatelessWidget {
  const _AuroraCheckGlyph();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 16,
      height: 18,
      child: Center(
        child: ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [
              AppColors.auroraPink,
              AppColors.auroraPurple,
              AppColors.auroraElectricBlue,
            ],
          ).createShader(bounds),
          child: const FaIcon(
            FontAwesomeIcons.check,
            size: 14,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }
}

class _ReviewsTab extends StatelessWidget {
  const _ReviewsTab({
    required this.product,
    required this.totalReviewCount,
    required this.reviews,
    required this.isLoadingMore,
    required this.controller,
  });

  final Product product;
  final int totalReviewCount;
  final List<Review> reviews;
  final bool isLoadingMore;
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    final itemCount = 1 + reviews.length + (isLoadingMore ? 1 : 0);
    return ListView.builder(
      controller: controller,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      itemCount: itemCount,
      itemBuilder: (context, i) {
        if (i == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _ReviewSummary(
              rating: product.rating,
              reviewCount: totalReviewCount,
            ),
          );
        }
        final reviewIndex = i - 1;
        if (reviewIndex >= reviews.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: _AuroraSpinner()),
          );
        }
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: AuroraReviewCard(review: reviews[reviewIndex]),
        );
      },
    );
  }
}

class _ReviewSummary extends StatelessWidget {
  const _ReviewSummary({required this.rating, required this.reviewCount});

  final double rating;
  final int reviewCount;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService.instance,
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;
        final cellBg = isDark
            ? AppColors.white.withValues(alpha: 0.04)
            : AppColors.primaryPurple.withValues(alpha: 0.04);
        final cellBorder = isDark
            ? AppColors.white.withValues(alpha: 0.10)
            : AppColors.primaryPurple.withValues(alpha: 0.18);
        final textColor = isDark ? AppColors.white : AppColors.primaryPurple;
        final mutedColor = textColor.withValues(alpha: 0.55);
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: cellBg,
            border: Border.all(color: cellBorder),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                rating.toStringAsFixed(1),
                style: AppFonts.primary(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: textColor,
                  height: 1.0,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    StarRating(rating: rating, size: 13, showValue: false),
                    const SizedBox(height: 4),
                    Text(
                      'Based on $reviewCount reviews',
                      style: AppFonts.primary(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: mutedColor,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AuroraSpinner extends StatelessWidget {
  const _AuroraSpinner();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 22,
      height: 22,
      child: ShaderMask(
        shaderCallback: (bounds) => const LinearGradient(
          colors: [
            AppColors.auroraPink,
            AppColors.auroraElectricBlue,
          ],
        ).createShader(bounds),
        child: const CircularProgressIndicator(
          strokeWidth: 2,
          color: AppColors.white,
        ),
      ),
    );
  }
}

class _SpecsTileGrid extends StatelessWidget {
  const _SpecsTileGrid({
    required this.specs,
    required this.cellBg,
    required this.cellBorder,
    required this.mutedLabel,
  });

  final Map<String, String> specs;
  final Color cellBg;
  final Color cellBorder;
  final Color mutedLabel;

  @override
  Widget build(BuildContext context) {
    final entries = specs.entries.toList();
    final rows = <Widget>[];
    for (var i = 0; i < entries.length; i += 2) {
      if (rows.isNotEmpty) rows.add(const SizedBox(height: 10));
      rows.add(
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _SpecTile(
                  keyLabel: entries[i].key,
                  value: entries[i].value,
                  cellBg: cellBg,
                  cellBorder: cellBorder,
                  mutedLabel: mutedLabel,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: i + 1 < entries.length
                    ? _SpecTile(
                        keyLabel: entries[i + 1].key,
                        value: entries[i + 1].value,
                        cellBg: cellBg,
                        cellBorder: cellBorder,
                        mutedLabel: mutedLabel,
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: rows,
    );
  }
}

class _SpecTile extends StatelessWidget {
  const _SpecTile({
    required this.keyLabel,
    required this.value,
    required this.cellBg,
    required this.cellBorder,
    required this.mutedLabel,
  });

  final String keyLabel;
  final String value;
  final Color cellBg;
  final Color cellBorder;
  final Color mutedLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: cellBg,
        border: Border.all(color: cellBorder),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            keyLabel.toUpperCase(),
            style: AppFonts.primary(
              fontSize: 9,
              fontWeight: FontWeight.w800,
              color: mutedLabel,
              letterSpacing: 1.2,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 6),
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [
                AppColors.auroraPink,
                AppColors.auroraElectricBlue,
              ],
            ).createShader(bounds),
            child: Text(
              value,
              style: AppFonts.primary(
                fontSize: 15,
                fontWeight: FontWeight.w900,
                color: AppColors.white,
                height: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
