import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../enums/sort_option.dart';
import '../../../../services/theme_service.dart';
import '../../../../themes/app_colors.dart';
import '../../../../themes/app_text_styles.dart';

/// Bottom sheet for picking a [SortOption]. Tapping a row pops the sheet
/// with that option — the caller is responsible for applying it.
class SortSheet extends StatelessWidget {
  final SortOption current;
  const SortSheet({super.key, required this.current});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService.instance,
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;
        final bg = isDark ? AppColors.auroraDeepBase : AppColors.white;

        return Container(
          padding: const EdgeInsetsDirectional.fromSTEB(12, 18, 12, 16),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: AppColors.auroraCartButtonGradient,
                  ).createShader(bounds),
                  blendMode: BlendMode.srcIn,
                  child: Text(
                    'sort_sheet.sort_by'.tr(),
                    style: AppTextStyles.heading3.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              for (final option in SortOption.values)
                _SortRow(
                  option: option,
                  isSelected: option == current,
                  isDark: isDark,
                  onTap: () => Navigator.of(context).pop(option),
                ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
}

class _SortRow extends StatelessWidget {
  final SortOption option;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  const _SortRow({
    required this.option,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final mutedText = isDark
        ? AppColors.white.withValues(alpha: 0.80)
        : AppColors.primaryPurple.withValues(alpha: 0.85);
    final mutedBg = isDark
        ? AppColors.white.withValues(alpha: 0.04)
        : AppColors.primaryPurple.withValues(alpha: 0.05);
    final mutedBorder = isDark
        ? AppColors.white.withValues(alpha: 0.10)
        : AppColors.primaryPurple.withValues(alpha: 0.15);
    final mutedIcon = isDark
        ? AppColors.white.withValues(alpha: 0.75)
        : AppColors.primaryPurple.withValues(alpha: 0.85);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          children: [
            _IconBadge(
              icon: option.icon,
              isSelected: isSelected,
              mutedBg: mutedBg,
              mutedBorder: mutedBorder,
              mutedIcon: mutedIcon,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: isSelected
                  ? ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: AppColors.auroraCartButtonGradient,
                      ).createShader(bounds),
                      blendMode: BlendMode.srcIn,
                      child: Text(
                        option.label,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    )
                  : Text(
                      option.label,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: mutedText,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
            _CheckBadge(
              isSelected: isSelected,
              mutedBorder: mutedBorder,
            ),
          ],
        ),
      ),
    );
  }
}

class _IconBadge extends StatelessWidget {
  final FaIconData icon;
  final bool isSelected;
  final Color mutedBg;
  final Color mutedBorder;
  final Color mutedIcon;

  const _IconBadge({
    required this.icon,
    required this.isSelected,
    required this.mutedBg,
    required this.mutedBorder,
    required this.mutedIcon,
  });

  @override
  Widget build(BuildContext context) {
    if (isSelected) {
      return Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: AppColors.auroraCartButtonGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: AppColors.auroraPink.withValues(alpha: 0.35),
              blurRadius: 10,
            ),
          ],
        ),
        child: Center(
          child: FaIcon(icon, size: 14, color: AppColors.white),
        ),
      );
    }
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: mutedBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: mutedBorder),
      ),
      child: Center(child: FaIcon(icon, size: 14, color: mutedIcon)),
    );
  }
}

class _CheckBadge extends StatelessWidget {
  final bool isSelected;
  final Color mutedBorder;

  const _CheckBadge({required this.isSelected, required this.mutedBorder});

  @override
  Widget build(BuildContext context) {
    if (isSelected) {
      return Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: AppColors.auroraCartButtonGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
        ),
        child: const Center(
          child: FaIcon(
            FontAwesomeIcons.check,
            size: 11,
            color: AppColors.white,
          ),
        ),
      );
    }
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: mutedBorder, width: 1.5),
      ),
    );
  }
}
