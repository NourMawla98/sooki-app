import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../models/product.dart';
import '../../../../services/theme_service.dart';
import '../../../../themes/themes.dart';

class SizeSelector extends StatelessWidget {
  const SizeSelector({
    super.key,
    required this.sizes,
    required this.selected,
    required this.onSelected,
    required this.onSizeGuide,
  });

  final List<SizeVariant> sizes;
  final SizeVariant? selected;
  final ValueChanged<SizeVariant> onSelected;
  final VoidCallback onSizeGuide;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService.instance,
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;
        final mutedLabel =
            (isDark ? AppColors.white : AppColors.primaryPurple)
                .withValues(alpha: 0.65);
        final strongLabel =
            isDark ? AppColors.white : AppColors.primaryPurple;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      'SIZE',
                      style: AppFonts.primary(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: mutedLabel,
                        letterSpacing: 1.4,
                        height: 1.1,
                      ),
                    ),
                    if (selected != null) ...[
                      const SizedBox(width: 6),
                      Text(
                        '·',
                        style: AppFonts.primary(
                          fontSize: 11,
                          color: mutedLabel,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        selected!.label,
                        style: AppFonts.primary(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: strongLabel,
                          height: 1.1,
                        ),
                      ),
                    ],
                  ],
                ),
                GestureDetector(
                  onTap: onSizeGuide,
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.auroraElectricBlue
                          .withValues(alpha: 0.10),
                      border: Border.all(
                        color: AppColors.auroraElectricBlue
                            .withValues(alpha: 0.45),
                      ),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'SIZE GUIDE',
                          style: AppFonts.primary(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: AppColors.auroraElectricBlue,
                            letterSpacing: 0.8,
                            height: 1.0,
                          ),
                        ),
                        const SizedBox(width: 5),
                        const FaIcon(
                          FontAwesomeIcons.chevronRight,
                          size: 9,
                          color: AppColors.auroraElectricBlue,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: sizes.map((size) {
                final isSelected = selected == size;
                return _SizeChip(
                  label: size.label,
                  isSelected: isSelected,
                  isAvailable: size.isAvailable,
                  isDark: isDark,
                  onTap: size.isAvailable ? () => onSelected(size) : null,
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}

class _SizeChip extends StatefulWidget {
  const _SizeChip({
    required this.label,
    required this.isSelected,
    required this.isAvailable,
    required this.isDark,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final bool isAvailable;
  final bool isDark;
  final VoidCallback? onTap;

  @override
  State<_SizeChip> createState() => _SizeChipState();
}

class _SizeChipState extends State<_SizeChip>
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
  void didUpdateWidget(covariant _SizeChip old) {
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

  @override
  Widget build(BuildContext context) {
    final cellBg = widget.isDark
        ? AppColors.white.withValues(alpha: 0.04)
        : AppColors.primaryPurple.withValues(alpha: 0.06);
    final cellBorder = widget.isDark
        ? AppColors.white.withValues(alpha: 0.15)
        : AppColors.primaryPurple.withValues(alpha: 0.35);
    final textColor =
        widget.isDark ? AppColors.white : AppColors.primaryPurple;
    final unselectedText = widget.isDark
        ? AppColors.white.withValues(alpha: 0.65)
        : AppColors.primaryPurple;

    final content = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Text(
        widget.label,
        textAlign: TextAlign.center,
        style: AppFonts.primary(
          fontSize: 12,
          fontWeight:
              widget.isSelected ? FontWeight.w800 : FontWeight.w700,
          color: widget.isSelected ? textColor : unselectedText,
          decoration: !widget.isAvailable
              ? TextDecoration.lineThrough
              : TextDecoration.none,
          decorationColor: textColor,
          letterSpacing: 0.3,
          height: 1.1,
        ),
      ),
    );

    Widget chip = Stack(
      children: [
        if (!widget.isSelected)
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: cellBg,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
        Positioned.fill(
          child: widget.isSelected
              ? RepaintBoundary(
                  child: AnimatedBuilder(
                    animation: _rotator,
                    builder: (context, _) => CustomPaint(
                      painter: _RotatingRoundedBorderPainter(
                        angle: _rotator.value * 2 * math.pi,
                      ),
                    ),
                  ),
                )
              : CustomPaint(
                  painter: _StaticRoundedBorderPainter(color: cellBorder),
                ),
        ),
        content,
      ],
    );

    if (!widget.isAvailable) {
      chip = Opacity(opacity: 0.35, child: chip);
    }

    return GestureDetector(
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: chip,
    );
  }
}

const double _chipBorderRadius = 6;
const double _chipStrokeWidth = 2;

class _RotatingRoundedBorderPainter extends CustomPainter {
  final double angle;

  _RotatingRoundedBorderPainter({required this.angle});

  @override
  void paint(Canvas canvas, Size size) {
    const inset = _chipStrokeWidth / 2;
    final rect = Rect.fromLTWH(
      inset,
      inset,
      size.width - inset * 2,
      size.height - inset * 2,
    );
    final rrect = RRect.fromRectAndRadius(
      rect,
      const Radius.circular(_chipBorderRadius),
    );

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
      ..strokeWidth = _chipStrokeWidth;

    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(_RotatingRoundedBorderPainter old) => old.angle != angle;
}

class _StaticRoundedBorderPainter extends CustomPainter {
  final Color color;

  _StaticRoundedBorderPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    const inset = _chipStrokeWidth / 2;
    final rect = Rect.fromLTWH(
      inset,
      inset,
      size.width - inset * 2,
      size.height - inset * 2,
    );
    final rrect = RRect.fromRectAndRadius(
      rect,
      const Radius.circular(_chipBorderRadius),
    );

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = _chipStrokeWidth;

    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(_StaticRoundedBorderPainter old) => old.color != color;
}
