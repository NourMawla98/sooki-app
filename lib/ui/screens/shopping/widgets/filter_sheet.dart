import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../models/product.dart';
import '../../../../services/theme_service.dart';
import '../../../../themes/app_colors.dart';
import '../../../../themes/app_text_styles.dart';
import '../../../reusable_components/aurora/aurora_primary_button.dart';
import 'filter_state.dart';

/// Bottom sheet that lets users narrow the Shopping grid. Maintains a
/// local draft of [FilterState] and only commits it when the user taps
/// the Apply button. Returns the committed state via `Navigator.pop`.
class FilterSheet extends StatefulWidget {
  /// The currently-applied filters, used to seed the draft.
  final FilterState initial;

  /// Catalog-wide min/max prices. Defines the slider's extent and the
  /// "no price filter" sentinel (when both handles sit on these bounds).
  final double priceMin;
  final double priceMax;

  /// Distinct colour variants to render as swatches.
  final List<ColorVariant> availableColors;

  /// Distinct size variants to render as chips.
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

  void _resetAll() {
    setState(() {
      _draft = FilterState.initial(
        priceMin: widget.priceMin,
        priceMax: widget.priceMax,
      );
    });
  }

  void _togglePrice(RangeValues value) {
    setState(() => _draft = _draft.copyWith(priceRange: value));
  }

  void _toggleColor(String name) {
    final next = {..._draft.colors};
    if (next.contains(name)) {
      next.remove(name);
    } else {
      next.add(name);
    }
    setState(() => _draft = _draft.copyWith(colors: next));
  }

  void _toggleSize(String label) {
    final next = {..._draft.sizes};
    if (next.contains(label)) {
      next.remove(label);
    } else {
      next.add(label);
    }
    setState(() => _draft = _draft.copyWith(sizes: next));
  }

