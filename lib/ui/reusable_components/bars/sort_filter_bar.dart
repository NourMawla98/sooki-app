import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../enums/sort_option.dart';
import '../../../services/theme_service.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_text_styles.dart';
import '../../../utils/number_localization.dart';
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

  /// Hide the sort button. Search results come back relevance-ordered and the
  /// backend ignores SortBy while a search term is set, so sorting is not
  /// offered there.
  final bool showSort;

  const SortFilterBar({
    super.key,
    required this.sortOption,
    required this.onFilter,
    required this.onSort,
    this.filterCount = 0,
    this.productCount = -1,
    this.showSort = true,
    this.padding = const EdgeInsetsDirectional.fromSTEB(16, 10, 16, 0),
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
                      label: 'sort_filter_bar.filter'.tr(),
                      badgeCount: filterCount,
                      onTap: onFilter,
                    ),
                  ),
                  if (showSort) ...[
                    const SizedBox(width: 10),
                    Expanded(
                      child: AuroraGlassActionButton(
                        icon: sortOption.icon,
                        label: 'sort_filter_bar.sort'.tr(
                          namedArgs: {'label': sortOption.buttonLabel},
                        ),
                        onTap: onSort,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (productCount >= 0)
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 9, 16, 0),
                child: Text(
                  'sort_filter_bar.item_count'.tr(
                    namedArgs: {'count': localizedNumber(productCount)},
                  ),
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
