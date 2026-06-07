import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../models/review.dart';
import '../../../../services/theme_service.dart';
import '../../../../themes/themes.dart';
import '../../../reusable_components/rating_stars/star_rating.dart';

class AuroraReviewCard extends StatelessWidget {
  const AuroraReviewCard({super.key, required this.review});
  final Review review;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService.instance,
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;
        final cellBg = isDark
            ? AppColors.white.withValues(alpha: 0.04)
            : AppColors.primaryPurple.withValues(alpha: 0.04);
        final cellBorder = isDark
            ? AppColors.white.withValues(alpha: 0.10)
            : AppColors.primaryPurple.withValues(alpha: 0.18);
        final textColor = isDark ? AppColors.white : AppColors.primaryPurple;
        final bodyColor =
            (isDark ? AppColors.white : AppColors.primaryPurple)
                .withValues(alpha: 0.85);
        final mutedColor =
            (isDark ? AppColors.white : AppColors.primaryPurple)
                .withValues(alpha: 0.55);

        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: cellBg,
            border: Border.all(color: cellBorder),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      review.userName,
                      style: AppFonts.primary(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                        height: 1.2,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (review.isVerifiedPurchase) ...[
                    const SizedBox(width: 8),
                    const _VerifiedPill(),
                  ],
                  const Spacer(),
                  Text(
                    review.date,
                    style: AppFonts.primary(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: mutedColor,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              StarRating(rating: review.rating, size: 12, showValue: false),
              const SizedBox(height: 8),
              Text(
                review.text,
                style: AppFonts.primary(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: bodyColor,
                  height: 1.4,
                ),
              ),
              if (review.helpfulCount > 0) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    FaIcon(
                      FontAwesomeIcons.thumbsUp,
                      size: 10,
                      color: mutedColor,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '${review.helpfulCount} helpful',
                      style: AppFonts.primary(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: mutedColor,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _VerifiedPill extends StatelessWidget {
  const _VerifiedPill();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.verifiedGreen.withValues(alpha: 0.15),
        border: Border.all(
          color: AppColors.verifiedGreen.withValues(alpha: 0.45),
        ),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const FaIcon(
            FontAwesomeIcons.solidCircleCheck,
            size: 8,
            color: AppColors.verifiedGreen,
          ),
          const SizedBox(width: 4),
          Text(
            'VERIFIED',
            style: AppFonts.primary(
              fontSize: 8,
              fontWeight: FontWeight.w800,
              color: AppColors.verifiedGreen,
              letterSpacing: 0.5,
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}
