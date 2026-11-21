import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../backend_integration/apis/deals_api.dart';
import '../../../backend_integration/apis/items_api.dart';
import '../../../backend_integration/apis/notification_preferences_api.dart';
import '../../../backend_integration/dependency_injection/dependency_injection.dart';
import '../../../backend_integration/dio/client/request_executor.dart';
import '../../../backend_integration/dtos/deal/customer_deal_dto.dart';
import '../../../backend_integration/dtos/item/trending_item_dto.dart';
import '../../../backend_integration/dtos/notification/notification_preferences_dto.dart';
import '../../../enums/deal_type.dart';
import '../../../models/deal_progress.dart';
import '../../../services/app_reload_signal.dart';
import '../../../services/auth_service.dart';
import '../../../services/cart_service.dart';
import '../../../services/theme_service.dart';
import '../../../services/toast_service.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_text_styles.dart';
import '../../reusable_components/aurora/aurora_primary_button.dart';
import '../../reusable_components/icons/mirrored_fa_icon.dart';
import '../../reusable_components/product_card/product_grid_card.dart';
import '../../reusable_components/skeleton/skeleton_shimmer.dart';
import '../cart/widgets/aurora_login_gate_dialog.dart';
import '../splash/widgets/aurora_glow_blob.dart';
import 'widgets/bundle_deal_card.dart';
import 'widgets/deals_empty_state.dart';
import 'widgets/deals_hero.dart';
import 'widgets/deals_sections.dart';
import 'widgets/free_gift_deal_card.dart';
import 'widgets/multi_buy_deal_card.dart';
import 'widgets/spend_save_card.dart';

/// The Deals tab: a hero with the soonest deal end, filter chips per deal
/// type, the fixed price items ending soonest, then one card per deal, live
/// first and upcoming after. Cards act on the real cart, so the cart is loaded
/// alongside the deals and refreshed with them.
class DealsScreen extends StatefulWidget {
  /// Whether the Deals tab is the one on screen. The tab shell keeps every tab
  /// mounted, so this is how the screen learns it has regained focus.
  final bool isActive;

  /// Opens the shop from the empty state.
  final VoidCallback? onBrowseShop;

  /// The filter to open on, when another screen asks for one deal type.
  final DealFilter? initialFilter;

  /// Pushed as its own route rather than shown as a tab: it gets a back bar
  /// and its own background, and back returns to the screen that opened it.
  final bool standalone;

  const DealsScreen({
    super.key,
    this.isActive = true,
    this.onBrowseShop,
    this.initialFilter,
    this.standalone = false,
  });

  @override
  State<DealsScreen> createState() => _DealsScreenState();
}

class _DealsScreenState extends State<DealsScreen> {
  final _dealsApi = serviceLocator<DealsApi>();
  final _cart = serviceLocator<CartService>();
  final _gridKey = GlobalKey();

  List<CustomerDealDto>? _deals; // null = first load in progress
  bool _hasError = false;

  // The deals could not load because the shopper is a guest or their session
  // ended; they get the sign in view rather than an error.
  bool _needsSignIn = false;
  bool _isFetching = false;

  // Only loaded when there are no deals, for the empty state.
  List<TrendingItemDto> _trending = const [];
  NotificationPreferencesDto? _alertPrefs;
  bool _alertsBusy = false;

  DealFilter _filter = DealFilter.all;

  @override
  void initState() {
    super.initState();
    _filter = widget.initialFilter ?? DealFilter.all;
    AppReloadSignal.instance.addListener(_reload);
    unawaited(_load());
  }

  void _reload() => unawaited(_load());

  @override
  void dispose() {
    AppReloadSignal.instance.removeListener(_reload);
    super.dispose();
  }

  @override
  void didUpdateWidget(DealsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Deals start and end all the time, so the list loaded when the app opened
    // goes stale; coming back to the tab reads it again.
    if (widget.isActive && !oldWidget.isActive) unawaited(_load());
  }

  /// Everything the screen shows from the network. Entry, pull to refresh,
  /// tab focus and a countdown reaching zero all come through here.
  Future<void> _load() async {
    if (_isFetching) return;
    _isFetching = true;
    final cartLoad = _cart.loadFromServer();
    final isCustomer = serviceLocator<AuthService>().isCustomer;
    final result = await _dealsApi.getDeals(silent: !isCustomer);
    await cartLoad;
    _isFetching = false;
    if (!mounted) return;
    final deals = result.fold((_) => null, (d) => d);
    if (deals == null) {
      final failure = result.fold((f) => f, (_) => null);
      final signIn = !isCustomer || (failure != null && isAuthFailure(failure));
      setState(() {
        _needsSignIn = signIn && _deals == null;
        _hasError = !_needsSignIn && _deals == null;
      });
      return;
    }
    setState(() {
      _deals = deals;
      _hasError = false;
      _needsSignIn = false;
    });
    if (_isEmpty(deals)) await Future.wait([_loadTrending(), _loadAlerts()]);
  }

