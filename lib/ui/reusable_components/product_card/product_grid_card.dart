import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';

import '../../../models/product.dart';
import '../../../routes/route_constants.dart';
import '../../../services/theme_service.dart';
import '../../../services/wishlist_service.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_text_styles.dart';
import '../rating_stars/star_rating.dart';
import '../skeleton/skeleton_shimmer.dart';

// ─── Trust tag descriptor ────────────────────────────────────────────────────

class _Tag {
  final String label;
  final Color color;
  final FaIconData icon;
  const _Tag(this.label, this.color, this.icon);
}

List<_Tag> _tagsFor(Product p) {
  return [
    if (p.isVerified)
      const _Tag('VERIFIED', AppColors.verifiedGreen, FontAwesomeIcons.solidCircleCheck),
    if (p.isBrand)
      const _Tag('BRAND', AppColors.auroraElectricBlue, FontAwesomeIcons.tag),
    if (p.isEditorsPick)
      const _Tag("EDITOR'S PICK", AppColors.auroraGold, FontAwesomeIcons.solidStar),
    if (p.isPlatformExclusive)
      const _Tag('EXCLUSIVE', AppColors.auroraPink, FontAwesomeIcons.gem),
    if (p.isQualityChecked)
      const _Tag('QUALITY', AppColors.auroraTeal, FontAwesomeIcons.award),
  ];
}

// Primary tag color drives card border + inline checkmark.
// Priority: Verified > Brand > Editor's Pick > Exclusive > Quality.
Color? _primaryTagColor(Product p) => _tagsFor(p).firstOrNull?.color;

// ─── Card ────────────────────────────────────────────────────────────────────

class ProductGridCard extends StatelessWidget {
  final Product product;
  const ProductGridCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService.instance,
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;
        final tagColor = _primaryTagColor(product);

        final cardBg = isDark
            ? AppColors.white.withValues(alpha: 0.04)
            : AppColors.white;
        final shadow = isDark
            ? null
            : [BoxShadow(color: AppColors.shadowMedium, blurRadius: 8, offset: const Offset(0, 2))];
        final border = tagColor != null
            ? Border.all(color: tagColor, width: 1.5)
            : isDark
                ? Border.all(color: AppColors.white.withValues(alpha: 0.08))
                : Border.all(color: AppColors.auroraPurple.withValues(alpha: 0.10));

        return GestureDetector(
          onTap: () => Navigator.pushNamed(context, itemDetailsScreenRoute, arguments: product),
          child: Container(
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(12),
              border: border,
              boxShadow: shadow,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(11),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _ImageArea(product: product, isDark: isDark),
                  _InfoArea(product: product, isDark: isDark, primaryTagColor: tagColor),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ─── Image area ──────────────────────────────────────────────────────────────

class _ImageArea extends StatelessWidget {
  final Product product;
  final bool isDark;
  const _ImageArea({required this.product, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final tags = _tagsFor(product);
    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            product.thumbnailUrl,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.auroraPurple.withValues(alpha: 0.35),
                    AppColors.auroraPink.withValues(alpha: 0.20),
                  ],
                ),
              ),
            ),
          ),
          // Top-left: discount badge takes priority over NEW
          if (product.discountPercentage != null)
            Positioned(
              top: 8, left: 8,
              child: _PillBadge('-${product.discountPercentage}%', AppColors.auroraRed),
            )
          else if (product.isNew)
            Positioned(
              top: 8, left: 8,
              child: _PillBadge('NEW', AppColors.verifiedGreen),
            ),
          // Bottom-left: trust tag pills
          if (tags.isNotEmpty)
            Positioned(
              bottom: 7, left: 7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: tags.map((t) => Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: _TrustTagPill(tag: t),
                )).toList(),
              ),
            ),
          // Top-right: heart
          Positioned(
            top: 7, right: 7,
            child: _HeartButton(productId: product.id),
          ),
        ],
      ),
    );
  }
}

// ─── Info area ───────────────────────────────────────────────────────────────

class _InfoArea extends StatelessWidget {
  final Product product;
  final bool isDark;
  final Color? primaryTagColor;
  const _InfoArea({required this.product, required this.isDark, required this.primaryTagColor});

