import 'package:flutter/material.dart';

import '../../../../themes/themes.dart';

class RainbowBar extends StatefulWidget {
  const RainbowBar({super.key});

  @override
  State<RainbowBar> createState() => _RainbowBarState();
}

class _RainbowBarState extends State<RainbowBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // Create a seamless looping gradient by using tileMode
        return Container(
          height: 4,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            gradient: LinearGradient(
              colors: [
                ...AppColors.rainbowGradient,
                ...AppColors.rainbowGradient,
              ],
              stops: const [0.0, 0.14, 0.28, 0.42, 0.58, 0.72, 0.86, 1.0],
              begin: Alignment(-1 + _controller.value * 2, 0),
              end: Alignment(1 + _controller.value * 2, 0),
              tileMode: TileMode.repeated,
            ),
          ),
        );
      },
    );
  }
}
