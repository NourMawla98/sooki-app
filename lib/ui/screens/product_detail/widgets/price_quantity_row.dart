import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../services/theme_service.dart';
import '../../../../themes/themes.dart';

class PriceQuantityRow extends StatelessWidget {
  const PriceQuantityRow({
    super.key,
    required this.unitPrice,
    this.originalUnitPrice,
    required this.quantity,
    required this.maxQuantity,
    required this.onQuantityChanged,
  });

  final double unitPrice;
  final double? originalUnitPrice;
  final int quantity;
  final int maxQuantity;
  final ValueChanged<int> onQuantityChanged;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService.instance,
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;
        final total = unitPrice * quantity;
        final originalTotal =
            originalUnitPrice != null ? originalUnitPrice! * quantity : null;
        final mutedStrong =
            (isDark ? AppColors.white : AppColors.primaryPurple)
                .withValues(alpha: 0.55);

        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [
                        AppColors.auroraPink,
                        AppColors.auroraElectricBlue,
                      ],
                    ).createShader(bounds),
                    child: Text(
                      '\$${total.toStringAsFixed(2)}',
                      style: AppFonts.primary(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: AppColors.white,
                        height: 1.0,
                      ),
                    ),
                  ),
                  if (originalTotal != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      '\$${originalTotal.toStringAsFixed(2)}',
                      style: AppFonts.primary(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: mutedStrong,
                        decoration: TextDecoration.lineThrough,
                        decorationColor: mutedStrong,
                        height: 1.0,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            _QtyStepper(
              quantity: quantity,
              maxQuantity: maxQuantity,
              onChanged: onQuantityChanged,
              isDark: isDark,
            ),
          ],
        );
      },
    );
  }
}

class _QtyStepper extends StatelessWidget {
  const _QtyStepper({
    required this.quantity,
    required this.maxQuantity,
    required this.onChanged,
    required this.isDark,
  });

  final int quantity;
  final int maxQuantity;
  final ValueChanged<int> onChanged;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final cellBg = isDark
        ? AppColors.white.withValues(alpha: 0.04)
        : AppColors.primaryPurple.withValues(alpha: 0.04);
    final cellBorder = isDark
        ? AppColors.white.withValues(alpha: 0.10)
        : AppColors.primaryPurple.withValues(alpha: 0.18);
    final minusBtnBg = AppColors.auroraPink.withValues(alpha: 0.12);
    final plusBtnBg = AppColors.auroraElectricBlue.withValues(alpha: 0.12);
    final valueColor = isDark ? AppColors.white : AppColors.primaryPurple;

    final minusDisabled = quantity <= 1;
    final plusDisabled = quantity >= maxQuantity;

    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: cellBg,
        border: Border.all(color: cellBorder),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepperButton(
            icon: FontAwesomeIcons.minus,
            bg: minusBtnBg,
            glyph: AppColors.auroraPink,
            disabled: minusDisabled,
            onTap: minusDisabled ? null : () => onChanged(quantity - 1),
          ),
          SizedBox(
            width: 30,
            child: Center(
              child: Text(
                '$quantity',
                style: AppFonts.primary(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: valueColor,
                  height: 1.0,
                ),
              ),
            ),
          ),
          _StepperButton(
            icon: FontAwesomeIcons.plus,
            bg: plusBtnBg,
            glyph: AppColors.auroraElectricBlue,
            disabled: plusDisabled,
            onTap: plusDisabled ? null : () => onChanged(quantity + 1),
          ),
        ],
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({
    required this.icon,
    required this.bg,
    required this.glyph,
    required this.disabled,
    required this.onTap,
  });

  final FaIconData icon;
  final Color bg;
  final Color glyph;
  final bool disabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Opacity(
        opacity: disabled ? 0.35 : 1.0,
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Center(
            child: FaIcon(icon, size: 12, color: glyph),
          ),
        ),
      ),
    );
  }
}
