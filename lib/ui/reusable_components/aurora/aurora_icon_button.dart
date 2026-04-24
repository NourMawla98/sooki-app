import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../services/theme_service.dart';
import '../../../themes/app_colors.dart';

/// Theme-aware icon button. 40×40 tap target, 20 px icon by default.
/// Light mode: auroraPurple icon. Dark mode: white icon.
/// Pass [color] to override both themes.
class AuroraIconButton extends StatelessWidget {
  final FaIconData icon;
  final VoidCallback onPressed;
  final double size;
  final double iconSize;
  final Color? color;

  const AuroraIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.size = 40,
    this.iconSize = 20,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService.instance,
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;
        final iconColor =
            color ?? (isDark ? AppColors.white : AppColors.auroraPurple);

        return SizedBox(
          width: size,
          height: size,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(size / 2),
              onTap: onPressed,
              child: Center(
                child: FaIcon(icon, size: iconSize, color: iconColor),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Back button preset — arrowLeft icon, calls [Navigator.maybePop].
class AuroraBackButton extends StatelessWidget {
  final Color? color;

  const AuroraBackButton({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return AuroraIconButton(
      icon: FontAwesomeIcons.arrowLeft,
      iconSize: 18,
      color: color,
      onPressed: () => Navigator.maybePop(context),
    );
  }
}
