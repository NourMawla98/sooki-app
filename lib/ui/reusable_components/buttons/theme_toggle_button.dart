import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../services/theme_service.dart';
import '../../../themes/themes.dart';

class ThemeToggleButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const ThemeToggleButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService.instance,
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;
        final iconColor = isDark
            ? const Color(0xFFFBBF24) // sun icon is yellow
            : AppColors.white;        // moon icon is white
        final bg = isDark
            ? AppColors.white.withValues(alpha: 0.12)
            : AppColors.auroraPurple.withValues(alpha: 0.72);
        final borderColor = isDark
            ? AppColors.white.withValues(alpha: 0.18)
            : AppColors.auroraPurple;
        return Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: bg,
            shape: BoxShape.circle,
            border: Border.all(color: borderColor, width: 1.5),
          ),
          child: IconButton(
            icon: FaIcon(
              isDark ? FontAwesomeIcons.solidSun : FontAwesomeIcons.solidMoon,
              color: iconColor,
              size: 15,
            ),
            onPressed: onPressed ?? () => ThemeService.instance.toggle(),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        );
      },
    );
  }
}
