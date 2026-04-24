import 'package:flutter/material.dart';

import '../../../services/theme_service.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_text_styles.dart';

/// Glass container housing 2–4 segments; active segment gets the aurora
/// gradient fill. Inactive segments are transparent with muted text.
class AuroraSegmentedControl extends StatelessWidget {
  final List<String> options;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const AuroraSegmentedControl({
    super.key,
    required this.options,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService.instance,
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;
        final glassFill = isDark
            ? AppColors.white.withValues(alpha: 0.06)
            : AppColors.auroraPurple.withValues(alpha: 0.05);
        final glassBorder = isDark
            ? AppColors.white.withValues(alpha: 0.10)
            : AppColors.auroraPurple.withValues(alpha: 0.18);
        final mutedColor =
            isDark ? AppColors.mutedOnDark : AppColors.mutedOnLight;

        return Container(
          height: 44,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: glassFill,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: glassBorder),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(options.length, (i) {
              final isSelected = i == selectedIndex;
              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onChanged(i),
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
                          child: Center(
                            child: Text(
                              options[i],
                              style: AppTextStyles.dsCTA,
                            ),
                          ),
                        )
                      : Center(
                          child: Text(
                            options[i],
                            style: AppTextStyles.dsCTA.copyWith(
                              color: mutedColor,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}
