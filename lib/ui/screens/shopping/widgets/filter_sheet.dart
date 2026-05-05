import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../models/product.dart';
import '../../../../services/theme_service.dart';
import '../../../../themes/app_colors.dart';
import '../../../../themes/app_text_styles.dart';
import '../../../reusable_components/aurora/aurora_primary_button.dart';
import 'filter_state.dart';

class FilterSheet extends StatefulWidget {
  final FilterState initial;
  final double priceMin;
  final double priceMax;
  final List<ColorVariant> availableColors;
  final List<SizeVariant> availableSizes;

  const FilterSheet({
    super.key,
    required this.initial,
    required this.priceMin,
    required this.priceMax,
    required this.availableColors,
    required this.availableSizes,
  });

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  late FilterState _draft = widget.initial;

  int get _activeCount => _draft.activeCount(
        priceMin: widget.priceMin,
        priceMax: widget.priceMax,
      );

  void _resetAll() => setState(() {
        _draft = FilterState.initial(
          priceMin: widget.priceMin,
          priceMax: widget.priceMax,
        );
      });

  void _togglePrice(RangeValues v) =>
      setState(() => _draft = _draft.copyWith(priceRange: v));

  void _toggleColor(String name) {
    final next = {..._draft.colors};
    next.contains(name) ? next.remove(name) : next.add(name);
    setState(() => _draft = _draft.copyWith(colors: next));
  }

  void _toggleSize(String label) {
    final next = {..._draft.sizes};
    next.contains(label) ? next.remove(label) : next.add(label);
    setState(() => _draft = _draft.copyWith(sizes: next));
  }

  void _setRating(int stars) => setState(() {
        _draft = _draft.copyWith(
          minRating: _draft.minRating == stars ? 0 : stars,
        );
      });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService.instance,
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;
        final bg = isDark ? AppColors.auroraDeepBase : AppColors.white;
        final resetEnabled = _activeCount > 0;

        final mq = MediaQuery.of(context);
        final maxScrollHeight = (mq.size.height - mq.viewPadding.top - mq.viewPadding.bottom) * 0.60;

