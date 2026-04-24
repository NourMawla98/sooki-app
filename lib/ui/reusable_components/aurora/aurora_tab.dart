import 'package:flutter/material.dart';

import '../../../services/theme_service.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_text_styles.dart';

/// Single tab with a 2.5 px aurora gradient underline when selected.
/// Compose a row of these inside a [Row] or custom tab bar widget.
class AuroraTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const AuroraTab({
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
        final activeColor = isDark ? AppColors.white : AppColors.auroraPurple;
        final mutedColor =
            isDark ? AppColors.mutedOnDark : AppColors.mutedOnLight;

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  label,
                  style: AppTextStyles.dsBodyBold.copyWith(
                    color: isSelected ? activeColor : mutedColor,
                    fontWeight:
                        isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
              if (isSelected)
                Container(
                  height: 2.5,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: AppColors.auroraGradient,
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                )
              else
                const SizedBox(height: 2.5),
            ],
          ),
        );
      },
    );
  }
}
