import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../themes/themes.dart';

class StarRating extends StatelessWidget {
  final double rating;
  final double size;
  final bool showValue;

  const StarRating({
    super.key,
    required this.rating,
    this.size = 14,
    this.showValue = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(5, (index) {
          final starValue = index + 1;
          FaIconData icon;
          Color color;

          if (rating >= starValue - 0.25) {
            icon = FontAwesomeIcons.solidStar;
            color = AppColors.auroraGold;
          } else {
            icon = FontAwesomeIcons.solidStar;
            color = AppColors.auroraGold.withValues(alpha: 0.20);
          }

          return Padding(
            padding: const EdgeInsets.only(right: 2),
            child: FaIcon(icon, size: size, color: color),
          );
        }),
        if (showValue) ...[
          const SizedBox(width: 4),
          Text(
            rating.toStringAsFixed(1),
            style: AppTextStyles.ratingValue.copyWith(fontSize: size),
          ),
        ],
      ],
    );
  }
}
