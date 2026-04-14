import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../data/mock_products.dart';
import '../../../../models/product.dart';
import '../../../../routes/route_constants.dart';
import '../../../../services/theme_service.dart';
import '../../../../themes/app_colors.dart';
import '../../../../themes/app_text_styles.dart';
import '../../../reusable_components/skeleton/skeleton_shimmer.dart';

/// Section 5 — For You Deck.
///
/// Single AI-picked product card that cross-fades to the next pick every
/// [rotationInterval]. Tap the card → Item Details. The "+ Add" chip is
/// inert for now (wires to cart once the API lands).
class ForYouDeck extends StatefulWidget {
  final List<Product> picks;
  final Duration rotationInterval;

  const ForYouDeck({
    super.key,
    this.picks = const [],
    this.rotationInterval = const Duration(milliseconds: 4500),
  });

  @override
  State<ForYouDeck> createState() => _ForYouDeckState();
}

class _ForYouDeckState extends State<ForYouDeck> {
  late final List<Product> _picks;
  int _index = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _picks = widget.picks.isEmpty
        ? mockBrowseProducts.skip(6).take(4).toList()
        : widget.picks;
    if (_picks.length > 1) {
      _timer = Timer.periodic(widget.rotationInterval, (_) {
        if (!mounted) return;
        setState(() => _index = (_index + 1) % _picks.length);
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_picks.isEmpty) {
      return const ForYouDeckSkeleton();
    }
    final product = _picks[_index];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: ListenableBuilder(
        listenable: ThemeService.instance,
        builder: (context, _) {
          final isDark = ThemeService.instance.isDarkMode;
          final cardBg = isDark
              ? AppColors.white.withValues(alpha: 0.04)
              : AppColors.white;
          final borderColor = isDark
              ? AppColors.white.withValues(alpha: 0.08)
              : AppColors.auroraPurple.withValues(alpha: 0.18);
          final nameColor = isDark
              ? AppColors.white
              : AppColors.primaryPurple;
          final priceColor = isDark
              ? AppColors.white
              : AppColors.primaryPurple;

          return Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(18),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () => Navigator.pushNamed(
                context,
                itemDetailsScreenRoute,
                arguments: product,
              ),
              child: Container(
                height: 230,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: borderColor),
                ),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 14),
                        Expanded(
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 450),
                            switchInCurve: Curves.easeOutCubic,
                            switchOutCurve: Curves.easeInCubic,
                            child: _DeckBody(
                              key: ValueKey(product.id),
                              product: product,
                              nameColor: nameColor,
                              priceColor: priceColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Positioned(top: 0, right: 0, child: _AiPickedPill()),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _DeckBody extends StatelessWidget {
  final Product product;
  final Color nameColor;
  final Color priceColor;

  const _DeckBody({
    super.key,
    required this.product,
    required this.nameColor,
    required this.priceColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          height: 110,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: AppColors.gray100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Image.asset(
            product.thumbnailUrl,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: AppColors.auroraCartButtonGradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          product.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.bodyMedium.copyWith(
            color: nameColor,
            fontSize: 14,
            fontWeight: FontWeight.w700,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: AppTextStyles.auroraMonoPrice.copyWith(
                color: priceColor,
                fontSize: 15,
                fontWeight: FontWeight.w800,
                height: 1.0,
              ),
            ),
            const _AddChip(),
          ],
        ),
      ],
    );
  }
}

class _AiPickedPill extends StatelessWidget {
  const _AiPickedPill();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.auroraElectricBlue.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: AppColors.auroraElectricBlue.withValues(alpha: 0.4),
        ),
      ),
      child: Text(
        'AI PICKED',
        style: AppTextStyles.captionSmall.copyWith(
          color: AppColors.auroraElectricBlue,
          fontSize: 9,
          fontWeight: FontWeight.w800,
          letterSpacing: 2.5,
          height: 1.0,
        ),
      ),
    );
  }
}

class _AddChip extends StatelessWidget {
  const _AddChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: AppColors.auroraCartButtonGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: AppColors.auroraPink.withValues(alpha: 0.3),
            blurRadius: 8,
          ),
        ],
      ),
      child: Text(
        '+ Add',
        style: AppTextStyles.captionSmall.copyWith(
          color: AppColors.white,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          height: 1.0,
        ),
      ),
    );
  }
}

/// Placeholder shown while the For You pick is loading.
class ForYouDeckSkeleton extends StatelessWidget {
  const ForYouDeckSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService.instance,
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;
        final cardBg = isDark
            ? AppColors.white.withValues(alpha: 0.04)
            : AppColors.white;
        final borderColor = isDark
            ? AppColors.white.withValues(alpha: 0.08)
            : AppColors.auroraPurple.withValues(alpha: 0.15);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Container(
            height: 230,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: 70,
                    height: 16,
                    child: SkeletonShimmer(
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  height: 110,
                  child: SkeletonShimmer(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: 140,
                  height: 14,
                  child: SkeletonShimmer(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 60,
                      height: 15,
                      child: SkeletonShimmer(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    SizedBox(
                      width: 54,
                      height: 22,
                      child: SkeletonShimmer(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
