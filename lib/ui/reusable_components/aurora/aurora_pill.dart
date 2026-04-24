import 'package:flutter/material.dart';

import '../../../services/theme_service.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_text_styles.dart';

/// Aurora pill — 40 px tall, 22 px radius, 18 px horizontal padding.
///
/// • Active   — aurora gradient fill, white text
/// • Inactive — transparent fill, muted aurora border, muted text
/// • Disabled — same as inactive at 45 % opacity, non-tappable
class AuroraPill extends StatelessWidget {
  final String label;
  final bool isActive;
  final bool isDisabled;
  final VoidCallback? onTap;

  const AuroraPill({
    super.key,
    required this.label,
    required this.onTap,
    this.isActive = false,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService.instance,
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;
        final borderColor = isDark
            ? AppColors.white.withValues(alpha: 0.25)
            : AppColors.auroraPurple.withValues(alpha: 0.30);
        final textColor =
            isDark ? AppColors.mutedOnDark : AppColors.mutedOnLight;

        Widget pill = SizedBox(
          height: 40,
          child: isActive
              ? DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: AppColors.auroraGradient,
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(22),
                      onTap: isDisabled ? null : onTap,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: Center(
                          child: Text(
                            label,
                            style: AppTextStyles.dsCTA,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: borderColor),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(22),
                      onTap: isDisabled ? null : onTap,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: Center(
                          child: Text(
                            label,
                            style: AppTextStyles.dsCTA.copyWith(
                              color: textColor,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
        );

        if (isDisabled) {
          pill = Opacity(opacity: 0.45, child: pill);
        }

        return pill;
      },
    );
  }
}
