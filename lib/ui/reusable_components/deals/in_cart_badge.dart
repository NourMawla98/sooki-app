import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../themes/app_colors.dart';
import '../../../themes/app_text_styles.dart';
import '../../../utils/number_localization.dart';

/// A small green pill saying how many of an item are already in the cart.
class InCartBadge extends StatelessWidget {
  final int count;
  final double fontSize;

  const InCartBadge({super.key, required this.count, this.fontSize = 9});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: fontSize * 0.8,
        vertical: fontSize * 0.35,
      ),
      decoration: BoxDecoration(
        color: AppColors.verifiedGreen,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(
            FontAwesomeIcons.cartShopping,
            size: fontSize - 1,
            color: AppColors.white,
          ),
          SizedBox(width: fontSize * 0.4),
          Flexible(
            child: Text(
              'deals.in_cart'.tr(namedArgs: {'count': localizedNumber(count)}),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.badgeText.copyWith(
                color: AppColors.white,
                fontSize: fontSize,
                fontWeight: FontWeight.w800,
                height: 1.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
