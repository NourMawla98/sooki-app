import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../backend_integration/apis/items_api.dart';
import '../../../../backend_integration/dependency_injection/dependency_injection.dart';
import '../../../../models/for_you_pick.dart';
import '../../../../routes/route_constants.dart';
import '../../../../services/search_history_service.dart';
import '../../../../services/viewed_items_service.dart';
import '../../../../services/toast_service.dart';
import '../../../../services/wishlist_service.dart';
import '../../../../themes/app_colors.dart';
import '../../../../themes/app_text_styles.dart';
import '../../../reusable_components/refresh/refresh_scope.dart';
import '../../../reusable_components/skeleton/skeleton_shimmer.dart';

/// Section 5 — For You Deck. Fetches personalized picks from the API, then
/// auto-advances every [interval] and accepts bidirectional manual swipes.
/// A pink→purple progress bar along the top edge counts down the timer.
class ForYouDeck extends StatefulWidget {
  final Duration interval;

  const ForYouDeck({
    super.key,
    this.interval = const Duration(seconds: 5),
  });

  @override
  State<ForYouDeck> createState() => _ForYouDeckState();
}

class _ForYouDeckState extends State<ForYouDeck>
    with TickerProviderStateMixin, AutoRefreshMixin {
  final _wishlist = serviceLocator<WishlistService>();
  final _api = serviceLocator<ItemsApi>();
  final _viewedItems = serviceLocator<ViewedItemsService>();
  final _searchHistory = serviceLocator<SearchHistoryService>();

  List<ForYouPick> _picks = [];
  bool _loading = true;

  int _index = 0;

  Timer? _autoTimer;
  late final AnimationController _swipeController;
  late final AnimationController _progressController;

  // +1 = advancing NEXT (card exits left). -1 = going PREV (card exits right).
  int _swipeDirection = 1;
  // Flips the pick index at mid-animation so the new pick is already in place
  // before the card fades back in — avoids the end-of-animation content flicker.
  bool _midpointReached = false;
  double _dragDx = 0;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _swipeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )
      ..addListener(_onSwipeTick)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _midpointReached = false;
          _swipeController.reset();
          setState(() => _dragDx = 0);
          _restartAutoAdvance();
        }
      });

    _progressController = AnimationController(
      vsync: this,
      duration: widget.interval,
    );
    _fetch();
  }

  Future<void> _fetch() async {
    setState(() => _loading = true);
    final result = await _api.getForYouItems(
      viewedItemIds: _viewedItems.ids,
      searchKeywords: _searchHistory.recents,
    );
    if (!mounted) return;
    result.fold(
      (_) => setState(() => _loading = false),
      (items) {
        final picks = items.asMap().entries.map((e) {
          final dto = e.value;
          final gradient = forYouGradientPalette[e.key % forYouGradientPalette.length];
          return ForYouPick(
            itemId: dto.id,
            name: dto.title,
            price: dto.discountedPrice ?? dto.originalPrice,
            why: dto.reasonMessage,
            imageUrl: dto.imageUrl,
            gradient: gradient,
          );
        }).toList();
        setState(() {
          _picks = picks;
          _loading = false;
          _index = 0;
        });
        if (picks.isNotEmpty) _restartAutoAdvance();
      },
    );
  }

  @override
  Future<void> onRefresh() => _fetch();

  void _onSwipeTick() {
    if (_midpointReached || _swipeController.value < 0.5) return;
    _midpointReached = true;
    setState(() {
      _index = _swipeDirection > 0
          ? (_index + 1) % _picks.length
          : (_index - 1 + _picks.length) % _picks.length;
      // Reset so the next drag starts from center, not from the
      // release position of the previous swipe.
      _dragDx = 0;
    });
  }

  void _restartAutoAdvance() {
    _autoTimer?.cancel();
    _progressController
      ..stop()
      ..reset()
      ..forward();
    if (_picks.length <= 1) return;
    _autoTimer = Timer.periodic(widget.interval, (_) {
      if (!mounted || _swipeController.isAnimating || _isDragging) return;
      _swipeDirection = 1;
      _swipeController.forward(from: 0);
    });
  }

  @override
  void dispose() {
    _autoTimer?.cancel();
    _swipeController
      ..removeListener(_onSwipeTick)
      ..dispose();
    _progressController.dispose();
    super.dispose();
  }

  Future<void> _toggleWishlist(int idx) async {
    if (idx >= _picks.length) return;
    final msg = await _wishlist.toggle(_picks[idx].itemId.toString());
    if (msg != null && msg.isNotEmpty) {
      ToastService.instance.showSuccess(msg);
    }
  }

  void _onTapCard() {
    if (_picks.isEmpty) return;
    Navigator.pushNamed(
      context,
      productDetailScreenRoute,
      arguments: _picks[_index].itemId,
    );
  }

  void _onHorizontalDragStart(DragStartDetails _) {
    if (_picks.length <= 1) return;
    _autoTimer?.cancel();
    _progressController.stop();
    setState(() => _isDragging = true);
  }

  void _onHorizontalDragUpdate(DragUpdateDetails d) {
    if (!_isDragging) return;
    setState(() => _dragDx += d.delta.dx);
  }

  void _onHorizontalDragEnd(DragEndDetails _) {
    const threshold = 70.0;
    if (_dragDx.abs() > threshold) {
      // Positive dx (dragged right) = previous. Negative = next.
      // Keep _dragDx — the exit animation continues from this position so
      // there is no visible snap-back between drag release and animation.
      _swipeDirection = _dragDx < 0 ? 1 : -1;
      setState(() => _isDragging = false);
      _swipeController.forward(from: 0);
    } else {
      setState(() {
        _isDragging = false;
        _dragDx = 0;
      });
      _restartAutoAdvance();
    }
  }

  @override
  Widget build(BuildContext context) {
    const deckHeight = 230.0;

    return ListenableBuilder(
      listenable: _wishlist,
      builder: (context, _) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _SectionHeader(),
            const SizedBox(height: 10),
            SizedBox(
              height: deckHeight,
              child: _loading
                  ? SkeletonShimmer(borderRadius: BorderRadius.circular(14))
                  : _picks.isEmpty
                      ? const SizedBox.shrink()
                      : LayoutBuilder(
                          builder: (context, constraints) =>
                              _buildCard(constraints.maxWidth),
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(double cardWidth) {
    return AnimatedBuilder(
      animation: _swipeController,
      builder: (context, child) {
        final t = _swipeController.value;
        final dir = _swipeDirection.toDouble();
        // Rotation the card currently has from the finger drag. Kept as the
        // starting angle of the exit animation so there is no rotation hop.
        final dragRot = (_dragDx / 420) * math.pi / 16;

        double txPx;
        double rot;
        double opacity;

        if (_isDragging) {
          txPx = _dragDx;
          rot = dragRot;
          opacity = 1;
        } else if (_swipeController.isAnimating) {
          if (t < 0.5) {
            // Exit — interpolates in pixels from the exact drag-release
            // position/rotation to off-screen, so the handoff between finger
            // and animation is invisible.
            final p = Curves.easeOutCubic.transform(t / 0.5);
            final startPx = _dragDx;
            final targetPx = -cardWidth * 1.15 * dir;
            txPx = startPx + (targetPx - startPx) * p;

            final targetRot = -7 * dir * math.pi / 180;
            rot = dragRot + (targetRot - dragRot) * p;

            opacity = 1 - p;
          } else {
            // Enter — new pick slides in from the opposite edge, no rotation.
            final p = Curves.easeOutCubic.transform((t - 0.5) / 0.5);
            final startPx = cardWidth * 1.15 * dir;
            txPx = startPx * (1 - p);
            rot = 0;
            opacity = p;
          }
        } else {
          txPx = 0;
          rot = 0;
          opacity = 1;
        }

        return Transform.translate(
          offset: Offset(txPx, 0),
          child: Transform.rotate(
            angle: rot,
            child: Opacity(opacity: opacity, child: child),
          ),
        );
      },
      child: _ForYouCard(
        pick: _picks[_index],
        index: _index,
        total: _picks.length,
        isWishlisted: _wishlist.isWishlisted(_picks[_index].itemId.toString()),
        progressController: _progressController,
        onTap: _onTapCard,
        onHeartTap: () => _toggleWishlist(_index),
        onDragStart: _onHorizontalDragStart,
        onDragUpdate: _onHorizontalDragUpdate,
        onDragEnd: _onHorizontalDragEnd,
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: AppColors.auroraCartButtonGradient,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ).createShader(bounds),
          blendMode: BlendMode.srcIn,
          child: Text(
            'For You',
            style: AppTextStyles.heading3.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.w900,
              fontSize: 20,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.auroraPink, AppColors.auroraPurple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppColors.auroraPink.withValues(alpha: 0.35),
                blurRadius: 8,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const FaIcon(
                FontAwesomeIcons.wandMagicSparkles,
                size: 10,
                color: AppColors.white,
              ),
              const SizedBox(width: 5),
              Text(
                'AI PICKED',
                style: AppTextStyles.captionSmall.copyWith(
                  color: AppColors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5,
                  height: 1.0,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ForYouCard extends StatelessWidget {
  final ForYouPick pick;
  final int index;
  final int total;
  final bool isWishlisted;
  final AnimationController progressController;
  final VoidCallback onTap;
  final VoidCallback onHeartTap;
  final GestureDragStartCallback onDragStart;
  final GestureDragUpdateCallback onDragUpdate;
  final GestureDragEndCallback onDragEnd;

  const _ForYouCard({
    required this.pick,
    required this.index,
    required this.total,
    required this.isWishlisted,
    required this.progressController,
    required this.onTap,
    required this.onHeartTap,
    required this.onDragStart,
    required this.onDragUpdate,
    required this.onDragEnd,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.white.withValues(alpha: 0.08),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.5),
            blurRadius: 32,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: GestureDetector(
        onTap: onTap,
        onHorizontalDragStart: onDragStart,
        onHorizontalDragUpdate: onDragUpdate,
        onHorizontalDragEnd: onDragEnd,
        behavior: HitTestBehavior.opaque,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Gradient fallback + product image.
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: pick.gradient,
                ),
              ),
              child: pick.imageUrl != null
                ? Image.network(
                    pick.imageUrl!,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return const SkeletonShimmer();
                    },
                    errorBuilder: (context, _, _) => const SizedBox.shrink(),
                  )
                : const SizedBox.shrink(),
            ),
            // Dark overlay for text legibility.
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.45, 1.0],
                  colors: [
                    Color(0x00000000),
                    Color(0xE0000000),
                  ],
                ),
              ),
            ),
            // Inline progress bar — top edge, story-style.
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _InlineProgressBar(controller: progressController),
            ),
            Positioned(
              top: 12,
              left: 12,
              child: _CountPill(index: index, total: total),
            ),
            Positioned(
              top: 12,
              right: 12,
              child: _HeartButton(
                isActive: isWishlisted,
                onTap: onHeartTap,
              ),
            ),
            Positioned(
              left: 14,
              right: 14,
              bottom: 14,
              child: _InfoBlock(pick: pick),
            ),
          ],
        ),
      ),
    );
  }
}

