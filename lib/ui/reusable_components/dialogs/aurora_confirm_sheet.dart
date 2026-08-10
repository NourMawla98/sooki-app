import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../services/theme_service.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_text_styles.dart';

Future<bool> showAuroraConfirmSheet(
  BuildContext context, {
  required String title,
  String? subtitle,
  required FaIconData icon,
  Color iconColor = AppColors.auroraRed,
  String? confirmLabel,
  Color confirmColor = AppColors.auroraRed,
  String? cancelLabel,
  Future<void> Function()? onConfirm,
}) async {
  final result = await showGeneralDialog<bool>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'aurora_confirm_sheet.dismiss'.tr(),
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 260),
    pageBuilder: (_, _, _) => _AuroraConfirmSheet(
      title: title,
      subtitle: subtitle,
      icon: icon,
      iconColor: iconColor,
      confirmLabel: confirmLabel ?? 'common.confirm'.tr(),
      confirmColor: confirmColor,
      cancelLabel: cancelLabel ?? 'common.cancel'.tr(),
      onConfirm: onConfirm,
    ),
    transitionBuilder: (_, anim, _, child) {
      final slide = Tween<Offset>(
        begin: const Offset(0, 0.12),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic));
      return FadeTransition(
        opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut),
        child: SlideTransition(
          position: slide,
          child: Material(
            color: Colors.transparent,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: child,
              ),
            ),
          ),
        ),
      );
    },
  );
  return result ?? false;
}

class _AuroraConfirmSheet extends StatefulWidget {
  final String title;
  final String? subtitle;
  final FaIconData icon;
  final Color iconColor;
  final String confirmLabel;
  final Color confirmColor;
  final String cancelLabel;
  final Future<void> Function()? onConfirm;

  const _AuroraConfirmSheet({
    required this.title,
    this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.confirmLabel,
    required this.confirmColor,
    required this.cancelLabel,
    this.onConfirm,
  });

  @override
  State<_AuroraConfirmSheet> createState() => _AuroraConfirmSheetState();
}

class _AuroraConfirmSheetState extends State<_AuroraConfirmSheet> {
  bool _isLoading = false;

  Future<void> _handleConfirm() async {
    if (widget.onConfirm == null) {
      Navigator.of(context).pop(true);
      return;
    }
    setState(() => _isLoading = true);
    await widget.onConfirm!();
    if (mounted) Navigator.of(context).pop(true);
  }

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
              color: widget.iconColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: FaIcon(widget.icon, size: 18, color: widget.iconColor),
          ),
          const SizedBox(height: 14),
          Text(
            widget.title,
            style: AppTextStyles.heading4.copyWith(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: textColor,
            ),
          ),
          if (widget.subtitle != null) ...[
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                widget.subtitle!,
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
                    onTap: _isLoading ? null : () => Navigator.of(context).pop(),
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.white.withValues(alpha: _isLoading ? 0.03 : 0.06)
                            : AppColors.auroraPurple.withValues(alpha: _isLoading ? 0.04 : 0.07),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: border),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        widget.cancelLabel,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: textColor.withValues(alpha: _isLoading ? 0.35 : 1.0),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: _isLoading ? null : _handleConfirm,
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: widget.confirmColor.withValues(alpha: _isLoading ? 0.7 : 1.0),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      alignment: Alignment.center,
                      child: _isLoading
                          ? SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.white.withValues(alpha: 0.9),
                              ),
                            )
                          : Text(
                              widget.confirmLabel,
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
