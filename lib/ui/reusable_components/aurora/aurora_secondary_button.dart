import 'package:flutter/material.dart';

import '../../../services/theme_service.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_text_styles.dart';

/// Secondary button — transparent fill (matches surface), 1.5 px aurora
/// gradient border, gradient text. The visual opposite of [AuroraPrimaryButton].
class AuroraSecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isFullWidth;
  final double height;
  final double borderRadius;
  final TextStyle? textStyle;

  const AuroraSecondaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isFullWidth = true,
    this.height = 52,
    this.borderRadius = 12,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService.instance,
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;
        // Inner fill must be a solid color so the gradient outer container
        // only peeks through as the 1.5 px border ring.
        final innerFill =
            isDark ? AppColors.auroraDeepBase : AppColors.white;

        return SizedBox(
          width: isFullWidth ? double.infinity : null,
          height: height,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: AppColors.auroraGradient,
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: Padding(
              padding: const EdgeInsets.all(1.5),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: innerFill,
                  borderRadius: BorderRadius.circular(borderRadius - 1.5),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius:
                        BorderRadius.circular(borderRadius - 1.5),
                    onTap: isLoading ? null : onPressed,
                    child: Center(
                      child: isLoading
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.auroraPurple,
                                ),
                              ),
                            )
                          : ShaderMask(
                              shaderCallback: (bounds) =>
                                  const LinearGradient(
                                colors: AppColors.auroraGradient,
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ).createShader(
                                Rect.fromLTWH(
                                    0, 0, bounds.width, bounds.height),
                              ),
                              blendMode: BlendMode.srcIn,
                              child: Text(
                                text,
                                style: textStyle ??
                                    AppTextStyles.dsCTA
                                        .copyWith(color: AppColors.white),
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
