import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../models/product.dart';
import '../../../../themes/themes.dart';
import '../../../reusable_components/rating_stars/star_rating.dart';

class ProductInfo extends StatelessWidget {
  final Product product;

  const ProductInfo({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Brand badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.primaryPurple,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(product.brand, style: AppTextStyles.badgeText),
        ),
        const SizedBox(height: 8),

        // Category
        Text(
          product.category,
          style: AppTextStyles.bodySmall.copyWith(color: AppColors.gray400),
        ),
        const SizedBox(height: 4),

        // Product name + verified badge
        Row(
          children: [
            Expanded(
              child: Text(product.name, style: AppTextStyles.heading2),
            ),
            if (product.isVerified) ...[
              const SizedBox(width: 8),
              const FaIcon(
                FontAwesomeIcons.circleCheck,
                size: 16,
                color: AppColors.verifiedGreen,
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),

        // Star rating row
        Row(
          children: [
            StarRating(rating: product.rating, size: 14, showValue: true),
            const SizedBox(width: 8),
            Text(
              '(${product.reviewCount} reviews)',
              style: AppTextStyles.bodySmall,
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Price row
        Row(
          children: [
            Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: AppTextStyles.dealPrice,
            ),
            if (product.originalPrice != null) ...[
              const SizedBox(width: 8),
              Text(
                '\$${product.originalPrice!.toStringAsFixed(2)}',
                style: AppTextStyles.dealOriginalPrice,
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.discountBadge,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '-${product.discountPercentage}%',
                  style: AppTextStyles.badgeText,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),

        // Stock row
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: product.stockCount > 10
                    ? AppColors.accentGreen
                    : product.stockCount > 0
                        ? AppColors.accentYellow
                        : AppColors.accentRed,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              '${product.stockCount} in stock',
              style: AppTextStyles.bodySmall,
            ),
          ],
        ),
      ],
    );
  }
}
