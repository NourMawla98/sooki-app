import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../services/theme_service.dart';
import '../../../../themes/app_colors.dart';
import '../../../../themes/app_text_styles.dart';

/// Aurora-styled select field. Looks like an [AuroraInputField]; taps to open
/// a bottom sheet list of options. `value` renders in the brand text color;
/// `hint` renders muted when value is null.
class AuroraSelect extends StatelessWidget {
  final String? value;
  final String hint;
  final List<String> options;
  final ValueChanged<String> onChanged;
  final FaIconData? prefixIcon;
  final bool enabled;
  final String sheetTitle;

  const AuroraSelect({
    super.key,
    required this.value,
    required this.hint,
    required this.options,
    required this.onChanged,
    required this.sheetTitle,
    this.prefixIcon,
    this.enabled = true,
  });

  Future<void> _open(BuildContext context, bool isDark) async {
    if (!enabled || options.isEmpty) return;
    final picked = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _OptionsSheet(
        title: sheetTitle,
        options: options,
        selected: value,
        isDark: isDark,
      ),
    );
    if (picked != null) onChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService.instance,
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;
        final hasValue = value != null && value!.isNotEmpty;

        final fill = isDark
            ? AppColors.white.withValues(alpha: 0.04)
            : AppColors.white;
        final border = isDark
            ? AppColors.white.withValues(alpha: 0.12)
            : AppColors.auroraPurple.withValues(alpha: 0.28);
        final iconColor = isDark ? AppColors.white : AppColors.auroraPurple;
        final textColor = isDark ? AppColors.white : AppColors.auroraDeepBase;
        final hintColor = isDark ? AppColors.mutedOnDark : AppColors.mutedOnLight;
        final chevronColor = isDark
            ? AppColors.white.withValues(alpha: 0.35)
            : AppColors.auroraDeepBase.withValues(alpha: 0.45);

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => _open(context, isDark),
          child: Opacity(
            opacity: enabled ? 1.0 : 0.5,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
              decoration: BoxDecoration(
                color: fill,
                border: Border.all(color: border, width: 1.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  if (prefixIcon != null) ...[
                    FaIcon(prefixIcon!, size: 16, color: iconColor),
                    const SizedBox(width: 10),
                  ],
                  Expanded(
                    child: Text(
                      hasValue ? value! : hint,
                      style: AppTextStyles.dsBody.copyWith(
                        fontSize: 14,
                        fontWeight:
                            hasValue ? FontWeight.w600 : FontWeight.normal,
                        color: hasValue ? textColor : hintColor,
                        height: 1.0,
                      ),
                    ),
                  ),
                  FaIcon(
                    FontAwesomeIcons.chevronDown,
                    size: 12,
                    color: chevronColor,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _OptionsSheet extends StatelessWidget {
  final String title;
  final List<String> options;
  final String? selected;
  final bool isDark;

  const _OptionsSheet({
    required this.title,
    required this.options,
    required this.selected,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final sheetBg = isDark
        ? AppColors.auroraDeepBase.withValues(alpha: 0.96)
        : AppColors.white.withValues(alpha: 0.96);
    final topBorder = isDark
        ? AppColors.white.withValues(alpha: 0.06)
        : AppColors.auroraPurple.withValues(alpha: 0.12);
    final handleColor = isDark
        ? AppColors.white.withValues(alpha: 0.22)
        : AppColors.auroraDeepBase.withValues(alpha: 0.30);
    final dividerColor = isDark
        ? AppColors.white.withValues(alpha: 0.06)
        : AppColors.auroraDeepBase.withValues(alpha: 0.08);
    final textColor = isDark ? AppColors.white : AppColors.auroraDeepBase;

    return DraggableScrollableSheet(
      initialChildSize: 0.55,
      minChildSize: 0.35,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) => Container(
        decoration: BoxDecoration(
          color: sheetBg,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
          border: Border(top: BorderSide(color: topBorder, width: 1)),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: handleColor,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    title,
                    style: AppTextStyles.dsFieldLabel.copyWith(
                      color: isDark ? AppColors.white : AppColors.auroraPurple,
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(18, 4, 18, 18),
                itemCount: options.length,
                separatorBuilder: (_, i) => Divider(
                  height: 1,
                  thickness: 1,
                  color: dividerColor,
                ),
                itemBuilder: (context, i) {
                  final opt = options[i];
                  final isSelected = opt == selected;
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => Navigator.of(context).pop(opt),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              opt,
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontSize: 14,
                                fontWeight: isSelected
                                    ? FontWeight.w800
                                    : FontWeight.w600,
                                color: isSelected
                                    ? AppColors.auroraPurple
                                    : textColor,
                              ),
                            ),
                          ),
                          if (isSelected)
                            FaIcon(
                              FontAwesomeIcons.check,
                              size: 13,
                              color: AppColors.auroraPurple,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
