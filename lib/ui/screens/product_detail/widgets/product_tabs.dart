import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../backend_integration/dtos/item/item_detail_dto.dart';
import '../../../../models/review.dart';
import '../../../../services/theme_service.dart';
import '../../../../themes/themes.dart';
import '../../../../utils/number_localization.dart';
import '../../../reusable_components/rating_stars/star_rating.dart';
import 'aurora_review_card.dart';

class ProductTabs extends StatefulWidget {
  const ProductTabs({
    super.key,
    required this.labels,
    required this.attributes,
    this.sizeMeasurements = const [],
    this.selectedSizeValueId,
    this.reviews = const [],
    this.averageRating = 0.0,
    this.totalReviewCount = 0,
    this.isLoadingMoreReviews = false,
    this.reviewsController,
  });

  final List<ItemDetailLabelDto> labels;
  final List<ItemDetailAttributeDto> attributes;
  final List<ItemDetailSizeMeasurementGroupDto> sizeMeasurements;
  final int? selectedSizeValueId;
  final List<Review> reviews;
  final double averageRating;
  final int totalReviewCount;
  final bool isLoadingMoreReviews;
  final ScrollController? reviewsController;

  @override
  State<ProductTabs> createState() => _ProductTabsState();
}

class _ProductTabsState extends State<ProductTabs> {
  int _activeIndex = 0;

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
                reviewCount: widget.totalReviewCount,
                isDark: isDark,
                onTap: (i) => setState(() => _activeIndex = i),
              ),
            ),
            SizedBox(
              height: 520,
              child: IndexedStack(
                index: _activeIndex,
                children: [
                  _DetailsTab(
                    labels: widget.labels,
                    attributes: widget.attributes,
                    sizeMeasurements: widget.sizeMeasurements,
                    selectedSizeValueId: widget.selectedSizeValueId,
                    isDark: isDark,
                  ),
                  _ReviewsTab(
                    rating: widget.averageRating,
                    totalReviewCount: widget.totalReviewCount,
                    reviews: widget.reviews,
                    isLoadingMore: widget.isLoadingMoreReviews,
                    controller: widget.reviewsController,
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
              label: 'product_tabs.tab_details'.tr(),
              isActive: activeIndex == 0,
              isDark: isDark,
              onTap: () => onTap(0),
            ),
          ),
          Expanded(
            child: _TabButton(
              label: 'product_tabs.tab_reviews'.tr(),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: pillBg,
                  border: Border.all(color: pillBorder),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  localizedNumber(count!),
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
  const _DetailsTab({
    required this.labels,
    required this.attributes,
    required this.sizeMeasurements,
    required this.selectedSizeValueId,
    required this.isDark,
  });

  final List<ItemDetailLabelDto> labels;
  final List<ItemDetailAttributeDto> attributes;
  final List<ItemDetailSizeMeasurementGroupDto> sizeMeasurements;
  final int? selectedSizeValueId;
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
      padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (labels.isNotEmpty) ...[
            _SectionLabel(
              label: 'product_tabs.certifications'.tr(),
              color: mutedLabel,
            ),
            const SizedBox(height: 10),
            ...labels.map(
              (l) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _AuroraCheckGlyph(),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        l.name,
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
          if (attributes.isNotEmpty) ...[
            _SectionLabel(
              label: 'product_tabs.specifications'.tr(),
              color: mutedLabel,
            ),
            const SizedBox(height: 10),
            _SpecsTileGrid(
              specs: {
                for (final a in attributes) a.attributeName: a.value,
              },
              cellBg: cellBg,
              cellBorder: cellBorder,
              mutedLabel: mutedLabel,
            ),
            if (sizeMeasurements.isNotEmpty) const SizedBox(height: 14),
          ],
          if (sizeMeasurements.isNotEmpty)
            _MeasurementsTable(
              groups: sizeMeasurements,
              selectedSizeValueId: selectedSizeValueId,
              isDark: isDark,
              mutedLabel: mutedLabel,
              cellBorder: cellBorder,
            ),
        ],
      ),
    );
  }
}

// ─── Measurements table (transposed: types=rows, sizes=columns) ───────────────

class _MeasurementsTable extends StatelessWidget {
  const _MeasurementsTable({
    required this.groups,
    required this.selectedSizeValueId,
    required this.isDark,
    required this.mutedLabel,
    required this.cellBorder,
  });

  final List<ItemDetailSizeMeasurementGroupDto> groups;
  final int? selectedSizeValueId;
  final bool isDark;
  final Color mutedLabel;
  final Color cellBorder;

  List<String> get _types {
    final seen = <String>{};
    final result = <String>[];
    for (final g in groups) {
      for (final m in g.measurements) {
        if (seen.add(m.measurementType)) result.add(m.measurementType);
      }
    }
    return result;
  }


  @override
  Widget build(BuildContext context) {
    final types = _types;
    if (types.isEmpty) return const SizedBox.shrink();

    final headerBg = isDark
        ? AppColors.white.withValues(alpha: 0.03)
        : AppColors.primaryPurple.withValues(alpha: 0.03);
    final divider = isDark
        ? AppColors.white.withValues(alpha: 0.06)
        : AppColors.primaryPurple.withValues(alpha: 0.08);
    final cellBg = isDark
        ? AppColors.white.withValues(alpha: 0.04)
        : AppColors.primaryPurple.withValues(alpha: 0.04);
    final bodyColor = (isDark ? AppColors.white : AppColors.primaryPurple)
        .withValues(alpha: 0.80);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _SectionLabel(
              label: 'product_tabs.measurements'.tr(),
              color: mutedLabel,
            ),
            const SizedBox(width: 6),
            Text(
              '(cm)',
              style: AppFonts.primary(
                fontSize: 9,
                fontWeight: FontWeight.w500,
                color: mutedLabel.withValues(alpha: 0.60),
                height: 1.1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            border: Border.all(color: cellBorder),
            borderRadius: BorderRadius.circular(12),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: IntrinsicWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header row: empty cell + one cell per size
                  Container(
                    color: headerBg,
                    child: Row(
                      children: [
                        _MCell(
                          width: 90,
                          bg: Colors.transparent,
                          border: BorderDirectional(
                              end: BorderSide(color: divider)),
                          child: const SizedBox.shrink(),
                        ),
                        // Column headers are size labels (38, XL). They stay in
                        // Western digits so they match the size chips.
                        ...groups.map((g) {
                          final isSelected =
                              g.sizeValueId == selectedSizeValueId;
                          return _MCell(
                            width: 56,
                            bg: isSelected
                                ? AppColors.auroraPurple.withValues(alpha: 0.08)
                                : Colors.transparent,
                            border: BorderDirectional(
                                end: BorderSide(color: divider)),
                            child: isSelected
                                ? ShaderMask(
                                    shaderCallback: (b) =>
                                        const LinearGradient(
                                      colors: AppColors.auroraGradient,
                                    ).createShader(b),
                                    blendMode: BlendMode.srcIn,
                                    child: Text(
                                      g.displayValue,
                                      textAlign: TextAlign.center,
                                      style: AppFonts.primary(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.white,
                                        height: 1.1,
                                      ),
                                    ),
                                  )
                                : Text(
                                    g.displayValue,
                                    textAlign: TextAlign.center,
                                    style: AppFonts.primary(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: mutedLabel,
                                      height: 1.1,
                                    ),
                                  ),
                          );
                        }),
                      ],
                    ),
                  ),
                  Container(height: 1, color: divider),
                  // Body rows: one row per measurement type
                  ...types.asMap().entries.map((entry) {
                    final i = entry.key;
                    final type = entry.value;
                    return Column(
                      children: [
                        Row(
                          children: [
                            _MCell(
                              width: 90,
                              bg: cellBg,
                              border:
                                  BorderDirectional(end: BorderSide(color: divider)),
                              child: Text(
                                type.toUpperCase(),
                                style: AppFonts.primary(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  color: mutedLabel,
                                  letterSpacing: 0.8,
                                  height: 1.1,
                                ),
                              ),
                            ),
                            ...groups.map((g) {
                              final isSelected =
                                  g.sizeValueId == selectedSizeValueId;
                              final m = g.measurements
                                  .where((m) => m.measurementType == type)
                                  .firstOrNull;
                              final val = m != null
                                  ? localizedNumber(m.value, decimals: 1)
                                  : '—';
                              return _MCell(
                                width: 56,
                                bg: isSelected
                                    ? AppColors.auroraPurple
                                        .withValues(alpha: 0.06)
                                    : Colors.transparent,
                                border:
                                    BorderDirectional(end: BorderSide(color: divider)),
                                child: Text(
                                  val,
                                  textAlign: TextAlign.center,
                                  style: AppFonts.primary(
                                    fontSize: 11,
                                    fontWeight: isSelected
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                    color: isSelected ? bodyColor : mutedLabel,
                                    height: 1.1,
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                        if (i < types.length - 1)
                          Container(height: 1, color: divider),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _MCell extends StatelessWidget {
  const _MCell({
    required this.width,
    required this.bg,
    required this.border,
    required this.child,
  });

  final double width;
  final Color bg;
  final BoxBorder border;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 9),
      decoration: BoxDecoration(color: bg, border: border),
      child: child,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

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
    required this.rating,
    required this.totalReviewCount,
    required this.reviews,
    required this.isLoadingMore,
    required this.controller,
  });

  final double rating;
  final int totalReviewCount;
  final List<Review> reviews;
  final bool isLoadingMore;
  final ScrollController? controller;

  @override
  Widget build(BuildContext context) {
    final itemCount = 1 + reviews.length + (isLoadingMore ? 1 : 0);
    return ListView.builder(
      controller: controller ?? ScrollController(),
      padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 20),
      itemCount: itemCount,
      itemBuilder: (context, i) {
        if (i == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _ReviewSummary(
              rating: rating,
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
                rating > 0 ? localizedNumber(rating, decimals: 1) : '—',
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
                    if (rating > 0)
                      StarRating(rating: rating, size: 13, showValue: false),
                    const SizedBox(height: 4),
                    Text(
                      reviewCount > 0
                          ? 'product_tabs.based_on_reviews'.tr(
                              namedArgs: {
                                'count': localizedNumber(reviewCount),
                              },
                            )
                          : 'product_tabs.no_reviews_yet'.tr(),
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
