import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../services/theme_service.dart';
import '../../../../themes/app_colors.dart';
import '../../../../themes/app_text_styles.dart';
import '_cart_surface_theme.dart';

class CartEmptyState extends StatelessWidget {
  final VoidCallback onBrowse;

  const CartEmptyState({super.key, required this.onBrowse});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService.instance,
      builder: (context, _) {
        final c = CartSurfaceColors.of(
          isDark: ThemeService.instance.isDarkMode,
        );
        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Container(
              padding: const EdgeInsets.fromLTRB(26, 30, 26, 26),
              decoration: BoxDecoration(
                color: c.glassFill,
                border: Border.all(color: c.glassBorder, width: 1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Aurora halo + cart icon
                  SizedBox(
                    width: 118,
                    height: 118,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 118,
                          height: 118,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                AppColors.auroraPink.withValues(alpha: 0.45),
                                AppColors.auroraPurple.withValues(alpha: 0.25),
                                Colors.transparent,
                              ],
                              stops: const [0.0, 0.5, 1.0],
                            ),
                          ),
                        ),
                        Container(
                          width: 78,
                          height: 78,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: AppColors.auroraCartButtonGradient,
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.auroraPurple.withValues(
                                  alpha: 0.45,
                                ),
                                blurRadius: 26,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: FaIcon(
                            FontAwesomeIcons.bagShopping,
                            size: 30,
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  Text(
                    'Your bag is empty',
                    style: AppTextStyles.heading2.copyWith(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: c.text,
                      letterSpacing: -0.3,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Time to shop.',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: c.textMute,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 22),
                  _BrowseCta(onTap: onBrowse),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _BrowseCta extends StatelessWidget {
  final VoidCallback onTap;

  const _BrowseCta({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 28),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: AppColors.auroraCartButtonGradient,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.auroraPink.withValues(alpha: 0.30),
              blurRadius: 20,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'BROWSE PRODUCTS',
              style: AppTextStyles.buttonMedium.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.8,
                color: AppColors.white,
              ),
            ),
            const SizedBox(width: 8),
            FaIcon(
              FontAwesomeIcons.arrowRight,
              size: 11,
              color: AppColors.white,
            ),
          ],
        ),
      ),
    );
  }
}
