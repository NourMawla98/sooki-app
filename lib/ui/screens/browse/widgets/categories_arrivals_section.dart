import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../data/mock_products.dart';
import '../../../../models/product.dart';
import '../../../../routes/route_constants.dart';
import '../../../../services/theme_service.dart';
import '../../../../themes/app_colors.dart';
import '../../../../themes/app_text_styles.dart';
import '../../../reusable_components/aurora/aurora_primary_button.dart';
import '../../../reusable_components/skeleton/skeleton_shimmer.dart';

/// Section 7 — Categories + New Arrivals.
///
/// Horizontally scrollable category pills filter a 2-column grid of the
/// latest products. Tapping a card opens item details; the pink outlined
/// CTA at the bottom routes to the full Shopping screen.
class CategoriesArrivalsSection extends StatefulWidget {
  const CategoriesArrivalsSection({super.key});

  @override
  State<CategoriesArrivalsSection> createState() =>
      _CategoriesArrivalsSectionState();
}

class _CategoriesArrivalsSectionState
    extends State<CategoriesArrivalsSection> {
  static const _categories = <String>[
    'All',
    'Dresses',
    'Tops',
    'Shoes',
    'Accessories',
  ];
  String _selectedCategory = 'All';

  List<Product> get _filteredProducts {
    final base = _selectedCategory == 'All'
        ? mockBrowseProducts
        : mockBrowseProducts
            .where((p) => p.category == _selectedCategory)
            .toList();
    return base.take(6).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: _SectionHeader(),
          ),
          const SizedBox(height: 14),
          _CategoryPills(
            categories: _categories,
            selected: _selectedCategory,
            onSelected: (cat) => setState(() => _selectedCategory = cat),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _ProductGrid(products: _filteredProducts),
          ),
        ],
      ),
    );
  }
}

// ─── Section title ────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader();

  @override
  Widget build(BuildContext context) {
    // Aurora-gradient title matching Trending Now / For You / Quick Actions
    // so all section titles read as a family.
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: AppColors.auroraCartButtonGradient,
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(bounds),
      blendMode: BlendMode.srcIn,
      child: Text(
        'New Arrivals',
        style: AppTextStyles.heading3.copyWith(
          color: AppColors.white,
          fontWeight: FontWeight.w900,
          fontSize: 20,
        ),
      ),
    );
  }
}

// ─── Category pills ───────────────────────────────────────────────────────────

class _CategoryPills extends StatelessWidget {
  final List<String> categories;
  final String selected;
  final ValueChanged<String> onSelected;

  const _CategoryPills({
    required this.categories,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService.instance,
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;
        return SizedBox(
          height: 32,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: categories.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (_, i) => _CategoryPill(
              label: categories[i],
              isSelected: categories[i] == selected,
              isDark: isDark,
              onTap: () => onSelected(categories[i]),
            ),
          ),
        );
      },
    );
  }
}

/// Category pill using the "Option F · Hollow Neon Border" treatment.
/// Unselected: transparent fill with a thin muted border.
/// Selected: 2px aurora-gradient border whose colors continuously sweep
/// around the perimeter, giving a "circumference moving" neon effect.
class _CategoryPill extends StatefulWidget {
  final String label;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  const _CategoryPill({
    required this.label,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  @override
  State<_CategoryPill> createState() => _CategoryPillState();
}

class _CategoryPillState extends State<_CategoryPill>
    with SingleTickerProviderStateMixin {
  late final AnimationController _rotator;

  @override
  void initState() {
    super.initState();
    _rotator = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    if (widget.isSelected) _rotator.repeat();
  }

  @override
  void didUpdateWidget(covariant _CategoryPill old) {
    super.didUpdateWidget(old);
    if (widget.isSelected && !_rotator.isAnimating) {
      _rotator.repeat();
    } else if (!widget.isSelected && _rotator.isAnimating) {
      _rotator.stop();
    }
  }

  @override
  void dispose() {
    _rotator.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final isSel = widget.isSelected;

    final selectedTextColor =
        isDark ? AppColors.white : AppColors.primaryPurple;
    final unselectedTextColor = isDark
        ? AppColors.white.withValues(alpha: 0.65)
        : AppColors.primaryPurple;

    // Explicit height + alignment.center + height:1.0 on text = text is
    // reliably centered both horizontally and vertically inside the pill.
    Widget buildContent({required Color color}) => Container(
          height: 32,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text(
            widget.label,
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontSize: 11,
              fontWeight: isSel ? FontWeight.w800 : FontWeight.w700,
              letterSpacing: 0.3,
              height: 1.0,
            ),
          ),
        );

    return GestureDetector(
      onTap: widget.onTap,
      child: isSel
          ? RepaintBoundary(
              child: AnimatedBuilder(
                animation: _rotator,
                builder: (context, child) => CustomPaint(
                  painter: _RotatingBorderPainter(
                    angle: _rotator.value * 2 * math.pi,
                  ),
                  child: child,
                ),
                child: buildContent(color: selectedTextColor),
              ),
            )
          : Container(
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.white.withValues(alpha: 0.04)
                    : AppColors.primaryPurple.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: isDark
                      ? AppColors.white.withValues(alpha: 0.15)
                      : AppColors.primaryPurple.withValues(alpha: 0.35),
                ),
              ),
              child: buildContent(color: unselectedTextColor),
            ),
    );
  }
}

