import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';

import '../../../backend_integration/dtos/item/item_list_item_dto.dart';
import '../../../backend_integration/dtos/item/item_tag_dto.dart';
import '../../../routes/route_constants.dart';
import '../../../services/theme_service.dart';
import '../../../services/toast_service.dart';
import '../../../services/wishlist_service.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_text_styles.dart';
import '../skeleton/skeleton_shimmer.dart';

// ─── Tag helpers ─────────────────────────────────────────────────────────────

Color _colorForTag(ItemTagDto tag) {
  final n = tag.name.toUpperCase();
  if (n.contains('VERIF')) return AppColors.verifiedGreen;
  if (n.contains('BRAND')) return AppColors.auroraElectricBlue;
  if (n.contains('EDIT')) return AppColors.auroraGold;
  if (n.contains('EXCL')) return AppColors.auroraPink;
  if (n.contains('QUAL')) return AppColors.auroraTeal;
  return switch (tag.id) {
    1 => AppColors.verifiedGreen,
    2 => AppColors.auroraElectricBlue,
    3 => AppColors.auroraGold,
    4 => AppColors.auroraPink,
    5 => AppColors.auroraTeal,
    _ => AppColors.auroraPurple,
  };
}

FaIconData _iconForTag(ItemTagDto tag) {
  final n = tag.name.toUpperCase();
  if (n.contains('VERIF')) return FontAwesomeIcons.solidCircleCheck;
  if (n.contains('BRAND')) return FontAwesomeIcons.tag;
  if (n.contains('EDIT')) return FontAwesomeIcons.solidStar;
  if (n.contains('EXCL')) return FontAwesomeIcons.gem;
  if (n.contains('QUAL')) return FontAwesomeIcons.award;
  return switch (tag.id) {
    1 => FontAwesomeIcons.solidCircleCheck,
    2 => FontAwesomeIcons.tag,
    3 => FontAwesomeIcons.solidStar,
    4 => FontAwesomeIcons.gem,
    5 => FontAwesomeIcons.award,
    _ => FontAwesomeIcons.solidCircleCheck,
  };
}

// ─── Card ────────────────────────────────────────────────────────────────────

class ProductGridCard extends StatelessWidget {
  final ItemListItemDto item;
  const ProductGridCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService.instance,
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;
        final primaryTag = item.tags.isNotEmpty ? item.tags.first : null;
        final tagColor = primaryTag != null ? _colorForTag(primaryTag) : null;

        final cardBg = isDark ? AppColors.white.withValues(alpha: 0.04) : AppColors.white;
        final shadow = isDark
            ? null
            : [BoxShadow(color: AppColors.shadowMedium, blurRadius: 8, offset: const Offset(0, 2))];
        final border = tagColor != null
            ? Border.all(color: tagColor, width: 1.5)
            : isDark
                ? Border.all(color: AppColors.white.withValues(alpha: 0.08))
                : Border.all(color: AppColors.auroraPurple.withValues(alpha: 0.10));

        return GestureDetector(
          onTap: () => Navigator.pushNamed(context, itemDetailsScreenRoute, arguments: item.id),
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
                  _ImageArea(item: item),
                  _InfoArea(item: item, isDark: isDark, primaryTagColor: tagColor),
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
  final ItemListItemDto item;
  const _ImageArea({required this.item});

  @override
  Widget build(BuildContext context) {
    final thumbnail = item.colorImages.isNotEmpty ? item.colorImages.first : null;
    final hasDiscount = item.discountedPrice != null;
    final tags = item.tags.take(3).toList();

    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (thumbnail != null)
            Image.network(
              thumbnail,
              fit: BoxFit.cover,
              loadingBuilder: (_, child, progress) =>
                  progress == null ? child : const SkeletonShimmer(),
              errorBuilder: (_, _, _) => _placeholder(),
            )
          else
            _placeholder(),
          if (tags.isNotEmpty)
            Positioned(
              bottom: 0, left: 0, right: 0,
              height: 52,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black.withValues(alpha: 0.55), Colors.transparent],
                  ),
                ),
              ),
            ),
          if (hasDiscount)
            Positioned(
              top: 8, left: 8,
              child: _PillBadge(
                '-${((1 - item.discountedPrice! / item.originalPrice) * 100).round()}%',
                AppColors.auroraRed,
              ),
            ),
          if (tags.isNotEmpty)
            Positioned(
              bottom: 6, left: 6,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var i = 0; i < tags.length; i++)
                    Padding(
                      padding: EdgeInsets.only(top: i == 0 ? 0 : 3),
                      child: _TrustTagPill(tag: tags[i]),
                    ),
                ],
              ),
            ),
          Positioned(
            top: 7, right: 7,
            child: _HeartButton(itemId: item.id),
          ),
        ],
      ),
    );
  }

  Widget _placeholder() => Container(
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
      );
}

