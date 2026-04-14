import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Positioned wrapper that vertically floats and slightly rotates its child
/// on a repeating reverse loop. Used for aurora background decoration
/// (floating price tags, discount badges, etc.).
///
/// Exactly one of [top] / [bottom] should be supplied, and one of
/// [left] / [right] — matches [Positioned] semantics.
class FloatingDecor extends StatefulWidget {
  final Widget child;
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;

  /// Vertical travel distance in logical pixels (half above, half below rest).
  final double floatDistance;

  /// Rotation sweep in degrees (applied symmetrically around 0°).
  final double rotationAngle;

  /// One full back-and-forth cycle duration in milliseconds.
  final int durationMs;

  /// Opacity multiplier applied to the child (use to soften background decor).
  final double opacity;

  const FloatingDecor({
    super.key,
    required this.child,
    this.top,
    this.bottom,
    this.left,
    this.right,
    this.floatDistance = 12,
    this.rotationAngle = 6,
    this.durationMs = 2800,
    this.opacity = 1.0,
  });

  @override
  State<FloatingDecor> createState() => _FloatingDecorState();
}

class _FloatingDecorState extends State<FloatingDecor>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _float;
  late final Animation<double> _rotate;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: widget.durationMs),
      vsync: this,
    )..repeat(reverse: true);

    _float = Tween<double>(
      begin: -widget.floatDistance,
      end: widget.floatDistance,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _rotate = Tween<double>(
      begin: -widget.rotationAngle,
      end: widget.rotationAngle,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: widget.top,
      bottom: widget.bottom,
      left: widget.left,
      right: widget.right,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _float.value),
            child: Transform.rotate(
              angle: _rotate.value * math.pi / 180,
              child: child,
            ),
          );
        },
        child: Opacity(opacity: widget.opacity, child: widget.child),
      ),
    );
  }
}
