import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../services/theme_service.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_text_styles.dart';
import '../../../utils/number_localization.dart';

/// Glass-style action button. Icon + label row, optional pink badge.
///
/// Used in filter/sort rows. Matches the `_GlassButton` design from
/// the Shopping screen:
/// - 42px height, 8px radius
/// - Glass fill + aurora-tinted border
/// - Icon (13px) + label (11px w800 tracking 1.0) centred
/// - Pink badge count positioned at the right edge when > 0
class AuroraGlassActionButton extends StatelessWidget {
  final FaIconData icon;
  final String label;
  final int badgeCount;
  final VoidCallback onTap;

  const AuroraGlassActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.badgeCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService.instance,
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;
        final fill = isDark
            ? AppColors.white.withValues(alpha: 0.04)
            : AppColors.auroraPurple.withValues(alpha: 0.04);
        final border = isDark
            ? AppColors.white.withValues(alpha: 0.10)
            : AppColors.auroraPurple.withValues(alpha: 0.18);
        final fg = isDark ? AppColors.white : AppColors.auroraPurple;

        return GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Container(
            height: 42,
            decoration: BoxDecoration(
              color: fill,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: border),
            ),
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FaIcon(icon, size: 13, color: fg),
                    const SizedBox(width: 8),
                    Text(
                      label,
                      style: AppTextStyles.caption.copyWith(
                        color: fg,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.0,
                        height: 1.0,
                      ),
                    ),
                  ],
                ),
                if (badgeCount > 0)
                  PositionedDirectional(
                    end: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.auroraPink,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        localizedNumber(badgeCount),
                        style: AppTextStyles.captionSmall.copyWith(
                          color: AppColors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          height: 1.0,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
