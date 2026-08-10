import 'package:flutter/material.dart';

import '../../../themes/app_colors.dart';
import '../../../themes/app_text_styles.dart';

/// Renders [text] with the aurora pink to purple to blue gradient applied via
/// [ShaderMask]. Defaults to [AppTextStyles.dsH2]. Pass a custom [style]
/// to override size, weight, or any other property.
class AuroraGradientText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign textAlign;

  const AuroraGradientText(
    this.text, {
    super.key,
    this.style,
    this.textAlign = TextAlign.start,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: AppColors.auroraGradient,
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
      blendMode: BlendMode.srcIn,
      child: Text(
        text,
        textAlign: textAlign,
        style: style ?? AppTextStyles.dsH2,
      ),
    );
  }
}