        return DecoratedBox(
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
            const SizedBox(height: 10),
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ShaderMask(
                      shaderCallback: (b) => const LinearGradient(
                        colors: AppColors.auroraGradient,
                      ).createShader(b),
                      blendMode: BlendMode.srcIn,
                      child: Text(
                        'Filters',
                        style: AppTextStyles.heading3.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 22,
                        ),
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: resetEnabled ? _resetAll : null,
                      behavior: HitTestBehavior.opaque,
                      child: Opacity(
                        opacity: resetEnabled ? 1.0 : 0.35,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: AppColors.auroraGradient,
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(1.5),
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: isDark ? AppColors.auroraDeepBase : AppColors.white,
                                borderRadius: BorderRadius.circular(6.5),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                                child: ShaderMask(
                                  shaderCallback: (b) => const LinearGradient(
                                    colors: AppColors.auroraGradient,
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ).createShader(b),
                                  blendMode: BlendMode.srcIn,
                                  child: Text(
                                    'Reset all',
                                    style: AppTextStyles.caption.copyWith(
                                      color: AppColors.white,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 12,
                                      letterSpacing: 0.5,
                                      height: 1.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 2),
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: maxScrollHeight),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SectionHeading('Price', isDark: isDark),
                      _PriceSection(
                        min: widget.priceMin,
                        max: widget.priceMax,
                        current: _draft.priceRange,
                        isDark: isDark,
                        onChanged: _togglePrice,
                      ),
                      const SizedBox(height: 14),
                      _FilterDropdown(
                        label: 'COLOR',
                        isDark: isDark,
                        preview: _ColorTriggerPreview(
                          colors: widget.availableColors,
                          selected: _draft.colors,
                          isDark: isDark,
                        ),
                        children: [
                          for (var i = 0;
                              i < widget.availableColors.length;
                              i++)
                            _ColorItem(
                              variant: widget.availableColors[i],
                              isSelected: _draft.colors
                                  .contains(widget.availableColors[i].name),
                              isDark: isDark,
                              isLast:
                                  i == widget.availableColors.length - 1,
                              onTap: () => _toggleColor(
                                  widget.availableColors[i].name),
                            ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      _FilterDropdown(
                        label: 'SIZE',
                        isDark: isDark,
                        preview: _SizeTriggerPreview(
                          sizes: widget.availableSizes,
                          selected: _draft.sizes,
                          isDark: isDark,
                        ),
                        children: [
                          for (var i = 0;
                              i < widget.availableSizes.length;
                              i++)
                            _SizeItem(
                              variant: widget.availableSizes[i],
                              isSelected: _draft.sizes.contains(
                                  widget.availableSizes[i].label),
                              isDark: isDark,
                              isLast:
                                  i == widget.availableSizes.length - 1,
                              onTap: () => widget.availableSizes[i]
                                      .isAvailable
                                  ? _toggleSize(
                                      widget.availableSizes[i].label)
                                  : null,
                            ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      _SectionHeading('Rating', isDark: isDark),
                      const SizedBox(height: 8),
                      _RatingSection(
                        min: _draft.minRating,
                        isDark: isDark,
                        onChanged: _setRating,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 6, 20, 20),
                child: AuroraPrimaryButton(
                  text: 'APPLY',
                  height: 48,
                  onPressed: () => Navigator.of(context).pop(_draft),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─── Section heading ──────────────────────────────────────────────────────────

class _SectionHeading extends StatelessWidget {
  final String text;
  final bool isDark;
  const _SectionHeading(this.text, {required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.caption.copyWith(
        color: isDark ? AppColors.white : AppColors.primaryPurple,
        fontWeight: FontWeight.w800,
        fontSize: 12,
        letterSpacing: 1.2,
      ),
    );
  }
}

// ─── Price ────────────────────────────────────────────────────────────────────

class _PriceSection extends StatelessWidget {
  final double min;
  final double max;
  final RangeValues current;
  final bool isDark;
  final ValueChanged<RangeValues> onChanged;

  const _PriceSection({
    required this.min,
    required this.max,
    required this.current,
    required this.isDark,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Row(
          children: [
            _GradientPriceText(value: current.start),
            Expanded(
              child: SliderTheme(
                data: SliderThemeData(
                  activeTrackColor: AppColors.auroraPink,
                  inactiveTrackColor: isDark
                      ? AppColors.white.withValues(alpha: 0.08)
                      : AppColors.primaryPurple.withValues(alpha: 0.12),
                  thumbColor: AppColors.white,
                  overlayColor:
                      AppColors.auroraPink.withValues(alpha: 0.20),
                  rangeThumbShape: const RoundRangeSliderThumbShape(
                    enabledThumbRadius: 9,
                    elevation: 4,
                  ),
                  rangeTrackShape:
                      const RoundedRectRangeSliderTrackShape(),
                  trackHeight: 3,
                  showValueIndicator: ShowValueIndicator.never,
                ),
                child: RangeSlider(
                  values: current,
                  min: min,
                  max: max,
                  onChanged: onChanged,
                ),
              ),
            ),
            _GradientPriceText(value: current.end),
          ],
        ),
      ],
    );
  }
}

class _GradientPriceText extends StatelessWidget {
  final double value;
  const _GradientPriceText({required this.value});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: AppColors.auroraGradient,
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
      blendMode: BlendMode.srcIn,
      child: Text(
        '\$${value.toStringAsFixed(0)}',
        style: AppTextStyles.auroraMonoPrice.copyWith(
          color: AppColors.white,
          fontSize: 13,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

// ─── Cohesive dropdown ────────────────────────────────────────────────────────

class _FilterDropdown extends StatefulWidget {
  final String label;
  final bool isDark;
  final Widget preview;
  final List<Widget> children;

  const _FilterDropdown({
    required this.label,
    required this.isDark,
    required this.preview,
    required this.children,
  });

  @override
  State<_FilterDropdown> createState() => _FilterDropdownState();
}

class _FilterDropdownState extends State<_FilterDropdown> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final fill = widget.isDark
        ? AppColors.white.withValues(alpha: 0.04)
        : AppColors.auroraPurple.withValues(alpha: 0.04);
    final borderColor = widget.isDark
        ? AppColors.white.withValues(alpha: 0.12)
        : AppColors.auroraPurple.withValues(alpha: 0.18);
    final labelColor =
        widget.isDark ? AppColors.white : AppColors.primaryPurple;
    final chevronColor = widget.isDark
        ? AppColors.white.withValues(alpha: 0.40)
        : AppColors.auroraPurple.withValues(alpha: 0.40);

    return AnimatedSize(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeInOut,
      alignment: Alignment.topCenter,
      child: Container(
        decoration: BoxDecoration(
          color: fill,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Trigger row
            GestureDetector(
              onTap: () => setState(() => _expanded = !_expanded),
              behavior: HitTestBehavior.opaque,
              child: SizedBox(
                height: 48,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Row(
                    children: [
                      Text(
                        widget.label,
                        style: AppTextStyles.caption.copyWith(
                          color: labelColor,
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                          letterSpacing: 1.1,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: widget.preview),
                      AnimatedRotation(
                        turns: _expanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: FaIcon(FontAwesomeIcons.chevronDown,
                            size: 12, color: chevronColor),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Fixed-height scrollable panel — same container, separated by a divider.
            // Capped at 220 px (~5 items); scrolls independently within that box.
            if (_expanded) ...[
              Container(height: 1, color: borderColor),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 220),
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: widget.children,
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

// ─── Shared checkbox ─────────────────────────────────────────────────────────

class _CheckBox extends StatelessWidget {
  final bool isChecked;
  final bool isDark;
  final bool disabled;

  const _CheckBox({
    required this.isChecked,
    required this.isDark,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isChecked) {
      return Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: AppColors.auroraGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        child: const Center(
          child: FaIcon(FontAwesomeIcons.check,
              size: 11, color: AppColors.white),
        ),
      );
    }
    final borderColor = disabled
        ? (isDark
            ? AppColors.white.withValues(alpha: 0.12)
            : AppColors.primaryPurple.withValues(alpha: 0.12))
        : (isDark
            ? AppColors.white.withValues(alpha: 0.22)
            : AppColors.primaryPurple.withValues(alpha: 0.25));
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: borderColor, width: 1.5),
      ),
    );
  }
}

// ─── Color dropdown ───────────────────────────────────────────────────────────

class _ColorTriggerPreview extends StatelessWidget {
  final List<ColorVariant> colors;
  final Set<String> selected;
  final bool isDark;

  const _ColorTriggerPreview({
    required this.colors,
    required this.selected,
    required this.isDark,
  });

  Color _hex(String hex) {
    final c = hex.replaceAll('#', '');
    return Color(int.parse('FF$c', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final selectedVariants =
        colors.where((c) => selected.contains(c.name)).toList();

    if (selectedVariants.isEmpty) {
      return Text(
        'All colors',
        style: AppTextStyles.caption.copyWith(
          color: isDark
              ? AppColors.white.withValues(alpha: 0.38)
              : AppColors.primaryPurple.withValues(alpha: 0.45),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      );
    }

    const maxDots = 4;
    final visible = selectedVariants.take(maxDots).toList();
    final overflow = selectedVariants.length - visible.length;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < visible.length; i++)
          Padding(
            padding: EdgeInsets.only(left: i == 0 ? 0 : 5),
            child: Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: _hex(visible[i].hexCode),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.white.withValues(alpha: 0.25),
                  width: 0.8,
                ),
              ),
            ),
          ),
        if (overflow > 0)
          Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Text(
              '+$overflow',
              style: AppTextStyles.captionSmall.copyWith(
                color: AppColors.auroraPink,
                fontWeight: FontWeight.w800,
                fontSize: 11,
              ),
            ),
          ),
      ],
    );
  }
}

class _ColorItem extends StatelessWidget {
  final ColorVariant variant;
  final bool isSelected;
  final bool isDark;
  final bool isLast;
  final VoidCallback onTap;

  const _ColorItem({
    required this.variant,
    required this.isSelected,
    required this.isDark,
    required this.isLast,
    required this.onTap,
  });

  Color _hex(String hex) {
    final c = hex.replaceAll('#', '');
    return Color(int.parse('FF$c', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final dividerColor = isDark
        ? AppColors.white.withValues(alpha: 0.06)
        : AppColors.auroraPurple.withValues(alpha: 0.08);
    final nameColor = isSelected
        ? (isDark ? AppColors.white : AppColors.auroraPurple)
        : (isDark
            ? AppColors.white.withValues(alpha: 0.85)
            : AppColors.primaryPurple);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            child: Row(
              children: [
                _CheckBox(isChecked: isSelected, isDark: isDark),
                const SizedBox(width: 12),
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: _hex(variant.hexCode),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDark
                          ? AppColors.white.withValues(alpha: 0.18)
                          : AppColors.primaryPurple.withValues(alpha: 0.20),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  variant.name,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: nameColor,
                    fontWeight:
                        isSelected ? FontWeight.w700 : FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          if (!isLast) Container(height: 1, color: dividerColor),
        ],
      ),
    );
  }
}

// ─── Size dropdown ────────────────────────────────────────────────────────────

class _SizeTriggerPreview extends StatelessWidget {
  final List<SizeVariant> sizes;
  final Set<String> selected;
  final bool isDark;

  const _SizeTriggerPreview({
    required this.sizes,
    required this.selected,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final selectedLabels =
        sizes.where((s) => selected.contains(s.label)).map((s) => s.label).toList();

    if (selectedLabels.isEmpty) {
      return Text(
        'All sizes',
        style: AppTextStyles.caption.copyWith(
          color: isDark
              ? AppColors.white.withValues(alpha: 0.38)
              : AppColors.primaryPurple.withValues(alpha: 0.45),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      );
    }

    final preview = selectedLabels.take(3).join(', ');
    final overflow = selectedLabels.length - 3;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: AppColors.auroraGradient,
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            '${selectedLabels.length}',
            style: AppTextStyles.captionSmall.copyWith(
              color: AppColors.white,
              fontSize: 10,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          overflow > 0 ? '$preview +$overflow' : preview,
          style: AppTextStyles.caption.copyWith(
            color: isDark
                ? AppColors.white.withValues(alpha: 0.75)
                : AppColors.primaryPurple.withValues(alpha: 0.80),
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _SizeItem extends StatelessWidget {
  final SizeVariant variant;
  final bool isSelected;
  final bool isDark;
  final bool isLast;
  final VoidCallback? onTap;

  const _SizeItem({
    required this.variant,
    required this.isSelected,
    required this.isDark,
    required this.isLast,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dividerColor = isDark
        ? AppColors.white.withValues(alpha: 0.06)
        : AppColors.auroraPurple.withValues(alpha: 0.08);
    final isAvailable = variant.isAvailable;
    final nameColor = !isAvailable
        ? (isDark
            ? AppColors.white.withValues(alpha: 0.28)
            : AppColors.primaryPurple.withValues(alpha: 0.28))
        : isSelected
            ? (isDark ? AppColors.white : AppColors.auroraPurple)
            : (isDark
                ? AppColors.white.withValues(alpha: 0.85)
                : AppColors.primaryPurple);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            child: Row(
              children: [
                _CheckBox(
                  isChecked: isSelected && isAvailable,
                  isDark: isDark,
                  disabled: !isAvailable,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    variant.label,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: nameColor,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w600,
                      fontSize: 13,
                      decoration: !isAvailable
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      decorationColor: nameColor,
                    ),
                  ),
                ),
                if (!isAvailable)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.auroraRed.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Out of stock',
                      style: AppTextStyles.captionSmall.copyWith(
                        color: AppColors.auroraRed,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (!isLast) Container(height: 1, color: dividerColor),
        ],
      ),
    );
  }
}

// ─── Rating ───────────────────────────────────────────────────────────────────

class _RatingSection extends StatelessWidget {
  final int min;
  final bool isDark;
  final ValueChanged<int> onChanged;

  const _RatingSection({
    required this.min,
    required this.isDark,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final primaryText = isDark ? AppColors.white : AppColors.primaryPurple;
    final idleStar = isDark
        ? AppColors.white.withValues(alpha: 0.22)
        : AppColors.primaryPurple.withValues(alpha: 0.28);
    final label = min == 0 ? 'Any rating' : '$min & up';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        for (var i = 1; i <= 5; i++)
          _StarButton(
            isFilled: i <= min,
            idleColor: idleStar,
            onTap: () => onChanged(i),
          ),
        const SizedBox(width: 14),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: primaryText.withValues(alpha: 0.85),
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _StarButton extends StatelessWidget {
  final bool isFilled;
  final Color idleColor;
  final VoidCallback onTap;

  const _StarButton({
    required this.isFilled,
    required this.idleColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 4),
        child: FaIcon(
          FontAwesomeIcons.solidStar,
          size: 22,
          color: isFilled ? AppColors.accentYellow : idleColor,
          shadows: isFilled
              ? [
                  Shadow(
                    color: AppColors.accentYellow.withValues(alpha: 0.55),
                    blurRadius: 10,
                  ),
                ]
              : null,
        ),
      ),
    );
  }
}