// ─── Info area ───────────────────────────────────────────────────────────────

class _InfoArea extends StatelessWidget {
  final ItemListItemDto item;
  final bool isDark;
  final Color? primaryTagColor;
  const _InfoArea({required this.item, required this.isDark, required this.primaryTagColor});

  @override
  Widget build(BuildContext context) {
    final nameColor = isDark ? AppColors.white : AppColors.auroraDeepBase;
    final priceColor = isDark ? AppColors.auroraElectricBlue : AppColors.auroraPurple;
    final origColor = isDark
        ? AppColors.white.withValues(alpha: 0.35)
        : AppColors.auroraPurple.withValues(alpha: 0.40);
    final hasDiscount = item.discountedPrice != null;

    return Padding(
      padding: const EdgeInsets.fromLTRB(9, 8, 9, 9),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  item.title,
                  style: AppTextStyles.productName.copyWith(color: nameColor, fontSize: 11),
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
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                _fmt(hasDiscount ? item.discountedPrice! : item.originalPrice),
                style: AppTextStyles.productPrice.copyWith(color: priceColor, fontSize: 13),
              ),
              if (hasDiscount) ...[
                const SizedBox(width: 5),
                Text(
                  _fmt(item.originalPrice),
                  style: AppTextStyles.productPrice.copyWith(
                    color: origColor,
                    fontSize: 10,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  String _fmt(double p) {
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
  final ItemTagDto tag;
  const _TrustTagPill({required this.tag});

  @override
  Widget build(BuildContext context) {
    final color = _colorForTag(tag);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(_iconForTag(tag), size: 7, color: AppColors.white),
          const SizedBox(width: 4),
          Text(
            tag.name.toUpperCase(),
            style: AppTextStyles.badgeText.copyWith(
              color: AppColors.white,
              fontSize: 8,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.4,
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeartButton extends StatelessWidget {
  final int itemId;
  const _HeartButton({required this.itemId});

  static final _wishlist = GetIt.instance<WishlistService>();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _wishlist,
      builder: (context, _) {
        final active = _wishlist.isWishlisted(itemId.toString());
        return GestureDetector(
          onTap: () async {
            final msg = await _wishlist.toggle(itemId.toString());
            if (msg != null && msg.isNotEmpty) {
              ToastService.instance.showSuccess(msg);
            }
          },
          behavior: HitTestBehavior.opaque,
          child: ClipOval(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: AppColors.black.withValues(alpha: 0.28),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: FaIcon(
                    active ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart,
                    size: 13,
                    color: AppColors.auroraPink,
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

// ─── Skeleton ────────────────────────────────────────────────────────────────

// SKELETON LOCKED — appearance approved 2026-05-12. Do not modify.
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
        itemBuilder: (_, _) => const ProductGridCardSkeleton(),
      ),
    );
  }
}

class ProductGridCardSkeleton extends StatelessWidget {
  const ProductGridCardSkeleton({super.key});

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
                    SizedBox(height: 10, width: 80, child: SkeletonShimmer(borderRadius: BorderRadius.circular(2))),
                    const SizedBox(height: 4),
                    SizedBox(height: 9, width: 55, child: SkeletonShimmer(borderRadius: BorderRadius.circular(2))),
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
