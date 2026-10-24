import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../backend_integration/apis/deals_api.dart';
import '../../../../backend_integration/dependency_injection/dependency_injection.dart';
import '../../../../backend_integration/dtos/item/item_list_item_dto.dart';
import '../../../../themes/app_colors.dart';
import '../../../../themes/app_text_styles.dart';
import '../../../reusable_components/aurora/aurora_gradient_text.dart';
import '../../../reusable_components/deals/deal_countdown.dart';
import '../../../reusable_components/icons/mirrored_fa_icon.dart';
import '../../../reusable_components/product_card/product_grid_card.dart';
import '../../../reusable_components/refresh/refresh_scope.dart';

/// Items on a live deal, in a horizontal row on the home screen, with the time
/// until the soonest live deal ends. Hidden when nothing is on a live deal.
class FlashDealsSection extends StatefulWidget {
  /// Opens the Deals tab.
  final VoidCallback? onSeeAll;

  const FlashDealsSection({super.key, this.onSeeAll});

  @override
  State<FlashDealsSection> createState() => _FlashDealsSectionState();
}

class _FlashDealsSectionState extends State<FlashDealsSection>
    with AutoRefreshMixin {
  static const double _cardWidth = 140;

  List<ItemListItemDto>? _items; // null = loading
  DateTime? _endsAt;
  bool _isError = false;

  // Refetches when the soonest upcoming deal starts, so it joins the row.
  Timer? _startTimer;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  @override
  void dispose() {
    _startTimer?.cancel();
    super.dispose();
  }

  // A start that has already passed on the phone clock but not yet on the
  // server is retried after a short wait instead of in a tight loop.
  void _scheduleStartRefetch(DateTime? startsAt) {
    _startTimer?.cancel();
    if (startsAt == null) return;
    final untilStart = startsAt.difference(DateTime.now());
    final delay = untilStart > Duration.zero
        ? untilStart + const Duration(seconds: 1)
        : const Duration(seconds: 5);
    _startTimer = Timer(delay, _fetch);
  }

  Future<void> _fetch() async {
    final result = await serviceLocator<DealsApi>().getDeals();
    if (!mounted) return;
    result.fold((_) => setState(() => _isError = true), (deals) {
      final live = deals.where((d) => d.isLive).toList();
      final seen = <int>{};
      final items = [
        for (final deal in live)
          for (final item in deal.items)
            if (item.deal != null && seen.add(item.id)) item,
      ];
      final ends = live.map((d) => d.expiresAt).whereType<DateTime>().toList()
        ..sort();
      final starts = deals.where((d) => !d.isLive).map((d) => d.startsAt).toList()
        ..sort();
      _scheduleStartRefetch(starts.isEmpty ? null : starts.first);
      setState(() {
        _isError = false;
        _items = items;
        _endsAt = ends.isEmpty ? null : ends.first;
      });
    });
  }

  @override
  Future<void> onRefresh() => _fetch();

  @override
  Widget build(BuildContext context) {
    final items = _items;
    if (_isError || (items != null && items.isEmpty)) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const FaIcon(
                  FontAwesomeIcons.bolt,
                  size: 16,
                  color: AppColors.auroraPink,
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: AuroraGradientText(
                    'deals.flash_deals'.tr(),
                    style: AppTextStyles.heading3.copyWith(
                      fontWeight: FontWeight.w900,
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                DealCountdown(
                  target: _endsAt,
                  color: AppColors.auroraPink,
                  fontSize: 11,
                  onElapsed: _fetch,
                ),
                const Spacer(),
                if (widget.onSeeAll != null)
                  GestureDetector(
                    onTap: widget.onSeeAll,
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'deals.see_all'.tr(),
                            style: AppTextStyles.captionSmall.copyWith(
                              color: AppColors.auroraPink,
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const MirroredFaIcon(
                            FontAwesomeIcons.chevronRight,
                            size: 10,
                            color: AppColors.auroraPink,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: items == null
                ? const NeverScrollableScrollPhysics()
                : const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < (items?.length ?? 3); i++) ...[
                  if (i > 0) const SizedBox(width: 10),
                  SizedBox(
                    width: _cardWidth,
                    child: items == null
                        ? const ProductGridCardSkeleton()
                        : ProductGridCard(item: items[i]),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
