import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../models/product.dart';
import '../../../services/theme_service.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_text_styles.dart';

/// Placeholder screen shown when a product card is tapped. Full details UI
/// will replace this once the backend is wired.
class ItemDetailsScreen extends StatelessWidget {
  final Product? product;

  const ItemDetailsScreen({super.key, this.product});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService.instance,
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;
        final bg = isDark
            ? AppColors.auroraDeepBase
            : AppColors.auroraLightBase;
        final fg = isDark ? AppColors.white : AppColors.primaryPurple;
        final subtle = isDark
            ? AppColors.white.withValues(alpha: 0.6)
            : AppColors.primaryPurple.withValues(alpha: 0.6);

        return Scaffold(
          backgroundColor: bg,
          appBar: AppBar(
            backgroundColor: bg,
            elevation: 0,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: FaIcon(FontAwesomeIcons.arrowLeft, size: 18, color: fg),
            ),
            title: Text(
              'Item Details',
              style: AppTextStyles.heading3.copyWith(
                color: fg,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FaIcon(
                    FontAwesomeIcons.hourglassHalf,
                    size: 56,
                    color: AppColors.auroraElectricBlue,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Coming Soon',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.heading2.copyWith(
                      color: fg,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  if (product != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      product!.name,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyLarge.copyWith(color: subtle),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
