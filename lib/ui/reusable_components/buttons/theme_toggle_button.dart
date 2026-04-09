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
              isDark ? FontAwesomeIcons.solidSun : FontAwesomeIcons.solidMoon,
              color: AppColors.white,
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