  void _setRating(int stars) {
    // Tapping the currently-set rating clears it.
    setState(() {
      _draft = _draft.copyWith(
        minRating: _draft.minRating == stars ? 0 : stars,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService.instance,
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;
        final bg = isDark ? AppColors.auroraDeepBase : AppColors.white;
        final handle = isDark
            ? AppColors.white.withValues(alpha: 0.35)
            : AppColors.primaryPurple.withValues(alpha: 0.35);
        final primaryText =
            isDark ? AppColors.white : AppColors.primaryPurple;
        final resetEnabled = _activeCount > 0;
        final resetColor = resetEnabled
            ? AppColors.auroraPink
            : (isDark
                ? AppColors.white.withValues(alpha: 0.35)
                : AppColors.primaryPurple.withValues(alpha: 0.35));

        final mediaQuery = MediaQuery.of(context);
        final maxHeight = mediaQuery.size.height * 0.88;

        return Container(
          constraints: BoxConstraints(maxHeight: maxHeight),
          decoration: BoxDecoration(
            color: bg,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: handle,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: AppColors.auroraCartButtonGradient,
                        ).createShader(bounds),
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
                    ),
                    GestureDetector(
                      onTap: resetEnabled ? _resetAll : null,
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: resetEnabled
                              ? AppColors.auroraPink.withValues(alpha: 0.10)
                              : Colors.transparent,
                          border: Border.all(
                            color: resetColor,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FaIcon(
                              FontAwesomeIcons.arrowRotateLeft,
                              size: 10,
                              color: resetColor,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'RESET ALL',
                              style: AppTextStyles.caption.copyWith(
                                color: resetColor,
                                fontWeight: FontWeight.w800,
                                fontSize: 11,
                                letterSpacing: 1.0,
                                height: 1.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SectionHeading('Price', isDark: isDark),
                      _PriceSection(
                        min: widget.priceMin,
                        max: widget.priceMax,
                        current: _draft.priceRange,
                        primaryText: primaryText,
                        isDark: isDark,
                        onChanged: _togglePrice,
                      ),
                      const SizedBox(height: 22),
                      _ColorDropdown(
                        colors: widget.availableColors,
                        selected: _draft.colors,
                        isDark: isDark,
                        onTap: _toggleColor,
                      ),
                      const SizedBox(height: 22),
                      _SectionHeading('Size', isDark: isDark),
                      const SizedBox(height: 8),
                      _SizeSection(
                        sizes: widget.availableSizes,
                        selected: _draft.sizes,
                        isDark: isDark,
                        onTap: _toggleSize,
                      ),
                      const SizedBox(height: 22),
                      _SectionHeading('Rating', isDark: isDark),
                      const SizedBox(height: 10),
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
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
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

// ─── Shared bits ─────────────────────────────────────────────────────────────

class _SectionHeading extends StatelessWidget {
  final String text;
  final bool isDark;
  const _SectionHeading(this.text, {required this.isDark});

  @override
  Widget build(BuildContext context) {
    final color =
        isDark ? AppColors.white : AppColors.primaryPurple;
    return Text(
      text,
      style: AppTextStyles.caption.copyWith(
        color: color,
        fontWeight: FontWeight.w800,
        fontSize: 12,
        letterSpacing: 1.2,
      ),
    );
  }
}

// ─── Price ───────────────────────────────────────────────────────────────────

class _PriceSection extends StatelessWidget {
  final double min;
  final double max;
  final RangeValues current;
  final Color primaryText;
  final bool isDark;
  final ValueChanged<RangeValues> onChanged;

  const _PriceSection({
    required this.min,
    required this.max,
    required this.current,
    required this.primaryText,
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
            _PriceChip(value: current.start, isDark: isDark),
            const Spacer(),
            _PriceChip(value: current.end, isDark: isDark),
          ],
        ),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: AppColors.auroraPink,
            inactiveTrackColor: isDark
                ? AppColors.white.withValues(alpha: 0.08)
                : AppColors.primaryPurple.withValues(alpha: 0.12),
            thumbColor: AppColors.white,
            overlayColor: AppColors.auroraPink.withValues(alpha: 0.20),
            rangeThumbShape: const RoundRangeSliderThumbShape(
              enabledThumbRadius: 9,
              elevation: 4,
            ),
            rangeTrackShape: const RoundedRectRangeSliderTrackShape(),
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
      ],
    );
  }
}

class _PriceChip extends StatelessWidget {
  final double value;
  final bool isDark;
  const _PriceChip({required this.value, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final bg = isDark
        ? AppColors.white.withValues(alpha: 0.05)
        : AppColors.primaryPurple.withValues(alpha: 0.06);
    final border = isDark
        ? AppColors.white.withValues(alpha: 0.12)
        : AppColors.primaryPurple.withValues(alpha: 0.18);
    final textColor = isDark ? AppColors.white : AppColors.primaryPurple;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: border),
      ),
      child: Text(
        '\$${value.toStringAsFixed(0)}',
        style: AppTextStyles.auroraMonoPrice.copyWith(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

// ─── Colour ──────────────────────────────────────────────────────────────────

/// Collapsible "Color" filter. Header shows a preview of currently-selected
/// swatches (up to 4 + overflow count); tapping toggles an animated
/// expansion that reveals the full [_ColorSection] of swatches below.
class _ColorDropdown extends StatefulWidget {
  final List<ColorVariant> colors;
  final Set<String> selected;
  final bool isDark;
  final ValueChanged<String> onTap;

  const _ColorDropdown({
    required this.colors,
    required this.selected,
    required this.isDark,
    required this.onTap,
  });

  @override
  State<_ColorDropdown> createState() => _ColorDropdownState();
}

class _ColorDropdownState extends State<_ColorDropdown> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final fill = widget.isDark
        ? AppColors.white.withValues(alpha: 0.04)
        : AppColors.primaryPurple.withValues(alpha: 0.05);
    final border = widget.isDark
        ? AppColors.white.withValues(alpha: 0.12)
        : AppColors.primaryPurple.withValues(alpha: 0.18);
    final textColor =
        widget.isDark ? AppColors.white : AppColors.primaryPurple;
    final mutedText = textColor.withValues(alpha: 0.55);

    final selectedVariants = widget.colors
        .where((c) => widget.selected.contains(c.name))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => setState(() => _expanded = !_expanded),
          behavior: HitTestBehavior.opaque,
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: fill,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: border),
            ),
            child: Row(
              children: [
                Text(
                  'Color',
                  style: AppTextStyles.caption.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: selectedVariants.isEmpty
                      ? Text(
                          'All colors',
                          style: AppTextStyles.caption.copyWith(
                            color: mutedText,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      : _SelectedColorPreview(variants: selectedVariants),
                ),
                AnimatedRotation(
                  turns: _expanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: FaIcon(
                    FontAwesomeIcons.chevronDown,
                    size: 12,
                    color: mutedText,
                  ),
                ),
              ],
            ),
          ),
        ),
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 220),
          firstChild: const SizedBox(width: double.infinity),
          secondChild: Padding(
            padding: const EdgeInsets.only(top: 14),
            child: _ColorSection(
              colors: widget.colors,
              selected: widget.selected,
              onTap: widget.onTap,
            ),
          ),
          crossFadeState: _expanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
        ),
      ],
    );
  }
}

class _SelectedColorPreview extends StatelessWidget {
  final List<ColorVariant> variants;
  const _SelectedColorPreview({required this.variants});

  static const _maxVisible = 4;

