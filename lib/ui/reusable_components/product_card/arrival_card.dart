import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../models/product.dart';
import '../../../routes/route_constants.dart';
import '../../../services/theme_service.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_text_styles.dart';
import '../aurora/aurora_primary_button.dart';
import '../skeleton/skeleton_shimmer.dart';

/// Compact product card used in the Browse "New Arrivals" section and the
/// Shopping screen grid. Square thumb + name + price + ADD TO CART button.
///
/// Theme-aware chrome:
/// - dark: `white @ 4%` fill + `white @ 8%` border
/// - light: `primaryPurple @ 4%` fill + `primaryPurple @ 15%` border
class ArrivalCard extends StatefulWidget {
  final Product product;
  const ArrivalCard({super.key, required this.product});

  @override
  State<ArrivalCard> createState() => _ArrivalCardState();
}

class _ArrivalCardState extends State<ArrivalCard> {
  bool _isWishlisted = false;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService.instance,
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;
        final cardBg = isDark
            ? AppColors.white.withValues(alpha: 0.04)
            : AppColors.primaryPurple.withValues(alpha: 0.04);
        final cardBorder = isDark
            ? AppColors.white.withValues(alpha: 0.08)
            : AppColors.primaryPurple.withValues(alpha: 0.15);
        // Name uses the theme-aware neutral accent; price uses electric blue
        // in both themes to stay visually distinct from the name.
        final textColor =
            isDark ? AppColors.white : AppColors.primaryPurple;
        const priceColor = AppColors.auroraElectricBlue;

        return GestureDetector(
          onTap: () => Navigator.pushNamed(
            context,
            itemDetailsScreenRoute,
            arguments: widget.product,
          ),
          child: Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(11),
              border: Border.all(color: cardBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(7),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          widget.product.thumbnailUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  AppColors.auroraPurple.withValues(alpha: 0.4),
                                  AppColors.auroraPink.withValues(alpha: 0.2),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 5,
                          right: 5,
                          child: _HeartButton(
                            isActive: _isWishlisted,
                            onTap: () => setState(
                              () => _isWishlisted = !_isWishlisted,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Non-thumb area fills the remaining vertical space: name +
                // price sit at the top, cart button anchors to the bottom.
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.product.name,
                              style: AppTextStyles.caption.copyWith(
                                color: textColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 11,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _formatPrice(widget.product.price),
                              style: AppTextStyles.auroraMonoPrice.copyWith(
                                color: priceColor,
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                        AuroraPrimaryButton(
                          text: 'ADD TO CART',
                          height: 32,
                          // Smaller radius so the proportional roundness
                          // matches the sign-in/sign-up button (12px on 56px
                          // tall). 7 ≈ 12 × 32 / 56.
                          borderRadius: 7,
                          textStyle: AppTextStyles.captionSmall.copyWith(
                            color: AppColors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.0,
                            height: 1.0,
                          ),
                          onPressed: () =>
                              _showAddedToCart(context, widget.product),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAddedToCart(BuildContext context, Product product) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('Added · ${product.name}'),
          duration: const Duration(milliseconds: 1600),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  String _formatPrice(double price) {
    final hasDecimals = price.truncateToDouble() != price;
    return '\$${price.toStringAsFixed(hasDecimals ? 2 : 0)}';
  }
}

class _HeartButton extends StatelessWidget {
  final bool isActive;
  final VoidCallback onTap;
  const _HeartButton({required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          // Dark glass works on top of the product image in both themes.
          color: AppColors.black.withValues(alpha: 0.55),
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.white.withValues(alpha: 0.20),
          ),
        ),
        child: Center(
          child: FaIcon(
            isActive ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart,
            size: 10,
            color: isActive ? AppColors.auroraPink : AppColors.white,
          ),
        ),
      ),
    );
  }
}

/// Shimmer placeholder for a grid of [ArrivalCard]s — 6 cards, 2 columns,
/// same aspect ratio as the real grid.
class ArrivalGridSkeleton extends StatelessWidget {
  const ArrivalGridSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.72,
        ),
        itemCount: 6,
        itemBuilder: (_, _) => const _ArrivalCardSkeleton(),
      ),
    );
  }
}

class _ArrivalCardSkeleton extends StatelessWidget {
  const _ArrivalCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService.instance,
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;
        final border = isDark
            ? AppColors.white.withValues(alpha: 0.08)
            : AppColors.primaryPurple.withValues(alpha: 0.12);

        return Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(11),
            border: Border.all(color: border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: SkeletonShimmer(
                  borderRadius: BorderRadius.circular(7),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 10,
                width: 70,
                child: SkeletonShimmer(
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 5),
              SizedBox(
                height: 9,
                width: 40,
                child: SkeletonShimmer(
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
