import 'package:flutter/material.dart';

import '../../../services/theme_service.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_text_styles.dart';

/// Subcategory tile. Full-bleed image card with label below.
/// Uses a network image URL; shows a grey placeholder when null or on error.
class AuroraSubcategoryTile extends StatelessWidget {
  final String? imageUrl;
  final String label;
  final VoidCallback onTap;

  const AuroraSubcategoryTile({
    super.key,
    this.imageUrl,
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
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: _buildImage(isDark),
                ),
              ),
              const SizedBox(height: 5),
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

  Widget _buildImage(bool isDark) {
    final placeholder = Container(
      width: double.infinity,
      color: AppColors.skeletonBase,
    );

    if (imageUrl == null || imageUrl!.isEmpty) return placeholder;

    return Image.network(
      imageUrl!,
      fit: BoxFit.cover,
      width: double.infinity,
      errorBuilder: (_, _, _) => placeholder,
      loadingBuilder: (_, child, progress) =>
          progress == null ? child : placeholder,
    );
  }
}
