import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../enums/sort_option.dart';
import '../../../services/theme_service.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_text_styles.dart';
import '../buttons/aurora_glass_action_button.dart';

/// Full-width Filter | Sort bar used in Shopping, Category Detail, and Search
/// results screens.
///
/// Shows an optional result count below the buttons when [productCount] >= 0.
/// Pass [productCount] = -1 to hide the count row entirely.
class SortFilterBar extends StatelessWidget {
  final SortOption sortOption;
  final int filterCount;
  final int productCount;
  final VoidCallback onFilter;
  final VoidCallback onSort;
  final EdgeInsetsGeometry padding;

  const SortFilterBar({
    super.key,
    required this.sortOption,
    required this.onFilter,
    required this.onSort,
    this.filterCount = 0,
    this.productCount = -1,
    this.padding = const EdgeInsets.fromLTRB(16, 10, 16, 0),
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService.instance,
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;
        final mutedText = isDark
            ? AppColors.white.withValues(alpha: 0.30)
            : AppColors.auroraPurple.withValues(alpha: 0.40);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: padding,
              child: Row(
                children: [
                  Expanded(
                    child: AuroraGlassActionButton(
                      icon: FontAwesomeIcons.sliders,
                      label: 'FILTER',
                      badgeCount: filterCount,
                      onTap: onFilter,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: AuroraGlassActionButton(
                      icon: sortOption.icon,
                      label: 'SORT · ${sortOption.buttonLabel}',
                      onTap: onSort,
                    ),
                  ),
                ],
              ),
            ),
            if (productCount >= 0)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 9, 16, 0),
                child: Text(
                  '$productCount items',
                  style: AppTextStyles.captionSmall.copyWith(
                    color: mutedText,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
