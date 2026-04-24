import 'package:flutter/material.dart';

import '../../../services/theme_service.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_text_styles.dart';

/// Multi-select chip — 32 px tall, 10 px radius, 12 px horizontal padding.
///
/// • Selected   — aurora gradient fill, white text
/// • Unselected — glass fill, aurora border, muted text
class AuroraSelectableChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const AuroraSelectableChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService.instance,
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;
        final unselectedFill = isDark
            ? AppColors.white.withValues(alpha: 0.05)
            : AppColors.auroraPurple.withValues(alpha: 0.04);
        final borderColor = isDark
            ? AppColors.white.withValues(alpha: 0.20)
            : AppColors.auroraPurple.withValues(alpha: 0.30);
        final textColor =
            isDark ? AppColors.mutedOnDark : AppColors.mutedOnLight;

        return GestureDetector(
          onTap: onTap,
          child: SizedBox(
            height: 32,
            child: isSelected
                ? DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: AppColors.auroraGradient,
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Center(
                        child: Text(
                          label,
                          style: AppTextStyles.captionSmall.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  )
                : DecoratedBox(
                    decoration: BoxDecoration(
                      color: unselectedFill,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: borderColor),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Center(
                        child: Text(
                          label,
                          style: AppTextStyles.captionSmall.copyWith(
                            color: textColor,
                            fontWeight: FontWeight.w600,
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
