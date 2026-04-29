import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../routes/route_constants.dart';
import '../../../../services/theme_service.dart';
import '../../../../themes/app_colors.dart';
import '../../../../themes/app_text_styles.dart';
import '../../../reusable_components/aurora/aurora_primary_button.dart';

Future<void> showAuroraLoginGate(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (_) => Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: const _AuroraLoginGateSheet(),
    ),
  );
}

class _AuroraLoginGateSheet extends StatelessWidget {
  const _AuroraLoginGateSheet();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService.instance,
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;
        final fill = isDark ? const Color(0xFF12122A) : AppColors.white;
        final border = isDark
            ? AppColors.white.withValues(alpha: 0.08)
            : AppColors.auroraPurple.withValues(alpha: 0.12);
        final textColor =
            isDark ? AppColors.white : AppColors.auroraDeepBase;
        final subColor = isDark
            ? AppColors.white.withValues(alpha: 0.45)
            : AppColors.auroraDeepBase.withValues(alpha: 0.50);

        return Container(
          decoration: BoxDecoration(
            color: fill,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: border),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),

              // Lock icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: AppColors.auroraGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.auroraPurple.withValues(
                          alpha: isDark ? 0.40 : 0.20),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: const FaIcon(
                  FontAwesomeIcons.lock,
                  size: 17,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: 14),

              // Label
              Text(
                'ONE MORE STEP',
                style: AppTextStyles.dsSectionLabel.copyWith(
                  color: AppColors.auroraPink,
                  letterSpacing: 2.0,
                ),
              ),
              const SizedBox(height: 6),

              // Title
              Text(
                'Log in to checkout',
                style: AppTextStyles.heading3.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: textColor,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: 10),

              // Body
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  'We keep your bag while you sign in. Your cart and wishlist stay where they are.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontSize: 13,
                    color: subColor,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // LOG IN button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: AuroraPrimaryButton(
                  text: 'LOG IN',
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed(signInScreenRoute);
                  },
                ),
              ),
              const SizedBox(height: 10),

              // Continue shopping
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  height: 44,
                  alignment: Alignment.center,
                  child: Text(
                    'Continue shopping',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: subColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
}
