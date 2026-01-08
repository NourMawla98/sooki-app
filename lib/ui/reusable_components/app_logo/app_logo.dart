import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../themes/themes.dart';

class AppLogo extends StatelessWidget {
  final LogoSize size;
  final bool isWhiteText;

  const AppLogo({super.key, required this.size, this.isWhiteText = false});

  @override
  Widget build(BuildContext context) {
    final config = _getLogoConfig(size);

    final textStyle = isWhiteText
        ? (size == LogoSize.large
              ? AppTextStyles.logoWhiteLarge
              : size == LogoSize.medium
              ? AppTextStyles.logoWhiteMedium
              : AppTextStyles.logoWhiteMedium)
        : (size == LogoSize.large
              ? AppTextStyles.logoLarge
              : size == LogoSize.medium
              ? AppTextStyles.logoMedium
              : AppTextStyles.logoSmall);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('S', style: textStyle),
        _AnimatedIconCircle(
          icon: FontAwesomeIcons.bagShopping,
          backgroundColor: AppColors.logoShoppingBag,
          iconSize: config.iconSize,
          circleSize: config.circleSize,
          containerWidth: config.containerWidth,
          containerHeight: config.containerHeight,
          animationDistance: config.animationDistance,
          animationType: _AnimationType.upDown,
        ),

        _AnimatedIconCircle(
          icon: FontAwesomeIcons.truck,
          backgroundColor: AppColors.logoDeliveryTruck,
          iconSize: config.iconSize,
          circleSize: config.circleSize,
          containerWidth: config.containerWidth,
          containerHeight: config.containerHeight,
          animationDistance: config.animationDistance,
          animationType: _AnimationType.downUp,
        ),

        Text('K', style: textStyle),

        Text('I', style: textStyle),
      ],
    );
  }

  _LogoConfig _getLogoConfig(LogoSize size) {
    switch (size) {
      case LogoSize.large:
        return const _LogoConfig(
          iconSize: 18,
          circleSize: 32,
          containerWidth: 35,
          containerHeight: 56,
          animationDistance: 20,
        );
      case LogoSize.medium:
        return const _LogoConfig(
          iconSize: 12,
          circleSize: 22,
          containerWidth: 25,
          containerHeight: 36,
          animationDistance: 10,
        );
      case LogoSize.small:
        return const _LogoConfig(
          iconSize: 9,
          circleSize: 18,
          containerWidth: 21,
          containerHeight: 29,
          animationDistance: 10,
        );
    }
  }
}

class _AnimatedIconCircle extends StatefulWidget {
  final IconData icon;
  final Color backgroundColor;
  final double iconSize;
  final double circleSize;
  final double containerWidth;
  final double containerHeight;
  final double animationDistance;
  final _AnimationType animationType;

  const _AnimatedIconCircle({
    required this.icon,
    required this.backgroundColor,
    required this.iconSize,
    required this.circleSize,
    required this.containerWidth,
    required this.containerHeight,
    required this.animationDistance,
    required this.animationType,
  });

  @override
  State<_AnimatedIconCircle> createState() => _AnimatedIconCircleState();
}

class _AnimatedIconCircleState extends State<_AnimatedIconCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..repeat(reverse: true);

    if (widget.animationType == _AnimationType.upDown) {
      _animation = Tween<double>(
        begin: 0,
        end: -widget.animationDistance,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    } else {
      _animation = Tween<double>(
        begin: -widget.animationDistance,
        end: 0,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.containerWidth,
      height: widget.containerHeight,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _animation.value),
              child: child,
            );
          },
          child: Container(
            width: widget.circleSize,
            height: widget.circleSize,
            decoration: BoxDecoration(
              color: widget.backgroundColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadowMedium,
                  blurRadius: 8,
                  spreadRadius: 0,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: FaIcon(
                widget.icon,
                size: widget.iconSize,
                color: AppColors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum LogoSize {
  large, // Splash screen (64px font)
  medium, // Signup screen (40px font)
  small, // App header (32px font)
}

enum _AnimationType { upDown, downUp }

class _LogoConfig {
  final double iconSize;
  final double circleSize;
  final double containerWidth;
  final double containerHeight;
  final double animationDistance;

  const _LogoConfig({
    required this.iconSize,
    required this.circleSize,
    required this.containerWidth,
    required this.containerHeight,
    required this.animationDistance,
  });
}
