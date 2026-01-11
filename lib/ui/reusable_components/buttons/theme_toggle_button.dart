import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../themes/themes.dart';

class ThemeToggleButton extends StatefulWidget {
  final VoidCallback? onPressed;

  const ThemeToggleButton({super.key, this.onPressed});

  @override
  State<ThemeToggleButton> createState() => _ThemeToggleButtonState();
}

class _ThemeToggleButtonState extends State<ThemeToggleButton> {
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.2),
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.white.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: IconButton(
        icon: FaIcon(
          _isDarkMode ? FontAwesomeIcons.solidSun : FontAwesomeIcons.solidMoon,
          color: AppColors.white,
          size: 18,
        ),
        onPressed:
            widget.onPressed ??
            () {
              setState(() {
                _isDarkMode = !_isDarkMode;
              });
              // TODO: Implement theme switching
            },
        padding: EdgeInsets.zero,
      ),
    );
  }
}
