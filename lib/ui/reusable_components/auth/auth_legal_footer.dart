import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../routes/route_constants.dart';
import '../../../services/theme_service.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_text_styles.dart';

class AuthLegalFooter extends StatelessWidget {
  const AuthLegalFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeService.instance.isDarkMode;
    final baseColor =
        isDark ? AppColors.mutedOnDark : AppColors.auroraDeepBase;
    final linkStyle = AppTextStyles.dsMuted.copyWith(
      fontSize: 12,
      color: AppColors.auroraPink,
      fontWeight: FontWeight.w700,
      decoration: TextDecoration.none,
    );

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: AppTextStyles.dsMuted.copyWith(
          color: baseColor,
          fontSize: 12,
        ),
        children: [
          TextSpan(text: 'auth.legal_prefix'.tr()),
          TextSpan(
            text: 'auth.terms'.tr(),
            style: linkStyle,
            recognizer: TapGestureRecognizer()
              ..onTap = () =>
                  Navigator.pushNamed(context, termsConditionsScreenRoute),
          ),
          TextSpan(text: 'auth.legal_middle'.tr()),
          TextSpan(
            text: 'auth.privacy'.tr(),
            style: linkStyle,
            recognizer: TapGestureRecognizer()
              ..onTap = () =>
                  Navigator.pushNamed(context, privacyPolicyScreenRoute),
          ),
        ],
      ),
    );
  }
}
