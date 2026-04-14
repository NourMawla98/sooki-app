import 'package:flutter/material.dart';

/// Large radial-gradient blob used as a corner accent behind the splash
/// content. Renders inside a [Positioned] so it must sit in a [Stack].
class AuroraGlowBlob extends StatelessWidget {
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;
  final double size;
  final Color color;

  /// Peak inner-opacity of the radial gradient (0.0 – 1.0).
  final double intensity;

  const AuroraGlowBlob({
    super.key,
    this.top,
    this.bottom,
    this.left,
    this.right,
    this.size = 320,
    required this.color,
    this.intensity = 0.35,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: IgnorePointer(
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                color.withValues(alpha: intensity),
                color.withValues(alpha: intensity * 0.4),
                Colors.transparent,
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        ),
      ),
    );
  }
}
