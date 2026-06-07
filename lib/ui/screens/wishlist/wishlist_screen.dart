import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../backend_integration/dependency_injection/dependency_injection.dart';
import '../../../backend_integration/dtos/wishlist/wishlist_item_dto.dart';
import '../../../routes/route_constants.dart';
import '../../../services/theme_service.dart';
import '../../../services/toast_service.dart';
import '../../../services/wishlist_service.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_text_styles.dart';
import '../cart/widgets/cart_background.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  final _wishlist = serviceLocator<WishlistService>();

  @override
  void initState() {
    super.initState();
    _wishlist.loadFromServer();
  }

  Future<void> _remove(WishlistItemDto item) async {
    final msg = await _wishlist.toggle(item.itemId.toString());
    if (msg != null && msg.isNotEmpty) {
      ToastService.instance.showSuccess(msg);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([ThemeService.instance, _wishlist]),
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;
        final items = _wishlist.items;

        return Scaffold(
          backgroundColor:
              isDark ? AppColors.auroraDeepBase : AppColors.auroraLightBase,
          body: Stack(
            children: [
              const Positioned.fill(child: CartBackground()),
              SafeArea(
                child: Column(
                  children: [
                    _TopBar(isDark: isDark),
                    Expanded(
                      child: items.isEmpty
                          ? _WishlistEmptyState(isDark: isDark)
                          : ListView.builder(
                              padding:
                                  const EdgeInsets.fromLTRB(14, 4, 14, 24),
                              itemCount: items.length,
                              itemBuilder: (_, i) => _WishlistCard(
                                isDark: isDark,
                                item: items[i],
                                onRemove: () => _remove(items[i]),
                                onTap: () => Navigator.pushNamed(
                                  context,
                                  itemDetailsScreenRoute,
                                  arguments: items[i].itemId,
                                ),
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

// ─── Top bar ──────────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  final bool isDark;
  const _TopBar({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final color = isDark ? AppColors.white : AppColors.auroraPurple;
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 16, 8),
      child: Row(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => Navigator.pop(context),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child:
                  FaIcon(FontAwesomeIcons.arrowLeft, size: 16, color: color),
            ),
          ),
          const SizedBox(width: 4),
          Text(
            'Wishlist',
            style: AppTextStyles.heading3.copyWith(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Card ─────────────────────────────────────────────────────────────────────

class _WishlistCard extends StatelessWidget {
  final bool isDark;
  final WishlistItemDto item;
  final VoidCallback onRemove;
  final VoidCallback onTap;

  const _WishlistCard({
    required this.isDark,
    required this.item,
    required this.onRemove,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final fill = isDark
        ? AppColors.white.withValues(alpha: 0.05)
        : AppColors.white.withValues(alpha: 0.80);
    final border = isDark
        ? AppColors.white.withValues(alpha: 0.10)
        : AppColors.auroraPurple.withValues(alpha: 0.18);
    final nameColor = isDark ? AppColors.white : AppColors.auroraDeepBase;
    final origColor = isDark
        ? AppColors.white.withValues(alpha: 0.28)
        : AppColors.auroraDeepBase.withValues(alpha: 0.28);

    final currentPrice = item.discountedPrice ?? item.originalPrice;
    final hasDiscount = item.discountedPrice != null;
    final discountPct = hasDiscount
        ? ((1 - item.discountedPrice! / item.originalPrice) * 100).round()
        : 0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: fill,
          border: Border.all(color: border),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _Thumb(url: item.mainImageUrl ?? '', isDark: isDark),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.itemTitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: nameColor,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      if (!item.isAvailable)
                        _TagBadge(
                          label: 'Out of stock',
                          textColor: isDark
                              ? AppColors.auroraRed.withValues(alpha: 0.85)
                              : AppColors.auroraRed,
                          bgColor: AppColors.auroraRed.withValues(alpha: isDark ? 0.12 : 0.08),
                          borderColor: AppColors.auroraRed.withValues(alpha: isDark ? 0.22 : 0.18),
                        ),
                      if (!item.isAvailable && hasDiscount)
                        const SizedBox(width: 5),
                      if (hasDiscount)
                        _TagBadge(
                          label: '−$discountPct%',
                          textColor: AppColors.auroraPink,
                          bgColor: AppColors.auroraPink.withValues(alpha: isDark ? 0.12 : 0.08),
                          borderColor: AppColors.auroraPink.withValues(alpha: isDark ? 0.22 : 0.18),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [
                            AppColors.auroraPink,
                            AppColors.auroraElectricBlue,
                          ],
                        ).createShader(bounds),
                        blendMode: BlendMode.srcIn,
                        child: Text(
                          '\$${currentPrice.toStringAsFixed(2)}',
                          style: AppTextStyles.productPrice.copyWith(
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            color: AppColors.white,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ),
                      if (hasDiscount) ...[
                        const SizedBox(width: 5),
                        Text(
                          '\$${item.originalPrice.toStringAsFixed(2)}',
                          style: AppTextStyles.caption.copyWith(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: origColor,
                            decoration: TextDecoration.lineThrough,
                            decorationColor: origColor,
                          ),
                        ),
                      ],
                      const Spacer(),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: onRemove,
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: FaIcon(
                            FontAwesomeIcons.solidHeart,
                            size: 14,
                            color: AppColors.auroraPink,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Thumbnail ────────────────────────────────────────────────────────────────

class _Thumb extends StatelessWidget {
  final String url;
  final bool isDark;
  const _Thumb({required this.url, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final placeholderColor = isDark
        ? AppColors.white.withValues(alpha: 0.06)
        : AppColors.primaryPurple.withValues(alpha: 0.06);
    final borderColor = isDark
        ? AppColors.white.withValues(alpha: 0.10)
        : AppColors.auroraPurple.withValues(alpha: 0.16);
    final iconColor = isDark
        ? AppColors.white.withValues(alpha: 0.20)
        : AppColors.primaryPurple.withValues(alpha: 0.30);

    final fallback =
        Center(child: FaIcon(FontAwesomeIcons.image, size: 16, color: iconColor));

    return Container(
      width: 68,
      height: 68,
      decoration: BoxDecoration(
        color: placeholderColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.hardEdge,
      child: url.isNotEmpty
          ? Image.network(
              url,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => fallback,
              loadingBuilder: (_, child, progress) =>
                  progress == null ? child : fallback,
            )
          : fallback,
    );
  }
}

// ─── Tag badge ────────────────────────────────────────────────────────────────

class _TagBadge extends StatelessWidget {
  final String label;
  final Color textColor;
  final Color bgColor;
  final Color borderColor;

  const _TagBadge({
    required this.label,
    required this.textColor,
    required this.bgColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: borderColor),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          fontSize: 9.5,
          fontWeight: FontWeight.w700,
          color: textColor,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

// ─── Empty state ──────────────────────────────────────────────────────────────

class _WishlistEmptyState extends StatefulWidget {
  final bool isDark;
  const _WishlistEmptyState({required this.isDark});

  @override
  State<_WishlistEmptyState> createState() => _WishlistEmptyStateState();
}

class _WishlistEmptyStateState extends State<_WishlistEmptyState>
    with TickerProviderStateMixin {
  late final AnimationController _floatCtrl;
  late final AnimationController _glowCtrl;
  late final AnimationController _orbit1Ctrl;
  late final AnimationController _orbit2Ctrl;
  late final AnimationController _orbit3Ctrl;
  late final Animation<double> _floatY;
  late final Animation<double> _glowScale;
  late final Animation<double> _glowOpacity;

  @override
  void initState() {
    super.initState();
    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..repeat(reverse: true);
    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat(reverse: true);
    _orbit1Ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat();
    _orbit2Ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5500),
    )..repeat();
    _orbit3Ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3800),
    )..repeat();

    _floatY = Tween<double>(begin: 0, end: -8).animate(
      CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut),
    );
    _glowScale = Tween<double>(begin: 1.0, end: 1.10).animate(
      CurvedAnimation(parent: _glowCtrl, curve: Curves.easeInOut),
    );
    _glowOpacity = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _glowCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _floatCtrl.dispose();
    _glowCtrl.dispose();
    _orbit1Ctrl.dispose();
    _orbit2Ctrl.dispose();
    _orbit3Ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final headingColor =
        widget.isDark ? AppColors.white : AppColors.auroraDeepBase;
    final subColor = widget.isDark
        ? AppColors.white.withValues(alpha: 0.40)
        : AppColors.auroraDeepBase.withValues(alpha: 0.40);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _HeartIllustration(
              floatY: _floatY,
              glowScale: _glowScale,
              glowOpacity: _glowOpacity,
              orbit1: _orbit1Ctrl,
              orbit2: _orbit2Ctrl,
              orbit3: _orbit3Ctrl,
            ),
            const SizedBox(height: 28),
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: AppColors.auroraGradient,
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
              blendMode: BlendMode.srcIn,
              child: Text(
                'YOUR WISHLIST',
                style:
                    AppTextStyles.dsSectionLabel.copyWith(color: AppColors.white),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Nothing saved yet',
              style: AppTextStyles.dsH2.copyWith(
                color: headingColor,
                fontSize: 24,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              "Tap the heart on any item\nand it'll appear right here.",
              style: AppTextStyles.dsMuted.copyWith(
                color: subColor,
                fontSize: 13,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _HeartIllustration extends StatelessWidget {
  final Animation<double> floatY;
  final Animation<double> glowScale;
  final Animation<double> glowOpacity;
  final AnimationController orbit1;
  final AnimationController orbit2;
  final AnimationController orbit3;

  const _HeartIllustration({
    required this.floatY,
    required this.glowScale,
    required this.glowOpacity,
    required this.orbit1,
    required this.orbit2,
    required this.orbit3,
  });

  @override
  Widget build(BuildContext context) {
    const wrapSize = 140.0;
    const center = wrapSize / 2;
    const r1 = 58.0, r2 = 62.0, r3 = 55.0;
    const a2Start = 2 * pi / 3;
    const a3Start = 4 * pi / 3;

    return SizedBox(
      width: wrapSize,
      height: wrapSize,
      child: AnimatedBuilder(
        animation:
            Listenable.merge([floatY, glowScale, glowOpacity, orbit1, orbit2, orbit3]),
        builder: (context, _) {
          final a1 = 2 * pi * orbit1.value;
          final a2 = a2Start + 2 * pi * orbit2.value;
          final a3 = a3Start + 2 * pi * orbit3.value;

          return Stack(
            alignment: Alignment.center,
            children: [
              Opacity(
                opacity: glowOpacity.value,
                child: Transform.scale(
                  scale: glowScale.value,
                  child: Container(
                    width: wrapSize,
                    height: wrapSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppColors.auroraPink.withValues(alpha: 0.18),
                          AppColors.auroraPurple.withValues(alpha: 0.10),
                          AppColors.auroraPurple.withValues(alpha: 0.0),
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: center + r1 * cos(a1) - 3.5,
                top: center + r1 * sin(a1) - 3.5,
                child: Container(
                  width: 7, height: 7,
                  decoration: const BoxDecoration(
                    color: AppColors.auroraPink, shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                left: center + r2 * cos(a2) - 2.5,
                top: center + r2 * sin(a2) - 2.5,
                child: Container(
                  width: 5, height: 5,
                  decoration: const BoxDecoration(
                    color: AppColors.auroraElectricBlue, shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                left: center + r3 * cos(a3) - 2.0,
                top: center + r3 * sin(a3) - 2.0,
                child: Container(
                  width: 4, height: 4,
                  decoration: const BoxDecoration(
                    color: AppColors.verifiedGreen, shape: BoxShape.circle,
                  ),
                ),
              ),
              Transform.translate(
                offset: Offset(0, floatY.value),
                child: ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: AppColors.auroraGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                  blendMode: BlendMode.srcIn,
                  child: const FaIcon(
                    FontAwesomeIcons.solidHeart,
                    size: 56,
                    color: AppColors.white,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
