import 'package:flutter/material.dart';

import '../../../themes/themes.dart';

class ThemeToggleButton extends StatefulWidget {
  final VoidCallback? onPressed;

  const ThemeToggleButton({
    super.key,
    this.onPressed,
  });

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
        color: AppColors.white.withOpacity(0.2),
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: IconButton(
        icon: Icon(
          _isDarkMode ? Icons.light_mode : Icons.dark_mode,
          color: AppColors.white,
          size: 20,
        ),
        onPressed: widget.onPressed ??
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
