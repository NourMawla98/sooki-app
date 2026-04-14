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
        final fg =
            isDark ? AppColors.white : AppColors.primaryPurple;
        final bg = isDark
            ? AppColors.white.withValues(alpha: 0.2)
            : AppColors.primaryPurple.withValues(alpha: 0.08);
        final borderColor = isDark
            ? AppColors.white.withValues(alpha: 0.3)
            : AppColors.primaryPurple.withValues(alpha: 0.25);
        return Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: bg,
            shape: BoxShape.circle,
            border: Border.all(color: borderColor, width: 1),
          ),
          child: IconButton(
            icon: FaIcon(
              isDark ? FontAwesomeIcons.solidSun : FontAwesomeIcons.solidMoon,
              color: fg,
              size: 18,
            ),
            onPressed: onPressed ?? () => ThemeService.instance.toggle(),
            padding: EdgeInsets.zero,
          ),
        );
      },
    );
  }
}