  bool _isEmpty(List<CustomerDealDto> deals) =>
      dealsForFilter(deals, DealFilter.all).isEmpty && _cart.spendDeal == null;

  Future<void> _loadTrending() async {
    final result = await serviceLocator<ItemsApi>().getTrendingItems();
    if (!mounted) return;
    result.fold((_) {}, (items) => setState(() => _trending = items));
  }

  Future<void> _loadAlerts() async {
    if (!serviceLocator<AuthService>().isCustomer) return;
    final result = await serviceLocator<NotificationPreferencesApi>()
        .getPreferences();
    if (!mounted) return;
    result.fold((_) {}, (prefs) => setState(() => _alertPrefs = prefs));
  }

  Future<void> _retry() async {
    setState(() => _hasError = false);
    await _load();
  }

  Future<void> _turnOnAlerts() async {
    if (!serviceLocator<AuthService>().isCustomer) {
      await showAuroraLoginGate(context);
      return;
    }
    final current = _alertPrefs;
    setState(() => _alertsBusy = true);
    final next = NotificationPreferencesDto(
      pushNotificationsEnabled: true,
      emailNotificationsEnabled: current?.emailNotificationsEnabled ?? false,
    );
    final result = await serviceLocator<NotificationPreferencesApi>()
        .updatePreferences(next);
    if (!mounted) return;
    setState(() => _alertsBusy = false);
    result.fold((_) {}, (message) {
      setState(() => _alertPrefs = next);
      if (message.isNotEmpty) ToastService.instance.showSuccess(message);
    });
  }

