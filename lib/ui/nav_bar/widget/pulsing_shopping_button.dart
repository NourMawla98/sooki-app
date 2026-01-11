import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../themes/themes.dart';

class PulsingShoppingButton extends StatefulWidget {
  final bool isSelected;
  final VoidCallback onTap;

  const PulsingShoppingButton({
    super.key,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<PulsingShoppingButton> createState() => _PulsingShoppingButtonState();
}

class _PulsingShoppingButtonState extends State<PulsingShoppingButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1300),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _glowAnimation = Tween<double>(
      begin: 0.3,
      end: 0.7,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
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
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color:
                      (widget.isSelected
                              ? AppColors.accentRed
                              : AppColors.primaryPurple)
                          .withValues(alpha: _glowAnimation.value),
                  blurRadius: 16,
                  spreadRadius: 3,
                ),
                BoxShadow(
                  color: AppColors.shadowDark,
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.isSelected
                      ? AppColors.accentRed
                      : AppColors.primaryPurple,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: widget.onTap,
                    borderRadius: BorderRadius.circular(26),
                    child: const Center(
                      child: FaIcon(
                        FontAwesomeIcons.bagShopping,
                        size: 27,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
