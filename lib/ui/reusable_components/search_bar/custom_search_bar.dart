import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../services/theme_service.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_text_styles.dart';

/// Theme-aware aurora search bar used in the app header.
class CustomSearchBar extends StatelessWidget {
  final VoidCallback? onTap;

  const CustomSearchBar({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService.instance,
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;
        final fill = isDark
            ? AppColors.white.withValues(alpha: 0.04)
            : AppColors.gray100;
        final border = isDark
            ? AppColors.white.withValues(alpha: 0.08)
            : AppColors.gray200;
        final placeholder = isDark
            ? AppColors.white.withValues(alpha: 0.45)
            : AppColors.gray400;

        return GestureDetector(
          onTap: onTap,
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: fill,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: border, width: 1),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                FaIcon(
                  FontAwesomeIcons.magnifyingGlass,
                  size: 16,
                  color: placeholder,
                ),
                const SizedBox(width: 12),
                Text(
                  'Search for products...',
                  style: AppTextStyles.inputHint.copyWith(
                    color: placeholder,
                    fontSize: 15,
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