  void _scrollToDeals() {
    final target = _gridKey.currentContext;
    if (target == null) return;
    Scrollable.ensureVisible(
      target,
      duration: MediaQuery.disableAnimationsOf(context)
          ? Duration.zero
          : const Duration(milliseconds: 450),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([ThemeService.instance, _cart]),
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;

        final background = isDark
            ? (widget.standalone
                  ? AppColors.auroraDeepBase
                  : Colors.transparent)
            : AppColors.white;
        final body = Stack(
          children: [
            AuroraGlowBlob(
              top: -60,
              right: -60,
              size: 280,
              color: AppColors.auroraPurple,
              intensity: isDark ? 0.18 : 0.09,
            ),
            AuroraGlowBlob(
              bottom: 60,
              left: -60,
              size: 280,
              color: AppColors.auroraElectricBlue,
              intensity: isDark ? 0.16 : 0.08,
            ),
            RefreshIndicator(
              onRefresh: _load,
              color: AppColors.auroraPink,
              child: _buildBody(isDark),
            ),
          ],
        );

        return Scaffold(
          backgroundColor: background,
          body: widget.standalone
              ? SafeArea(
                  child: Column(
                    children: [
                      _BackBar(isDark: isDark),
                      Expanded(child: body),
                    ],
                  ),
                )
              : body,
        );
      },
    );
  }

  Widget _buildBody(bool isDark) {
    final deals = _deals;
    if (_needsSignIn) {
      return _FullHeightMessage(
        isDark: isDark,
        icon: FontAwesomeIcons.userLock,
        title: 'deals.guest_title'.tr(),
        subtitle: 'deals.guest_subtitle'.tr(),
        actionLabel: 'deals.guest_sign_in'.tr(),
        onAction: () => showAuroraLoginGate(context),
      );
    }
    if (_hasError) {
      return _FullHeightMessage(
        isDark: isDark,
        icon: FontAwesomeIcons.circleExclamation,
        title: 'deals.error_title'.tr(),
        subtitle: 'deals.tap_to_retry'.tr(),
        onTap: _retry,
      );
    }
    if (deals == null) return const _DealsSkeleton();
    if (_isEmpty(deals)) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 100),
        children: [
          DealsEmptyState(
            isDark: isDark,
            trending: _trending,
            alertsOn: _alertPrefs?.pushNotificationsEnabled,
            alertsBusy: _alertsBusy,
            onNotify: _turnOnAlerts,
            onBrowse:
                widget.onBrowseShop ?? () => Navigator.of(context).maybePop(),
          ),
        ],
      );
    }

    final spendDeal = _cart.spendDeal;
    final counts = dealFilterCounts(deals, hasSpendDeal: spendDeal != null);
    final shown = dealsForFilter(deals, _filter);
    final live = shown.where((d) => d.isLive).toList();
    final upcoming = shown.where((d) => !d.isLive).toList();
    final showSpend =
        spendDeal != null &&
        (_filter == DealFilter.all || _filter == DealFilter.spendThreshold);
    final showEndingSoon =
        _filter == DealFilter.all || _filter == DealFilter.singleItem;
    final endingSoon = showEndingSoon
        ? endingSoonEntries(deals)
        : const <EndingSoonEntry>[];
    final liveCount = deals.where((d) => d.isLive).length;
    final (filterKey, filterIcon) = dealFilterLabel(_filter);

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(top: 14, bottom: 100),
      children: [
        if (liveCount > 0)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
            child: DealsHero(
              liveCount: liveCount,
              endsAt: soonestLiveEnd(deals),
              onShop: _scrollToDeals,
              onElapsed: _load,
            ),
          ),
        DealFilterChips(
          selected: _filter,
          counts: counts,
          isDark: isDark,
          onSelected: (f) => setState(() => _filter = f),
        ),
        const SizedBox(height: 8),
        if (endingSoon.isNotEmpty) ...[
          DealSectionHead(
            title: 'deals.ending_soon'.tr(),
            icon: FontAwesomeIcons.fire,
            isDark: isDark,
            flicker: true,
            actionLabel: _filter == DealFilter.all
                ? 'deals.see_all'.tr()
                : null,
            onAction: () => setState(() => _filter = DealFilter.singleItem),
          ),
          EndingSoonRow(
            entries: endingSoon,
            quantityOf: _cart.quantityOfItem,
            isTakenByOtherDeal: (item) =>
                _cart.isItemTakenByOtherDeal(item.id, item.deal?.dealId ?? -1),
          ),
        ],
        DealSectionHead(
          key: _gridKey,
          title: _filter == DealFilter.all
              ? 'deals.all_deals'.tr()
              : filterKey.tr(),
          icon: _filter == DealFilter.all ? FontAwesomeIcons.bolt : filterIcon,
          isDark: isDark,
        ),
        if (showSpend)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: SpendSaveCard(spendDeal: spendDeal, isDark: isDark),
          ),
        ..._dealCards(live, isDark),
        if (upcoming.isNotEmpty) ...[
          DealSectionHead(
            title: 'deals.coming_up'.tr(),
            icon: FontAwesomeIcons.hourglassHalf,
            isDark: isDark,
          ),
          ..._dealCards(upcoming, isDark),
        ],
        if (live.isEmpty && upcoming.isEmpty && !showSpend)
          DealsFilterEmpty(
            filter: _filter,
            isDark: isDark,
            onSeeAll: () => setState(() => _filter = DealFilter.all),
          ),
      ],
    );
  }

  /// Fixed price items sit two to a row as the shared product card, like
  /// Browse; every other deal takes a full row.
  List<Widget> _dealCards(List<CustomerDealDto> deals, bool isDark) {
    final rows = <Widget>[];
    final pending = <Widget>[];

    void flush() {
      for (var i = 0; i < pending.length; i += 2) {
        rows.add(
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: pending[i]),
                const SizedBox(width: 12),
                Expanded(
                  child: i + 1 < pending.length
                      ? pending[i + 1]
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        );
      }
      pending.clear();
    }

    for (final deal in deals) {
      if (deal.dealType == DealType.singleItem) {
        for (final item in deal.items) {
          pending.add(
            ProductGridCard(
              key: ValueKey('single:${deal.id}:${item.id}'),
              item: item,
              inCartQuantity: _cart.quantityOfItem(item.id),
              dealOverridden: _cart.isItemTakenByOtherDeal(
                item.id,
                item.deal?.dealId ?? deal.id,
              ),
            ),
          );
        }
        continue;
      }
      flush();
      final wide = _wideCard(deal, isDark);
      if (wide != null) {
        rows.add(
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: wide,
          ),
        );
      }
    }
    flush();
    return rows;
  }

  /// The card for a bundle, multi-buy or free gift deal. Cards only read the
  /// cart; items go into it from the item screen.
  Widget? _wideCard(CustomerDealDto deal, bool isDark) {
    final key = ValueKey('deal:${deal.id}');
    switch (deal.dealType) {
      case DealType.bundle:
        return BundleDealCard(
          key: key,
          deal: deal,
          isDark: isDark,
          quantityOf: _cart.quantityOfItem,
          status: _statusOf(
            deal,
            DealLinesProgress.of(deal, _cart.quantityOfItem).complete,
          ),
          onElapsed: _load,
        );
      case DealType.multiBuy:
        final item = MultiBuyDealCard.itemOf(deal);
        final inCart = item == null ? 0 : _cart.quantityOfItem(item.id);
        return MultiBuyDealCard(
          key: key,
          deal: deal,
          isDark: isDark,
          inCartQuantity: inCart,
          status: _statusOf(
            deal,
            MultiBuyProgress.of(
              quantity: inCart,
              minQuantity: deal.minQuantity,
              discountPercent: deal.discountPercent,
            ).unlocked,
          ),
          onElapsed: _load,
        );
      case DealType.freeGift:
        return FreeGiftDealCard(
          key: key,
          deal: deal,
          isDark: isDark,
          quantityOf: _cart.quantityOfItem,
          status: _statusOf(deal, _giftConditionMet(deal)),
          onElapsed: _load,
        );
      case DealType.singleItem:
      case DealType.spendThreshold:
        return null;
    }
  }

  /// A free gift only applies once the free item is in the cart too.
  bool _giftConditionMet(CustomerDealDto deal) {
    final progress = DealLinesProgress.of(deal, _cart.quantityOfItem);
    return progress.complete && progress.giftInCart;
  }

  /// The card's state as the cart has it: unlocked only when the cart applies
  /// the deal.
  DealCartStatus _statusOf(CustomerDealDto deal, bool conditionMet) {
    final itemIds = {
      for (final line in deal.lines) line.itemId,
      for (final item in deal.items) item.id,
    };
    return dealCartStatus(
      applied: _cart.isDealApplied(deal.id),
      conditionMet: conditionMet,
      takenByOtherDeal: itemIds.any(
        (id) => _cart.isItemTakenByOtherDeal(id, deal.id),
      ),
    );
  }
}

