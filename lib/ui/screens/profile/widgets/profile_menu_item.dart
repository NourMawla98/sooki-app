import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../themes/app_colors.dart';
import '../../../../themes/app_text_styles.dart';

class ProfileMenuItem extends StatelessWidget {
  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.isDark,
    required this.onTap,
    this.badge,
  });

  final FaIconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool isDark;
  final VoidCallback onTap;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: FaIcon(icon, size: 15, color: iconColor),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodySmall.copyWith(
                      color:
                          isDark ? AppColors.white : AppColors.auroraDeepBase,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    subtitle,
                    style: AppTextStyles.captionSmall.copyWith(
                      color: isDark
                          ? AppColors.white.withValues(alpha: 0.35)
                          : AppColors.auroraPurple.withValues(alpha: 0.5),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            if (badge != null) ...[
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.auroraPink,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  badge!,
                  style: AppTextStyles.captionSmall.copyWith(
                    color: AppColors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
            FaIcon(
              isRtl
                  ? FontAwesomeIcons.chevronLeft
                  : FontAwesomeIcons.chevronRight,
              size: 12,
              color: isDark
                  ? AppColors.white.withValues(alpha: 0.2)
                  : AppColors.auroraPurple.withValues(alpha: 0.25),
            ),
          ],
        ),
      ),
    );
  }
}