  Color _parseHex(String hex) {
    final cleaned = hex.replaceAll('#', '');
    return Color(int.parse('FF$cleaned', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final visible = variants.take(_maxVisible).toList();
    final overflow = variants.length - visible.length;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < visible.length; i++)
          Padding(
            padding: EdgeInsets.only(left: i == 0 ? 0 : 6),
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: _parseHex(visible[i].hexCode),
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
            padding: const EdgeInsets.only(left: 6),
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

class _ColorSection extends StatelessWidget {
  final List<ColorVariant> colors;
  final Set<String> selected;
  final ValueChanged<String> onTap;

  const _ColorSection({
    required this.colors,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 14,
      runSpacing: 14,
      children: [
        for (final c in colors)
          _ColorSwatch(
            variant: c,
            isSelected: selected.contains(c.name),
            onTap: () => onTap(c.name),
          ),
      ],
    );
  }
}

class _ColorSwatch extends StatefulWidget {
  final ColorVariant variant;
  final bool isSelected;
  final VoidCallback onTap;

  const _ColorSwatch({
    required this.variant,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_ColorSwatch> createState() => _ColorSwatchState();
}

class _ColorSwatchState extends State<_ColorSwatch>
    with SingleTickerProviderStateMixin {
  late final AnimationController _rotator;

  @override
  void initState() {
    super.initState();
    _rotator = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    if (widget.isSelected) _rotator.repeat();
  }

  @override
  void didUpdateWidget(covariant _ColorSwatch old) {
    super.didUpdateWidget(old);
    if (widget.isSelected && !_rotator.isAnimating) {
      _rotator.repeat();
    } else if (!widget.isSelected && _rotator.isAnimating) {
      _rotator.stop();
    }
  }

  @override
  void dispose() {
    _rotator.dispose();
    super.dispose();
  }

  Color _parseHex(String hex) {
    final cleaned = hex.replaceAll('#', '');
    return Color(int.parse('FF$cleaned', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final fill = _parseHex(widget.variant.hexCode);
    const outerDiameter = 40.0;
    const swatchDiameter = 32.0;

    return GestureDetector(
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: outerDiameter,
        height: outerDiameter,
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (widget.isSelected)
              RepaintBoundary(
                child: AnimatedBuilder(
                  animation: _rotator,
                  builder: (context, _) => SizedBox(
                    width: outerDiameter,
                    height: outerDiameter,
                    child: CustomPaint(
                      painter: _RotatingRingPainter(
                        angle: _rotator.value * 2 * math.pi,
                      ),
                    ),
                  ),
                ),
              ),
            Container(
              width: swatchDiameter,
              height: swatchDiameter,
              decoration: BoxDecoration(
                color: fill,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.white.withValues(alpha: 0.20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RotatingRingPainter extends CustomPainter {
  final double angle;
  static const double _strokeWidth = 2.5;

  _RotatingRingPainter({required this.angle});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.shortestSide / 2 - _strokeWidth / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final shader = SweepGradient(
      colors: const [
        AppColors.auroraPink,
        AppColors.auroraPurple,
        AppColors.auroraElectricBlue,
        AppColors.auroraPurple,
        AppColors.auroraPink,
      ],
      stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
      transform: GradientRotation(angle),
    ).createShader(rect);

    final paint = Paint()
      ..shader = shader
      ..style = PaintingStyle.stroke
      ..strokeWidth = _strokeWidth;
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(_RotatingRingPainter old) => old.angle != angle;
}

// ─── Size ────────────────────────────────────────────────────────────────────

class _SizeSection extends StatelessWidget {
  final List<SizeVariant> sizes;
  final Set<String> selected;
  final bool isDark;
  final ValueChanged<String> onTap;

  const _SizeSection({
    required this.sizes,
    required this.selected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final s in sizes)
          _SizeChip(
            variant: s,
            isSelected: selected.contains(s.label),
            isDark: isDark,
            onTap: () {
              if (s.isAvailable) onTap(s.label);
            },
          ),
      ],
    );
  }
}

class _SizeChip extends StatelessWidget {
  final SizeVariant variant;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  const _SizeChip({
    required this.variant,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final mutedText = isDark
        ? AppColors.white.withValues(alpha: 0.85)
        : AppColors.primaryPurple.withValues(alpha: 0.90);
    final mutedFill = isDark
        ? AppColors.white.withValues(alpha: 0.05)
        : AppColors.primaryPurple.withValues(alpha: 0.05);
    final mutedBorder = isDark
        ? AppColors.white.withValues(alpha: 0.15)
        : AppColors.primaryPurple.withValues(alpha: 0.20);

    final textColor = !variant.isAvailable
        ? mutedText.withValues(alpha: 0.35)
        : (isSelected ? AppColors.white : mutedText);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        constraints: const BoxConstraints(minWidth: 52),
        height: 40,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          gradient: isSelected && variant.isAvailable
              ? const LinearGradient(
                  colors: AppColors.auroraCartButtonGradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isSelected ? null : mutedFill,
          border: Border.all(
            color: isSelected && variant.isAvailable
                ? Colors.transparent
                : mutedBorder,
          ),
          borderRadius: BorderRadius.circular(8),
          boxShadow: isSelected && variant.isAvailable
              ? [
                  BoxShadow(
                    color: AppColors.auroraPink.withValues(alpha: 0.30),
                    blurRadius: 10,
                  ),
                ]
              : null,
        ),
        child: Text(
          variant.label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(
            color: textColor,
            fontSize: 12,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.3,
            decoration: variant.isAvailable
                ? TextDecoration.none
                : TextDecoration.lineThrough,
            decorationColor: textColor,
          ),
        ),
      ),
    );
  }
}

// ─── Rating ──────────────────────────────────────────────────────────────────

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

