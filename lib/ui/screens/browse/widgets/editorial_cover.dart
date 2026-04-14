import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../routes/route_constants.dart';
import '../../../../themes/app_colors.dart';
import '../../../../themes/app_fonts.dart';
import '../../../../themes/app_text_styles.dart';
import '../../../reusable_components/skeleton/skeleton_shimmer.dart';

/// Section 4 — Editorial Cover.
///
/// Full-bleed 280 px editorial card with a moody photo background, a Playfair
/// italic headline, and a white CTA chip. Taps route to the item-details stub.
class EditorialCover extends StatelessWidget {
  final String imageUrl;
  final String kicker;
  final String title;
  final String ctaLabel;
  final String ctaRoute;
  final String numberStamp;

  const EditorialCover({
    super.key,
    this.imageUrl =
        'https://images.unsplash.com/photo-1490481651871-ab68de25d43d?w=900&h=1200&fit=crop',
    this.kicker = "TONIGHT'S EDIT",
    this.title = 'Your shopping,\nafter dark.',
    this.ctaLabel = 'EXPLORE',
    this.ctaRoute = itemDetailsScreenRoute,
    this.numberStamp = '04',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(context, ctaRoute),
        behavior: HitTestBehavior.opaque,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: SizedBox(
            height: 280,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Background image with skeleton + fallback
                Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (_, child, progress) =>
                      progress == null ? child : const SkeletonShimmer(),
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

                // Dark gradient overlay for legibility
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [0.0, 0.5, 1.0],
                      colors: [
                        AppColors.auroraDeepBase.withValues(alpha: 0.35),
                        AppColors.auroraDeepBase.withValues(alpha: 0.7),
                        AppColors.auroraDeepBase.withValues(alpha: 0.95),
                      ],
                    ),
                  ),
                ),

                // Pink radial glow top-right
                Positioned(
                  top: 10,
                  right: 10,
                  child: IgnorePointer(
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            AppColors.auroraPink.withValues(alpha: 0.45),
                            AppColors.auroraPink.withValues(alpha: 0.0),
                          ],
                          stops: const [0.0, 0.7],
                        ),
                      ),
                    ),
                  ),
                ),

                // Giant italic number top-left
                Positioned(
                  top: 10,
                  left: 20,
                  child: Text(
                    numberStamp,
                    style: AppFonts.editorial(
                      fontSize: 72,
                      fontWeight: FontWeight.w900,
                      fontStyle: FontStyle.italic,
                      color: AppColors.white.withValues(alpha: 0.10),
                      height: 1.0,
                    ),
                  ),
                ),

                // Bottom-left content stack
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        kicker,
                        style: AppTextStyles.editorialKicker.copyWith(
                          fontSize: 10,
                          letterSpacing: 2.8,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        title,
                        style: AppTextStyles.editorialTitle.copyWith(
                          fontSize: 28,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 14),
                      _ExploreCta(label: ctaLabel),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Placeholder shown while the editorial cover is loading. Mirrors the card's
/// 280 px frame with shimmer bars where the kicker, headline, and CTA would
/// sit.
class EditorialCoverSkeleton extends StatelessWidget {
  const EditorialCoverSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: SizedBox(
          height: 280,
          width: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            children: [
              const SkeletonShimmer(),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 90,
                      height: 10,
                      child: SkeletonShimmer(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 24,
                      child: SkeletonShimmer(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: 180,
                      height: 24,
                      child: SkeletonShimmer(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: 110,
                      height: 34,
                      child: SkeletonShimmer(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExploreCta extends StatelessWidget {
  final String label;
  const _ExploreCta({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: AppTextStyles.buttonSmall.copyWith(
              color: AppColors.auroraDeepBase,
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
              height: 1.0,
            ),
          ),
          const SizedBox(width: 8),
          const FaIcon(
            FontAwesomeIcons.arrowRight,
            size: 11,
            color: AppColors.auroraDeepBase,
          ),
        ],
      ),
    );
  }
}
