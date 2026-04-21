import 'package:flutter/material.dart';

import '../../../../models/product.dart';
import '../../../../services/theme_service.dart';
import '../../../../themes/themes.dart';
import '../../../reusable_components/rating_stars/star_rating.dart';

class ProductInfo extends StatelessWidget {
  final Product product;

  const ProductInfo({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService.instance,
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;
        final textColor = isDark ? AppColors.white : AppColors.primaryPurple;
        final mutedColor =
            (isDark ? AppColors.white : AppColors.primaryPurple)
                .withValues(alpha: 0.65);
        final strongMuted =
            (isDark ? AppColors.white : AppColors.primaryPurple)
                .withValues(alpha: 0.85);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${product.brand.toUpperCase()}  ·  ${product.category.toUpperCase()}',
              style: AppFonts.primary(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: mutedColor,
                letterSpacing: 1.4,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              product.name,
              style: AppFonts.primary(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: textColor,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                StarRating(
                  rating: product.rating,
                  size: 13,
                  showValue: false,
                ),
                const SizedBox(width: 6),
                Text(
                  product.rating.toStringAsFixed(1),
                  style: AppFonts.primary(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: strongMuted,
                    height: 1.1,
                  ),
                ),
                const SizedBox(width: 6),
                Text('·',
                    style: AppFonts.primary(fontSize: 12, color: mutedColor)),
                const SizedBox(width: 6),
                Text(
                  '${product.reviewCount} reviews',
                  style: AppFonts.primary(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: mutedColor,
                    height: 1.1,
                  ),
                ),
                const SizedBox(width: 10),
                _StockBadge(stockCount: product.stockCount),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _StockBadge extends StatelessWidget {
  const _StockBadge({required this.stockCount});
  final int stockCount;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (stockCount) {
      <= 0 => ('Out of stock', AppColors.accentRed),
      < 5 => ('Only $stockCount left', AppColors.accentYellow),
      _ => ('In stock', AppColors.verifiedGreen),
    };

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: AppFonts.primary(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: color,
            height: 1.1,
          ),
        ),
      ],
    );
  }
}
