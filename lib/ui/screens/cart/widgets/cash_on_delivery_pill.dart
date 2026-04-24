import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../services/theme_service.dart';
import '../../../../themes/app_colors.dart';
import '../../../../themes/app_text_styles.dart';
import '_cart_surface_theme.dart';

class CashOnDeliveryPill extends StatelessWidget {
  const CashOnDeliveryPill({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService.instance,
      builder: (context, _) {
        final c = CartSurfaceColors.of(
          isDark: ThemeService.instance.isDarkMode,
        );
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: c.glassFill,
            border: Border.all(color: c.glassBorder, width: 1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: AppColors.auroraElectricBlue.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(7),
                ),
                alignment: Alignment.center,
                child: FaIcon(
                  FontAwesomeIcons.moneyBillWave,
                  size: 11,
                  color: AppColors.auroraElectricBlue,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Cash on delivery',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: c.text,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      'Pay the courier when your order arrives',
                      style: AppTextStyles.bodySmall.copyWith(
                        fontSize: 10,
                        color: c.textMute,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