// --- Back bar --------------------------------------------------------------------

/// The top bar when the screen is pushed on its own: back and the title.
class _BackBar extends StatelessWidget {
  final bool isDark;

  const _BackBar({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final color = isDark ? AppColors.white : AppColors.auroraPurple;
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(4, 4, 16, 4),
      child: Row(
        children: [
          IconButton(
            icon: MirroredFaIcon(
              FontAwesomeIcons.arrowLeft,
              size: 20,
              color: color,
            ),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              'nav.deals'.tr(),
              style: AppTextStyles.heading3.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- Error ---------------------------------------------------------------------

class _FullHeightMessage extends StatelessWidget {
  final bool isDark;
  final FaIconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _FullHeightMessage({
    required this.isDark,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? AppColors.white : AppColors.auroraPurple;

    // Scrollable so a pull to refresh still works with nothing to show.
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: constraints.maxHeight,
          child: Center(
            child: GestureDetector(
              onTap: onTap,
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FaIcon(icon, size: 40, color: AppColors.auroraPink),
                    const SizedBox(height: 16),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.heading3.copyWith(
                        color: textColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      subtitle,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.caption.copyWith(
                        color: textColor.withValues(alpha: 0.65),
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                    if (actionLabel != null && onAction != null) ...[
                      const SizedBox(height: 18),
                      AuroraPrimaryButton(
                        text: actionLabel!,
                        onPressed: onAction,
                        isFullWidth: false,
                        height: 44,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// --- Skeleton ------------------------------------------------------------------

class _DealsSkeleton extends StatelessWidget {
  const _DealsSkeleton();

  @override
  Widget build(BuildContext context) {
    Widget block(double width, double height, double radius) => SizedBox(
      width: width,
      height: height,
      child: SkeletonShimmer(borderRadius: BorderRadius.circular(radius)),
    );

    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(top: 14),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: block(double.infinity, 210, 22),
        ),
        const SizedBox(height: 18),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              for (var i = 0; i < 4; i++) ...[
                if (i > 0) const SizedBox(width: 8),
                block(96, 34, 999),
              ],
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 18, 16, 12),
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: block(140, 20, 6),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: block(double.infinity, 190, 16),
        ),
        const ProductGridSkeleton(),
      ],
    );
  }
}
