import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';

import '../../../../services/cart_service.dart';
import '../../../../services/theme_service.dart';
import '../../../../themes/app_colors.dart';
import '../../../../themes/app_text_styles.dart';
import '_cart_surface_theme.dart';
import 'promo_sheet.dart';

class PromoRow extends StatelessWidget {
  const PromoRow({super.key});

  @override
  Widget build(BuildContext context) {
    final cartService = GetIt.instance<CartService>();

    return ListenableBuilder(
      listenable: Listenable.merge([cartService, ThemeService.instance]),
      builder: (context, _) {
        final c = CartSurfaceColors.of(
          isDark: ThemeService.instance.isDarkMode,
        );
        final applied = cartService.hasPromo;
        final border = applied
            ? AppColors.auroraPink.withValues(alpha: 0.40)
            : c.glassBorder;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
          decoration: BoxDecoration(
            color: c.glassFill,
            border: Border.all(color: border, width: 1),
            borderRadius: BorderRadius.circular(14),
            boxShadow: applied
                ? [
                    BoxShadow(
                      color: AppColors.auroraPink.withValues(alpha: 0.20),
                      blurRadius: 16,
                      spreadRadius: 0,
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: AppColors.auroraPink.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: FaIcon(
                  FontAwesomeIcons.tag,
                  size: 12,
                  color: AppColors.auroraPink,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: applied
                      ? [
                          Text(
                            'promo_row.code_applied'.tr(
                              namedArgs: {'code': '${cartService.promoCode}'},
                            ),
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: c.text,
                              letterSpacing: -0.1,
                            ),
                          ),
                          const SizedBox(height: 1),
                          Text(
                            'promo_row.discount_hint'.tr(),
                            style: AppTextStyles.bodySmall.copyWith(
                              fontSize: 10.5,
                              color: c.textMute,
                            ),
                          ),
                        ]
                      : [
                          Text(
                            'promo_row.have_promo'.tr(),
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: c.text,
                              letterSpacing: -0.1,
                            ),
                          ),
                          const SizedBox(height: 1),
                          Text(
                            'promo_row.tap_to_enter'.tr(),
                            style: AppTextStyles.bodySmall.copyWith(
                              fontSize: 10.5,
                              color: c.textMute,
                            ),
                          ),
                        ],
                ),
              ),
              const SizedBox(width: 8),
              _PromoActionButton(
                applied: applied,
                surfaceColors: c,
                onApply: () => showPromoSheet(context),
                onRemove: cartService.removePromo,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PromoActionButton extends StatelessWidget {
  final bool applied;
  final CartSurfaceColors surfaceColors;
  final VoidCallback onApply;
  final VoidCallback onRemove;

  const _PromoActionButton({
    required this.applied,
    required this.surfaceColors,
    required this.onApply,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final pink = AppColors.auroraPink;
    final isApplied = applied;
    final bg = isApplied ? Colors.transparent : pink.withValues(alpha: 0.12);
    final border = isApplied
        ? surfaceColors.chipBorder
        : pink.withValues(alpha: 0.50);
    final color = isApplied ? surfaceColors.textMute : pink;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: isApplied ? onRemove : onApply,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: bg,
          border: Border.all(color: border, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          isApplied ? 'promo_row.remove'.tr() : 'promo_row.apply'.tr(),
          style: AppTextStyles.caption.copyWith(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.3,
            color: color,
          ),
        ),
      ),
    );
  }
}
