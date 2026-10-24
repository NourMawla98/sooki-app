import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../backend_integration/apis/deals_api.dart';
import '../../../backend_integration/dependency_injection/dependency_injection.dart';
import '../../../backend_integration/dtos/deal/customer_deal_dto.dart';
import '../../../services/theme_service.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_text_styles.dart';
import '../../reusable_components/aurora/aurora_gradient_text.dart';
import '../../reusable_components/deals/deal_countdown.dart';
import '../../reusable_components/product_card/product_grid_card.dart';
import '../../reusable_components/skeleton/skeleton_shimmer.dart';
import '../splash/widgets/aurora_glow_blob.dart';

/// The Deals tab: live deals with their time left, then deals coming up with
/// the time until they start. Upcoming items show their normal price.
class DealsScreen extends StatefulWidget {
  const DealsScreen({super.key});

  @override
  State<DealsScreen> createState() => _DealsScreenState();
}

class _DealsScreenState extends State<DealsScreen> {
  final _api = serviceLocator<DealsApi>();

  List<CustomerDealDto>? _deals; // null = first load in progress
  bool _hasError = false;
  bool _isFetching = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (_isFetching) return;
    _isFetching = true;
    final result = await _api.getDeals();
    _isFetching = false;
    if (!mounted) return;
    result.fold(
      (_) => setState(() => _hasError = _deals == null),
      (deals) => setState(() {
        _deals = deals;
        _hasError = false;
      }),
    );
  }

  Future<void> _retry() async {
    setState(() => _hasError = false);
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService.instance,
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;

        return Scaffold(
          backgroundColor: isDark ? Colors.transparent : AppColors.white,
          body: Stack(
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
          ),
        );
      },
    );
  }

  Widget _buildBody(bool isDark) {
    final deals = _deals;
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
    if (deals.isEmpty) {
      return _FullHeightMessage(
        isDark: isDark,
        icon: FontAwesomeIcons.bolt,
        title: 'deals.empty_title'.tr(),
        subtitle: 'deals.empty_subtitle'.tr(),
      );
    }

    final live = deals.where((d) => d.isLive).toList();
    final upcoming = deals.where((d) => !d.isLive).toList();

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(top: 14, bottom: 100),
      children: [
        if (live.isNotEmpty) ...[
          _SectionHeading(
            title: 'deals.live_now'.tr(),
            icon: FontAwesomeIcons.bolt,
          ),
          for (final deal in live)
            _DealBlock(deal: deal, isDark: isDark, onElapsed: _load),
        ],
        if (upcoming.isNotEmpty) ...[
          _SectionHeading(
            title: 'deals.coming_up'.tr(),
            icon: FontAwesomeIcons.hourglassHalf,
          ),
          for (final deal in upcoming)
            _DealBlock(deal: deal, isDark: isDark, onElapsed: _load),
        ],
      ],
    );
  }
}

// --- Section heading -----------------------------------------------------------

class _SectionHeading extends StatelessWidget {
  final String title;
  final FaIconData icon;

  const _SectionHeading({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 10),
      child: Row(
        children: [
          FaIcon(icon, size: 16, color: AppColors.auroraPink),
          const SizedBox(width: 8),
          AuroraGradientText(
            title,
            style: AppTextStyles.heading3.copyWith(
              fontWeight: FontWeight.w900,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}

// --- One deal ------------------------------------------------------------------

class _DealBlock extends StatelessWidget {
  final CustomerDealDto deal;
  final bool isDark;
  final VoidCallback onElapsed;

  const _DealBlock({
    required this.deal,
    required this.isDark,
    required this.onElapsed,
  });

  @override
  Widget build(BuildContext context) {
    final titleColor = isDark ? AppColors.white : AppColors.auroraDeepBase;
    final mutedColor = isDark
        ? AppColors.white.withValues(alpha: 0.60)
        : AppColors.auroraDeepBase.withValues(alpha: 0.60);
    final description = deal.description;
    final hasDescription = description != null && description.trim().isNotEmpty;

    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  deal.title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: titleColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
                if (hasDescription) ...[
                  const SizedBox(height: 3),
                  Text(
                    description,
                    style: AppTextStyles.caption.copyWith(
                      color: mutedColor,
                      fontSize: 12,
                      height: 1.3,
                    ),
                  ),
                ],
                const SizedBox(height: 6),
                deal.isLive
                    ? DealCountdown(
                        target: deal.expiresAt,
                        label: 'deals.ends_in'.tr(),
                        color: AppColors.auroraPink,
                        fontSize: 12,
                        onElapsed: onElapsed,
                      )
                    : DealCountdown(
                        target: deal.startsAt,
                        label: 'deals.starts_in'.tr(),
                        color: isDark
                            ? AppColors.auroraElectricBlue
                            : AppColors.auroraPurple,
                        fontSize: 12,
                        onElapsed: onElapsed,
                      ),
              ],
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.70,
            ),
            itemCount: deal.items.length,
            itemBuilder: (_, i) => ProductGridCard(item: deal.items[i]),
          ),
        ],
      ),
    );
  }
}

// --- Empty and error -----------------------------------------------------------

class _FullHeightMessage extends StatelessWidget {
  final bool isDark;
  final FaIconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const _FullHeightMessage({
    required this.isDark,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? AppColors.white : AppColors.primaryPurple;

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
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(top: 14),
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 14),
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: SizedBox(
              width: 120,
              height: 20,
              child: SkeletonShimmer(borderRadius: BorderRadius.circular(6)),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 180,
                height: 15,
                child: SkeletonShimmer(borderRadius: BorderRadius.circular(4)),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: 110,
                height: 12,
                child: SkeletonShimmer(borderRadius: BorderRadius.circular(4)),
              ),
            ],
          ),
        ),
        const ProductGridSkeleton(),
      ],
    );
  }
}
