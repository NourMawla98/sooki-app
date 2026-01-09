import 'package:flutter/material.dart';

class FloatingEmoji extends StatefulWidget {
  final String emoji;
  final double size;
  final double opacity;
  final double top;
  final double? bottom;
  final double? left;
  final double? right;
  final double floatDistance;
  final double rotationAngle;
  final int durationMs;

  const FloatingEmoji({
    super.key,
    required this.emoji,
    this.size = 36,
    this.opacity = 0.2,
    this.top = 0,
    this.bottom,
    this.left,
    this.right,
    this.floatDistance = 15,
    this.rotationAngle = 10,
    this.durationMs = 2000,
  });

  @override
  State<FloatingEmoji> createState() => _FloatingEmojiState();
}

class _FloatingEmojiState extends State<FloatingEmoji>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _floatAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(milliseconds: widget.durationMs),
      vsync: this,
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(
      begin: -widget.floatDistance,
      end: widget.floatDistance,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _rotateAnimation = Tween<double>(
      begin: -widget.rotationAngle,
      end: widget.rotationAngle,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: widget.bottom == null ? widget.top : null,
      bottom: widget.bottom,
      left: widget.left,
      right: widget.right,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _floatAnimation.value),
            child: Transform.rotate(
              angle: _rotateAnimation.value * 3.14159 / 180, // Convert to radians
              child: child,
            ),
          );
        },
        child: Opacity(
          opacity: widget.opacity,
          child: Text(
            widget.emoji,
            style: TextStyle(
              fontSize: widget.size,
              height: 1.0,
            ),
          ),
        ),
      ),
    );
  }
}