  @override
  Widget build(BuildContext context) {
    final nameColor = isDark ? AppColors.white : AppColors.auroraDeepBase;
    final priceColor = isDark ? AppColors.auroraElectricBlue : AppColors.auroraPurple;
    final origColor = isDark
        ? AppColors.white.withValues(alpha: 0.35)
        : AppColors.auroraPurple.withValues(alpha: 0.40);

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 7, 8, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          StarRating(rating: product.rating, size: 11, showValue: false),
          const SizedBox(height: 3),
          Row(
            children: [
              Expanded(
                child: Text(
                  product.name,
                  style: AppTextStyles.productName.copyWith(
                    color: nameColor,
                    fontSize: 11,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (primaryTagColor != null) ...[
                const SizedBox(width: 3),
                FaIcon(FontAwesomeIcons.solidCircleCheck, size: 11, color: primaryTagColor),
              ],
            ],
          ),
          const SizedBox(height: 3),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                _formatPrice(product.price),
                style: AppTextStyles.productPrice.copyWith(
                  color: priceColor,
                  fontSize: 12,
                ),
              ),
              if (product.originalPrice != null) ...[
                const SizedBox(width: 5),
                Text(
                  _formatPrice(product.originalPrice!),
                  style: AppTextStyles.productPrice.copyWith(
                    color: origColor,
                    fontSize: 10,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
            ],
          ),
          if (product.stockCount > 0 && product.stockCount <= 10) ...[
            const SizedBox(height: 2),
            Text(
              '${product.stockCount} left',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.verifiedGreen,
                fontSize: 9,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatPrice(double p) {
    final hasDecimals = p.truncateToDouble() != p;
    return '\$${p.toStringAsFixed(hasDecimals ? 2 : 0)}';
  }
}

// ─── Sub-widgets ─────────────────────────────────────────────────────────────

class _PillBadge extends StatelessWidget {
  final String text;
  final Color color;
  const _PillBadge(this.text, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
      child: Text(
        text,
        style: AppTextStyles.badgeText.copyWith(
          color: AppColors.white,
          fontSize: 9,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.3,
          height: 1.0,
        ),
      ),
    );
  }
}

class _TrustTagPill extends StatelessWidget {
  final _Tag tag;
  const _TrustTagPill({required this.tag});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(color: tag.color, borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(tag.icon, size: 8, color: AppColors.white),
          const SizedBox(width: 4),
          Text(
            tag.label,
            style: AppTextStyles.badgeText.copyWith(
              color: AppColors.white,
              fontSize: 8,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.3,
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeartButton extends StatelessWidget {
  final String productId;
  const _HeartButton({required this.productId});

  static final _wishlist = GetIt.instance<WishlistService>();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _wishlist,
      builder: (context, _) {
        final active = _wishlist.isWishlisted(productId);
        return GestureDetector(
          onTap: () => _wishlist.toggle(productId),
          behavior: HitTestBehavior.opaque,
          child: SizedBox(
            width: 28,
            height: 28,
            child: Center(
              child: FaIcon(
                active ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart,
                size: 15,
                color: AppColors.auroraPink,
              ),
            ),
          ),
        );
      },
    );
  }
}

// ─── Skeleton ────────────────────────────────────────────────────────────────

class ProductGridSkeleton extends StatelessWidget {
  const ProductGridSkeleton({super.key});

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
          childAspectRatio: 0.70,
        ),
        itemCount: 6,
        itemBuilder: (_, _) => const _ProductGridCardSkeleton(),
      ),
    );
  }
}

class _ProductGridCardSkeleton extends StatelessWidget {
  const _ProductGridCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService.instance,
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;
        final border = isDark
            ? AppColors.white.withValues(alpha: 0.08)
            : AppColors.auroraPurple.withValues(alpha: 0.10);
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(aspectRatio: 1, child: SkeletonShimmer(borderRadius: BorderRadius.circular(11))),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 7, 8, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 9, width: 50, child: SkeletonShimmer(borderRadius: BorderRadius.circular(2))),
                    const SizedBox(height: 5),
                    SizedBox(height: 10, width: 80, child: SkeletonShimmer(borderRadius: BorderRadius.circular(2))),
                    const SizedBox(height: 5),
                    SizedBox(height: 10, width: 45, child: SkeletonShimmer(borderRadius: BorderRadius.circular(2))),
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
