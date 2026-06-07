import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';

import '../../../backend_integration/dtos/order/order_list_item_dto.dart';
import '../../../enums/order_status.dart';
import '../../../routes/route_constants.dart';
import '../../../services/orders_service.dart';
import '../../../services/theme_service.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_text_styles.dart';
import '../../reusable_components/order_card/order_card.dart';
import '../splash/widgets/aurora_glow_blob.dart';

enum _Tab { inProgress, delivered, closed }

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  _Tab _tab = _Tab.inProgress;
  final _scrollController = ScrollController();

  OrdersService get _service => GetIt.instance<OrdersService>();

  @override
  void initState() {
    super.initState();
    _service.loadOrders(reset: true);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      _service.loadMore();
    }
  }

  Future<void> _refresh() => _service.loadOrders(reset: true);

  List<OrderListItemDto> _filtered(List<OrderListItemDto> all) {
    return all.where((dto) {
      final status = OrderStatus.fromInt(dto.status);
      return switch (_tab) {
        _Tab.inProgress => status.isInProgress,
        _Tab.delivered => status.isDelivered,
        _Tab.closed => status.isClosed,
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([ThemeService.instance, _service]),
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;
        final iconColor = isDark ? AppColors.white : AppColors.auroraPurple;
        final titleColor = isDark ? AppColors.white : AppColors.auroraDeepBase;
        final filtered = _filtered(_service.orders);

        return Scaffold(
          backgroundColor:
              isDark ? AppColors.auroraDeepBase : AppColors.auroraLightBase,
          body: Stack(
            children: [
              AuroraGlowBlob(
                top: -100, right: -100, size: 260,
                color: AppColors.auroraPurple,
                intensity: isDark ? 0.18 : 0.08,
              ),
              AuroraGlowBlob(
                bottom: -100, left: -100, size: 280,
                color: AppColors.auroraElectricBlue,
                intensity: isDark ? 0.16 : 0.07,
              ),
              SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top bar
                    Padding(
                      padding: const EdgeInsets.fromLTRB(4, 4, 16, 8),
                      child: Row(
                        children: [
                          IconButton(
                            icon: FaIcon(FontAwesomeIcons.arrowLeft,
                                size: 18, color: iconColor),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Orders',
                            style: AppTextStyles.dsH2.copyWith(
                              color: titleColor,
                              fontWeight: FontWeight.w800,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Filter tabs
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                      child: Row(
                        children: [
                          _FilterTab(
                            label: 'In Progress',
                            isActive: _tab == _Tab.inProgress,
                            onTap: () => setState(() => _tab = _Tab.inProgress),
                          ),
                          const SizedBox(width: 8),
                          _FilterTab(
                            label: 'Delivered',
                            isActive: _tab == _Tab.delivered,
                            onTap: () => setState(() => _tab = _Tab.delivered),
                          ),
                          const SizedBox(width: 8),
                          _FilterTab(
                            label: 'Closed',
                            isActive: _tab == _Tab.closed,
                            onTap: () => setState(() => _tab = _Tab.closed),
                          ),
                        ],
                      ),
                    ),

                    // List
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: _refresh,
                        color: AppColors.auroraPink,
                        child: _service.isLoading && _service.orders.isEmpty
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.auroraPurple,
                                ),
                              )
                            : filtered.isEmpty
                                ? SingleChildScrollView(
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    child: _EmptyState(isDark: isDark),
                                  )
                                : ListView.separated(
                                    controller: _scrollController,
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    padding: const EdgeInsets.fromLTRB(
                                        14, 0, 14, 24),
                                    itemCount: filtered.length +
                                        (_service.isLoading ? 1 : 0),
                                    separatorBuilder: (_, _) =>
                                        const SizedBox(height: 10),
                                    itemBuilder: (context, i) {
                                      if (i >= filtered.length) {
                                        return const Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 16),
                                          child: Center(
                                            child: CircularProgressIndicator(
                                              color: AppColors.auroraPurple,
                                              strokeWidth: 2,
                                            ),
                                          ),
                                        );
                                      }
                                      final order = filtered[i];
                                      return OrderCard(
                                        dto: order,
                                        onTap: () => Navigator.pushNamed(
                                          context,
                                          orderDetailScreenRoute,
                                          arguments: order.id,
                                        ).then((_) => _refresh()),
                                      );
                                    },
                                  ),
                      ),
                    ),
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

// ── Filter tab ────────────────────────────────────────────────────────────────

class _FilterTab extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _FilterTab({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: isActive ? 1.0 : 0.30,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: AppColors.auroraGradient,
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            style: AppTextStyles.dsCTA.copyWith(
              fontSize: 11,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final bool isDark;
  const _EmptyState({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final subColor = isDark
        ? AppColors.white.withValues(alpha: 0.38)
        : AppColors.auroraDeepBase.withValues(alpha: 0.38);

    return Center(
      child: Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ShaderMask(
              shaderCallback: (b) => const LinearGradient(
                colors: AppColors.auroraGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(Rect.fromLTWH(0, 0, b.width, b.height)),
              blendMode: BlendMode.srcIn,
              child: const FaIcon(FontAwesomeIcons.box,
                  size: 40, color: AppColors.white),
            ),
            const SizedBox(height: 16),
            Text(
              'No orders here',
              style: AppTextStyles.dsH2.copyWith(
                color: isDark ? AppColors.white : AppColors.auroraDeepBase,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Orders in this category will appear here.',
              style: AppTextStyles.dsMuted.copyWith(
                  color: subColor, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
