import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../backend_integration/dtos/order/order_list_item_dto.dart';
import '../../../enums/order_status.dart';
import '../../../services/theme_service.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_text_styles.dart';
import '../../../utils/date_localization.dart';
import '../../../utils/number_localization.dart';
import '../product_thumb.dart';

class OrderCard extends StatelessWidget {
  final OrderListItemDto dto;
  final VoidCallback? onTap;

  const OrderCard({
    super.key,
    required this.dto,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService.instance,
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;
        final status = OrderStatus.fromInt(dto.status);
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

        final visibleItems = dto.items.take(3).toList();
        final overflow = dto.items.length - visibleItems.length;
        // Quantities, not rows, so the card agrees with the cart badge and the
        // order detail. Two of one shirt is two items to the shopper.
        final unitCount = dto.items.fold<int>(0, (sum, i) => sum + i.quantity);
        final date = localizedLongDate(dto.createdAt);

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
                    // Leading accent bar
                    Container(
                      width: 3,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: accent.withValues(alpha: 0.75),
                        borderRadius: const BorderRadiusDirectional.horizontal(
                          end: Radius.circular(3),
                        ),
                      ),
                    ),

                    // Card content
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(12, 11, 12, 11),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Top row: tracking number + status pill
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Tracking number keeps Western digits:
                                      // it is an identifier the shopper reads
                                      // back to support.
                                      Text(
                                        dto.trackingNumber,
                                        style: AppTextStyles.dsBodyBold.copyWith(
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
                                ...visibleItems.asMap().entries.map(
                                  (e) => Padding(
                                    padding: const EdgeInsetsDirectional.only(end: 6),
                                    child: ProductThumb(
                                      url: e.value.imageUrl,
                                      size: 40,
                                      isDark: isDark,
                                    ),
                                  ),
                                ),
                                if (overflow > 0)
                                  _OverflowChip(count: overflow, isDark: isDark),
                              ],
                            ),

                            const SizedBox(height: 10),

                            Container(height: 1, color: dividerColor),

                            const SizedBox(height: 9),

                            // Bottom: item count + total
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'order_card.item_count'.plural(
                                    unitCount,
                                    args: [localizedNumber(unitCount)],
                                  ),
                                  style: AppTextStyles.dsMuted.copyWith(
                                    color: itemCountColor,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  '\$${localizedPrice(dto.totalAmount)}',
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
        '+${localizedNumber(count)}',
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