class _InlineProgressBar extends StatelessWidget {
  final AnimationController controller;
  const _InlineProgressBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 3,
      color: AppColors.white.withValues(alpha: 0.12),
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, _) => FractionallySizedBox(
          alignment: Alignment.centerLeft,
          widthFactor: controller.value.clamp(0.0, 1.0),
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.auroraPink, AppColors.auroraPurple],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.auroraPink.withValues(alpha: 0.6),
                  blurRadius: 6,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CountPill extends StatelessWidget {
  final int index;
  final int total;
  const _CountPill({required this.index, required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.black.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.white.withValues(alpha: 0.12)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${index + 1}',
            style: AppTextStyles.captionSmall.copyWith(
              color: AppColors.auroraPink,
              fontSize: 9,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
              height: 1.0,
            ),
          ),
          Text(
            ' / $total',
            style: AppTextStyles.captionSmall.copyWith(
              color: AppColors.white.withValues(alpha: 0.85),
              fontSize: 9,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeartButton extends StatelessWidget {
  final bool isActive;
  final VoidCallback onTap;
  const _HeartButton({required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: AppColors.black.withValues(alpha: 0.55),
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.white.withValues(alpha: 0.12)),
        ),
        child: Center(
          child: FaIcon(
            isActive ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart,
            size: 13,
            color: AppColors.auroraPink,
          ),
        ),
      ),
    );
  }
}

/// Minimalistic skeleton placeholder for [ForYouDeck]. A single shimmering
/// rounded rectangle matching the deck's 230px height and 14px radius —
/// communicates "For You card is loading" without faking internal UI.
// SKELETON LOCKED — appearance approved 2026-05-12. Do not modify.
class ForYouDeckSkeleton extends StatelessWidget {
  const ForYouDeckSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(),
          const SizedBox(height: 10),
          SizedBox(
            height: 230,
            child: SkeletonShimmer(borderRadius: BorderRadius.circular(14)),
          ),
        ],
      ),
    );
  }
}

class _InfoBlock extends StatelessWidget {
  final ForYouPick pick;
  const _InfoBlock({required this.pick});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          pick.name,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.white,
            fontSize: 15,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.2,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          '\$${pick.price.toStringAsFixed(pick.price.truncateToDouble() == pick.price ? 0 : 2)}',
          style: AppTextStyles.auroraMonoPrice.copyWith(
            color: AppColors.white,
            fontSize: 13,
            fontWeight: FontWeight.w800,
            height: 1.0,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          pick.why,
          style: AppTextStyles.captionSmall.copyWith(
            color: AppColors.white.withValues(alpha: 0.85),
            fontSize: 10,
            fontStyle: FontStyle.italic,
            height: 1.2,
          ),
        ),
      ],
    );
  }
}
