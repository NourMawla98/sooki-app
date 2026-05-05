import 'package:flutter/material.dart';

import '../../../services/theme_service.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_text_styles.dart';

/// Subcategory tile — full-bleed image card with label below.
class AuroraSubcategoryTile extends StatelessWidget {
  final String imageAsset;
  final String label;
  final VoidCallback onTap;

  const AuroraSubcategoryTile({
    super.key,
    required this.imageAsset,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService.instance,
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;

        return GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Column(
            children: [
              // Full-bleed image card
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(imageAsset, fit: BoxFit.cover,
                    width: double.infinity),
                ),
              ),
              const SizedBox(height: 5),
              // Label below
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w700,
                  color: isDark
                      ? AppColors.white.withValues(alpha: 0.85)
                      : AppColors.auroraPurple,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
