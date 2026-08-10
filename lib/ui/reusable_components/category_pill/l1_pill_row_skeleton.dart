import 'package:flutter/material.dart';

import '../skeleton/skeleton_shimmer.dart';

/// Shimmer placeholder for the Shopping screen's L1 category-pill row.
///
/// Renders four pill-shaped shimmer blocks with varied widths so the row
/// reads as "real content is about to appear here" rather than "I am a
/// row of identical chips." Widths match the footprint of real L1 labels
/// (Women, Men, Electronics, Sale) to keep the layout stable once the
/// taxonomy resolves.
///
/// L2 and L3 rows are not rendered during taxonomy loading. They can't
/// exist without a selected L1 parent, so we leave their space to the grid
/// skeleton below.
class L1PillRowSkeleton extends StatelessWidget {
  const L1PillRowSkeleton({super.key});

  static const _widths = <double>[78, 54, 105, 62];
  static const _pillHeight = 32.0;
  static const _pillRadius = 6.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _pillHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _widths.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (_, i) => SizedBox(
          width: _widths[i],
          height: _pillHeight,
          child: SkeletonShimmer(
            borderRadius: BorderRadius.circular(_pillRadius),
          ),
        ),
      ),
    );
  }
}
