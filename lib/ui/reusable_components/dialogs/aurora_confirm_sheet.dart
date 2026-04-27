import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../services/theme_service.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_text_styles.dart';

Future<void> showAuroraConfirmSheet(
  BuildContext context, {
  required String title,
  String? subtitle,
  required FaIconData icon,
  Color iconColor = AppColors.auroraRed,
  String confirmLabel = 'Confirm',
  Color confirmColor = AppColors.auroraRed,
  String cancelLabel = 'Cancel',
  required VoidCallback onConfirm,
}) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (_) => _AuroraConfirmSheet(
      title: title,
      subtitle: subtitle,
      icon: icon,
      iconColor: iconColor,
      confirmLabel: confirmLabel,
      confirmColor: confirmColor,
      cancelLabel: cancelLabel,
      onConfirm: onConfirm,
    ),
  );
}

class _AuroraConfirmSheet extends StatelessWidget {
  final String title;
  final String? subtitle;
  final FaIconData icon;
  final Color iconColor;
  final String confirmLabel;
  final Color confirmColor;
  final String cancelLabel;
  final VoidCallback onConfirm;

  const _AuroraConfirmSheet({
    required this.title,
    this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.confirmLabel,
    required this.confirmColor,
    required this.cancelLabel,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeService.instance.isDarkMode;
    final fill = isDark ? const Color(0xFF12122A) : AppColors.white;
    final border = isDark
        ? AppColors.white.withValues(alpha: 0.08)
        : AppColors.auroraPurple.withValues(alpha: 0.12);
    final textColor = isDark ? AppColors.white : AppColors.auroraDeepBase;
    final subColor = isDark
        ? AppColors.white.withValues(alpha: 0.45)
        : AppColors.auroraDeepBase.withValues(alpha: 0.5);

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 24),
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: border),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 20),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: FaIcon(icon, size: 18, color: iconColor),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: AppTextStyles.heading4.copyWith(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: textColor,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                subtitle!,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodySmall.copyWith(
                  fontSize: 13,
                  color: subColor,
                ),
              ),
            ),
          ],
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.white.withValues(alpha: 0.06)
                            : AppColors.auroraPurple.withValues(alpha: 0.07),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: border),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        cancelLabel,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: textColor,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      onConfirm();
                    },
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: confirmColor,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        confirmLabel,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
