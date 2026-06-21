import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../backend_integration/dtos/item/item_detail_dto.dart';
import '../../../services/theme_service.dart';
import '../../../themes/app_colors.dart';
import 'color_swatch_type.dart';

/// Circular color swatch for [ItemDetailColorDto].
/// - **Unselected:** 2px neutral border
/// - **Selected:** 2px aurora-gradient border that continuously sweeps around
///   the perimeter (rotating [SweepGradient]).
class ColorSwatchWidget extends StatefulWidget {
  const ColorSwatchWidget({
    super.key,
    required this.color,
    this.selected = false,
    this.isAvailable = true,
    this.size = 32.0,
    this.onTap,
  });

  final ItemDetailColorDto color;
  final bool selected;
  final bool isAvailable;
  final double size;
  final VoidCallback? onTap;

  @override
  State<ColorSwatchWidget> createState() => _ColorSwatchWidgetState();
}

class _ColorSwatchWidgetState extends State<ColorSwatchWidget>
    with SingleTickerProviderStateMixin {
  static const double _strokeWidth = 2;

  late final AnimationController _rotator;

  @override
  void initState() {
    super.initState();
    _rotator = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    if (widget.selected) _rotator.repeat();
  }

  @override
  void didUpdateWidget(covariant ColorSwatchWidget old) {
    super.didUpdateWidget(old);
    if (widget.selected && !_rotator.isAnimating) {
      _rotator.repeat();
    } else if (!widget.selected && _rotator.isAnimating) {
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
    return ListenableBuilder(
      listenable: ThemeService.instance,
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;
        final defaultBorder = isDark
            ? AppColors.white.withValues(alpha: 0.22)
            : AppColors.primaryPurple.withValues(alpha: 0.30);

        final fillDiameter = widget.size - _strokeWidth * 2;
        final fillDisc = SizedBox(
          width: fillDiameter,
          height: fillDiameter,
          child: ClipOval(child: _SwatchFill(color: widget.color)),
        );

        Widget swatch = SizedBox(
          width: widget.size,
          height: widget.size,
          child: widget.selected
              ? RepaintBoundary(
                  child: AnimatedBuilder(
                    animation: _rotator,
                    builder: (context, child) => CustomPaint(
                      painter: _RotatingCircleBorderPainter(
                        angle: _rotator.value * 2 * math.pi,
                      ),
                      child: child,
                    ),
                    child: Center(child: fillDisc),
                  ),
                )
              : Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: defaultBorder,
                      width: _strokeWidth,
                    ),
                  ),
                  child: Center(child: fillDisc),
                ),
        );

        if (!widget.isAvailable) {
          swatch = Stack(
            alignment: Alignment.center,
            children: [
              Opacity(opacity: 0.35, child: swatch),
              SizedBox(
                width: widget.size,
                height: widget.size,
                child: CustomPaint(painter: _StrikethroughPainter()),
              ),
            ],
          );
        }

        return GestureDetector(
          onTap: (widget.isAvailable && widget.onTap != null) ? widget.onTap : null,
          behavior: HitTestBehavior.opaque,
          child: swatch,
        );
      },
    );
  }
}

class _SwatchFill extends StatelessWidget {
  const _SwatchFill({required this.color});
  final ItemDetailColorDto color;

  @override
  Widget build(BuildContext context) {
    switch (inferSwatchType(color)) {
      case ColorSwatchType.pattern:
        return Image.network(
          color.patternImageUrl!,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) =>
              Container(color: _hexToColor(color.color1.hexCode)),
        );
      case ColorSwatchType.solid:
        return Container(color: _hexToColor(color.color1.hexCode));
      case ColorSwatchType.twoColor:
        return DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: const [0.0, 0.5, 0.5, 1.0],
              colors: [
                _hexToColor(color.color1.hexCode),
                _hexToColor(color.color1.hexCode),
                _hexToColor(color.color2!.hexCode),
                _hexToColor(color.color2!.hexCode),
              ],
            ),
          ),
        );
      case ColorSwatchType.threeColor:
        return CustomPaint(
          painter: _ConicPainter(
            colors: [
              _hexToColor(color.color1.hexCode),
              _hexToColor(color.color2!.hexCode),
              _hexToColor(color.color3!.hexCode),
            ],
            hardEdges: true,
          ),
        );
      case ColorSwatchType.multicolor:
        return CustomPaint(
          painter: _ConicPainter(
            colors: const <Color>[
              Color(0xFFFF0000),
              Color(0xFFFFA500),
              Color(0xFFFFFF00),
              Color(0xFF00C853),
              Color(0xFF0096FF),
              Color(0xFF7C3AED),
              Color(0xFFFF00C8),
            ],
            hardEdges: false,
          ),
        );
    }
  }
}

Color _hexToColor(String hex) {
  final cleaned = hex.replaceFirst('#', '');
  return Color(int.parse('0xFF$cleaned'));
}

class _RotatingCircleBorderPainter extends CustomPainter {
  final double angle;
  static const double _strokeWidth = 2;

  _RotatingCircleBorderPainter({required this.angle});

  @override
  void paint(Canvas canvas, Size size) {
    const inset = _strokeWidth / 2;
    final rect = Rect.fromLTWH(
      inset,
      inset,
      size.width - inset * 2,
      size.height - inset * 2,
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
      ..strokeWidth = _strokeWidth;

    canvas.drawCircle(
      rect.center,
      size.shortestSide / 2 - inset,
      paint,
    );
  }

  @override
  bool shouldRepaint(_RotatingCircleBorderPainter old) => old.angle != angle;
}

class _ConicPainter extends CustomPainter {
  _ConicPainter({required this.colors, required this.hardEdges});
  final List<Color> colors;
  final bool hardEdges;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final List<Color> gradientColors;
    final List<double> stops;

    if (hardEdges) {
      gradientColors = <Color>[];
      stops = <double>[];
      final n = colors.length;
      for (var i = 0; i < n; i++) {
        final start = i / n;
        final end = (i + 1) / n;
        gradientColors.add(colors[i]);
        stops.add(start);
        gradientColors.add(colors[i]);
        stops.add(end);
      }
    } else {
      gradientColors = colors;
      final n = colors.length;
      stops = List.generate(n, (i) => i / (n - 1));
    }

    final paint = Paint()
      ..shader = SweepGradient(
        colors: gradientColors,
        stops: stops,
      ).createShader(rect);

    canvas.drawCircle(rect.center, size.shortestSide / 2, paint);
  }

  @override
  bool shouldRepaint(covariant _ConicPainter old) =>
      old.colors != colors || old.hardEdges != hardEdges;
}

class _StrikethroughPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.white.withValues(alpha: 0.75)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(size.width * 0.2, size.height * 0.8),
      Offset(size.width * 0.8, size.height * 0.2),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
