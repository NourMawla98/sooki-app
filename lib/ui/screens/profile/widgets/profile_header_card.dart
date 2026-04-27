import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../services/theme_service.dart';
import '../../../../themes/app_colors.dart';
import '../../../../themes/app_text_styles.dart';

class ProfileHeaderCard extends StatelessWidget {
  const ProfileHeaderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService.instance,
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;

        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
          child: Column(
            children: [
              // Gradient ring avatar
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: AppColors.auroraGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding: const EdgeInsets.all(2.5),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        isDark ? AppColors.auroraDeepBase : AppColors.white,
                  ),
                  child: Center(
                    child: FaIcon(
                      FontAwesomeIcons.user,
                      size: 28,
                      color: isDark
                          ? AppColors.white.withValues(alpha: 0.85)
                          : AppColors.auroraPurple,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Nour Mawla',
                style: AppTextStyles.heading3.copyWith(
                  color: isDark ? AppColors.white : AppColors.auroraDeepBase,
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'nour@example.com',
                style: AppTextStyles.bodySmall.copyWith(
                  color: isDark
                      ? AppColors.white.withValues(alpha: 0.45)
                      : AppColors.auroraPurple.withValues(alpha: 0.55),
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 20),
              // Stats row
              Container(
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.white.withValues(alpha: 0.04)
                      : AppColors.auroraPurple.withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark
                        ? AppColors.white.withValues(alpha: 0.08)
                        : AppColors.auroraPurple.withValues(alpha: 0.10),
                  ),
                ),
                child: IntrinsicHeight(
                  child: Row(
                    children: [
                      _StatCell(value: '12', label: 'Orders', isDark: isDark),
                      _VerticalDivider(isDark: isDark),
                      _StatCell(
                          value: '3', label: 'Wishlist', isDark: isDark),
                      _VerticalDivider(isDark: isDark),
                      _StatCell(
                          value: '840', label: 'Points', isDark: isDark),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  const _VerticalDivider({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return VerticalDivider(
      width: 1,
      thickness: 1,
      color: isDark
          ? AppColors.white.withValues(alpha: 0.07)
          : AppColors.auroraPurple.withValues(alpha: 0.10),
    );
  }
}

class _StatCell extends StatelessWidget {
  const _StatCell({
    required this.value,
    required this.label,
    required this.isDark,
  });

  final String value;
  final String label;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          children: [
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: AppColors.auroraGradient,
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
              blendMode: BlendMode.srcIn,
              child: Text(
                value,
                style: AppTextStyles.heading4.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: AppColors.white,
                ),
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: AppTextStyles.captionSmall.copyWith(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.6,
                color: isDark
                    ? AppColors.white.withValues(alpha: 0.35)
                    : AppColors.auroraPurple.withValues(alpha: 0.45),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