/// Minimalistic skeleton placeholder for the arrivals grid. Renders 6
/// shimmer cards in the same 2-column layout and aspect ratio as
/// [_ArrivalCard], with just a square thumb stub and two short text bars —
/// enough to communicate "product cards are loading" without faking detail.
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

/// Paints a rounded-rect outline using a [SweepGradient] whose rotation is
/// driven by [angle]. Animating `angle` from 0 → 2π on repeat makes the
/// gradient colors appear to travel around the perimeter.
class _RotatingBorderPainter extends CustomPainter {
  final double angle;
  static const double _borderRadius = 6;
  static const double _strokeWidth = 2;

  _RotatingBorderPainter({required this.angle});

  @override
  void paint(Canvas canvas, Size size) {
    // Inset by half the stroke so the stroke doesn't clip the edges.
    const inset = _strokeWidth / 2;
    final rect = Rect.fromLTWH(
      inset,
      inset,
      size.width - inset * 2,
      size.height - inset * 2,
    );
    final rrect = RRect.fromRectAndRadius(
      rect,
      const Radius.circular(_borderRadius),
    );

    final shader = SweepGradient(
      colors: const [
        AppColors.auroraPink,
        AppColors.auroraPurple,
        AppColors.auroraElectricBlue,
        AppColors.auroraPurple,
        AppColors.auroraPink,
      ],
      stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
      transform: GradientRotation(angle),
    ).createShader(rect);

    final paint = Paint()
      ..shader = shader
      ..style = PaintingStyle.stroke
      ..strokeWidth = _strokeWidth;

    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(_RotatingBorderPainter old) => old.angle != angle;
}

// ─── Product grid ─────────────────────────────────────────────────────────────

class _ProductGrid extends StatelessWidget {
  final List<Product> products;
  const _ProductGrid({required this.products});

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return ListenableBuilder(
        listenable: ThemeService.instance,
        builder: (context, _) {
          final isDark = ThemeService.instance.isDarkMode;
          final emptyText = isDark
              ? AppColors.white.withValues(alpha: 0.6)
              : AppColors.primaryPurple.withValues(alpha: 0.7);
          return SizedBox(
            height: 180,
            child: Center(
              child: Text(
                'No items in this category yet',
                style: AppTextStyles.caption.copyWith(color: emptyText),
              ),
            ),
          );
        },
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.72,
      ),
      itemCount: products.length,
      itemBuilder: (_, i) => _ArrivalCard(product: products[i]),
    );
  }
}

// ─── Arrival card ─────────────────────────────────────────────────────────────

class _ArrivalCard extends StatefulWidget {
  final Product product;
  const _ArrivalCard({required this.product});

  @override
  State<_ArrivalCard> createState() => _ArrivalCardState();
}

class _ArrivalCardState extends State<_ArrivalCard> {
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
                // Non-thumb area fills the remaining vertical space and
                // distributes it: name/price sit at the top of that area,
                // cart button anchors to the bottom, remaining gap breathes
                // in between.
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

