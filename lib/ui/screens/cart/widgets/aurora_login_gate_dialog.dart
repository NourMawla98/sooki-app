import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../routes/route_constants.dart';
import '../../../../services/theme_service.dart';
import '../../../../themes/app_colors.dart';
import '../../../../themes/app_text_styles.dart';
import '../../../reusable_components/aurora/aurora_primary_button.dart';
import '_cart_surface_theme.dart';

/// Aurora-styled login gate shown when a guest taps `Proceed to checkout`.
Future<void> showAuroraLoginGate(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierColor: AppColors.black.withValues(alpha: 0.55),
    builder: (_) => const _AuroraLoginGateDialog(),
  );
}

class _AuroraLoginGateDialog extends StatelessWidget {
  const _AuroraLoginGateDialog();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService.instance,
      builder: (context, _) {
        final c = CartSurfaceColors.of(
          isDark: ThemeService.instance.isDarkMode,
        );
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          insetPadding: const EdgeInsets.symmetric(horizontal: 28),
          child: Container(
            padding: const EdgeInsets.fromLTRB(22, 20, 22, 22),
            decoration: BoxDecoration(
              color: c.sheet,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: c.sheetTop, width: 1),
              boxShadow: [
                BoxShadow(
                  color: AppColors.auroraPurple.withValues(alpha: 0.30),
                  blurRadius: 26,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: AppColors.auroraCartButtonGradient,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.auroraPurple.withValues(
                              alpha: 0.40,
                            ),
                            blurRadius: 14,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: FaIcon(
                        FontAwesomeIcons.lock,
                        size: 15,
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'ONE MORE STEP',
                            style: AppTextStyles.label.copyWith(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 2,
                              color: AppColors.auroraPink,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Log in to checkout',
                            style: AppTextStyles.heading3.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: c.text,
                              letterSpacing: -0.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  'We keep your bag while you sign in. Your cart and wishlist '
                  'stay where they are.',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontSize: 13,
                    color: c.textMute,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 20),
                AuroraPrimaryButton(
                  text: 'LOG IN',
                  height: 46,
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed(signInScreenRoute);
                  },
                ),
                const SizedBox(height: 10),
                _GhostButton(
                  label: 'Continue shopping',
                  textColor: c.textMute,
                  onTap: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _GhostButton extends StatelessWidget {
  final String label;
  final Color textColor;
  final VoidCallback onTap;

  const _GhostButton({
    required this.label,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        height: 40,
        alignment: Alignment.center,
        child: Text(
          label,
          style: AppTextStyles.buttonMedium.copyWith(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
