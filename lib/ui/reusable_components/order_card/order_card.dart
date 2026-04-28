import 'package:flutter/material.dart';

import '../../../enums/order_status.dart';
import '../../../services/theme_service.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_text_styles.dart';

/// Reusable order summary card used on the Orders screen and anywhere else
/// an order needs to be represented in a list.
class OrderCard extends StatelessWidget {
  final String orderId;
  final String date;
  final OrderStatus status;
  final int itemCount;
  final double total;

  /// Up to 3 gradient color pairs rendered as thumbnail placeholders.
  /// Each entry is [startColor, endColor].
  final List<List<Color>> thumbnailGradients;

  final VoidCallback? onTap;

  const OrderCard({
    super.key,
    required this.orderId,
    required this.date,
    required this.status,
    required this.itemCount,
    required this.total,
    required this.thumbnailGradients,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService.instance,
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;
        final accent = status.accentColor;

        final cardFill = isDark
            ? AppColors.white.withValues(alpha: 0.04)
            : AppColors.auroraPurple.withValues(alpha: 0.03);
        final cardBorder = isDark
            ? AppColors.white.withValues(alpha: 0.08)
            : AppColors.auroraPurple.withValues(alpha: 0.09);
        final dividerColor = isDark
            ? AppColors.white.withValues(alpha: 0.06)
            : AppColors.auroraPurple.withValues(alpha: 0.07);
        final orderNumColor = isDark ? AppColors.white : AppColors.auroraDeepBase;
        final dateColor = isDark
            ? AppColors.white.withValues(alpha: 0.35)
            : AppColors.auroraDeepBase.withValues(alpha: 0.35);
        final itemCountColor = isDark
            ? AppColors.white.withValues(alpha: 0.35)
            : AppColors.auroraDeepBase.withValues(alpha: 0.35);
        final totalColor = isDark ? AppColors.white : AppColors.auroraDeepBase;

        // Show max 3 thumbnails + overflow chip
        final visibleThumbs = thumbnailGradients.take(3).toList();
        final overflow = itemCount - visibleThumbs.length;

        return GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Container(
            decoration: BoxDecoration(
              color: cardFill,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: cardBorder),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    // Left accent bar
                    Container(
                      width: 3,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: accent.withValues(alpha: 0.75),
                        borderRadius: const BorderRadius.horizontal(
                          right: Radius.circular(3),
                        ),
                      ),
                    ),

                    // Card content
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(12, 11, 12, 11),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Top row: order # + status pill
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        orderId,
                                        style: AppTextStyles.dsBodyBold
                                            .copyWith(
                                          color: orderNumColor,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: -0.1,
                                          height: 1.2,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        date,
                                        style: AppTextStyles.dsMuted.copyWith(
                                          color: dateColor,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                _StatusPill(status: status),
                              ],
                            ),

                            const SizedBox(height: 10),

                            // Thumbnails row
                            Row(
                              children: [
                                ...visibleThumbs.map(
                                  (g) => Padding(
                                    padding: const EdgeInsets.only(right: 6),
                                    child: _Thumbnail(
                                      startColor: g[0],
                                      endColor: g[1],
                                    ),
                                  ),
                                ),
                                if (overflow > 0)
                                  _OverflowChip(
                                      count: overflow, isDark: isDark),
                              ],
                            ),

                            const SizedBox(height: 10),

                            // Divider
                            Container(height: 1, color: dividerColor),

                            const SizedBox(height: 9),

                            // Bottom: item count + total
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '$itemCount item${itemCount > 1 ? 's' : ''}',
                                  style: AppTextStyles.dsMuted.copyWith(
                                    color: itemCountColor,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  '\$${total.toStringAsFixed(2)}',
                                  style: AppTextStyles.dsBodyBold.copyWith(
                                    color: totalColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: -0.2,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ── Sub-widgets ───────────────────────────────────────────────────────────────

class _StatusPill extends StatelessWidget {
  final OrderStatus status;
  const _StatusPill({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = status.accentColor;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.22)),
      ),
      child: Text(
        status.label.toUpperCase(),
        style: AppTextStyles.dsCTA.copyWith(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _Thumbnail extends StatelessWidget {
  final Color startColor;
  final Color endColor;
  const _Thumbnail({required this.startColor, required this.endColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          colors: [startColor, endColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }
}

class _OverflowChip extends StatelessWidget {
  final int count;
  final bool isDark;
  const _OverflowChip({required this.count, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: isDark
            ? AppColors.white.withValues(alpha: 0.07)
            : AppColors.auroraPurple.withValues(alpha: 0.06),
        border: Border.all(
          color: isDark
              ? AppColors.white.withValues(alpha: 0.09)
              : AppColors.auroraPurple.withValues(alpha: 0.12),
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        '+$count',
        style: AppTextStyles.dsCTA.copyWith(
          color: isDark
              ? AppColors.white.withValues(alpha: 0.50)
              : AppColors.auroraDeepBase.withValues(alpha: 0.42),
          fontSize: 10,
          fontWeight: FontWeight.w800,
          letterSpacing: 0,
        ),
      ),
    );
  }
}
