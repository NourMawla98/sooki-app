import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../themes/app_colors.dart';
import '../../../themes/app_text_styles.dart';
import '../../../utils/number_localization.dart';

/// The DEAL pill shown on anything priced by a live deal, with the percent
/// saved when there is one.
class DealBadge extends StatelessWidget {
  final int? percentOff;
  final double fontSize;

  const DealBadge({super.key, this.percentOff, this.fontSize = 9});

  @override
  Widget build(BuildContext context) {
    final percent = percentOff;
    final text = percent == null
        ? 'deals.badge'.tr()
        : '${'deals.badge'.tr()} -${localizedNumber(percent)}%';

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: fontSize * 0.8,
        vertical: fontSize * 0.35,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.auroraRed, AppColors.auroraPink],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.auroraPink.withValues(alpha: 0.35),
            blurRadius: 6,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(
            FontAwesomeIcons.bolt,
            size: fontSize - 1,
            color: AppColors.white,
          ),
          SizedBox(width: fontSize * 0.4),
          Text(
            text,
            style: AppTextStyles.badgeText.copyWith(
              color: AppColors.white,
              fontSize: fontSize,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.3,
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}
