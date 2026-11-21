import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../themes/app_colors.dart';
import '../../../../themes/app_text_styles.dart';
import '../../../../utils/number_localization.dart';
import '../../../../backend_integration/dtos/item/item_list_item_dto.dart';
import '../../../../routes/item_navigation.dart';
import '../../../reusable_components/deals/deal_countdown.dart';
import '../../../reusable_components/deals/in_cart_badge.dart';
import '../../../reusable_components/product_card/product_grid_card.dart';

/// True when the platform asks for reduced motion. Looping and decorative
/// animations stop, state changes still show, just without the movement.
bool reduceMotionOf(BuildContext context) =>
    MediaQuery.maybeDisableAnimationsOf(context) ?? false;

/// Colors a deal card uses in the current theme.
class DealPalette {
  final bool isDark;
  const DealPalette(this.isDark);

  Color get surface =>
      isDark ? AppColors.white.withValues(alpha: 0.05) : AppColors.white;
  Color get surfaceSoft => isDark
      ? AppColors.white.withValues(alpha: 0.08)
      : AppColors.auroraPurple.withValues(alpha: 0.05);
  Color get border => isDark
      ? AppColors.white.withValues(alpha: 0.10)
      : AppColors.auroraPurple.withValues(alpha: 0.12);
  Color get text => isDark ? AppColors.white : AppColors.auroraDeepBase;
  Color get muted => isDark ? AppColors.mutedOnDark : AppColors.mutedOnLight;
  Color get ink => isDark ? AppColors.auroraElectricBlue : AppColors.auroraPurple;
  Color get win => AppColors.verifiedGreen;
  Color get winSoft => AppColors.verifiedGreen.withValues(alpha: 0.14);
}

/// Rebuilds once a second with the time left until [target], and calls
/// [onElapsed] once when it reaches zero on screen.
class DealTicker extends StatefulWidget {
  final DateTime? target;
  final VoidCallback? onElapsed;
  final Widget Function(BuildContext context, Duration remaining) builder;

  const DealTicker({
    super.key,
    required this.target,
    required this.builder,
    this.onElapsed,
  });

  @override
  State<DealTicker> createState() => _DealTickerState();
}

class _DealTickerState extends State<DealTicker> {
  Timer? _timer;
  bool _elapsedFired = false;

  @override
  void initState() {
    super.initState();
    _start();
  }

  @override
  void didUpdateWidget(DealTicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.target != widget.target) _start();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _start() {
    _timer?.cancel();
    _elapsedFired = false;
    final target = widget.target;
    if (target == null || !target.isAfter(DateTime.now())) return;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {});
      if (!target.isAfter(DateTime.now())) {
        _timer?.cancel();
        if (!_elapsedFired) {
          _elapsedFired = true;
          widget.onElapsed?.call();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final target = widget.target;
    if (target == null) return const SizedBox.shrink();
    final remaining = target.difference(DateTime.now());
    return widget.builder(
      context,
      remaining.isNegative ? Duration.zero : remaining,
    );
  }
}

/// A countdown pill. Under an hour left it turns red and, unless reduced
/// motion is on, pulses.
class DealTimerPill extends StatelessWidget {
  final DateTime? target;
  final String? label;
  final VoidCallback? onElapsed;

  /// Dark glass for sitting on a product image; otherwise a soft surface.
  final bool onImage;
  final bool isDark;

  const DealTimerPill({
    super.key,
    required this.target,
    required this.isDark,
    this.label,
    this.onElapsed,
    this.onImage = false,
  });

  @override
  Widget build(BuildContext context) {
    final palette = DealPalette(isDark);
    return DealTicker(
      target: target,
      onElapsed: onElapsed,
      builder: (context, remaining) {
        final hot = remaining < const Duration(hours: 1);
        final background = hot
            ? AppColors.auroraRed
            : onImage
                ? AppColors.auroraDeepBase.withValues(alpha: 0.72)
                : palette.surfaceSoft;
        final foreground = hot || onImage ? AppColors.white : palette.text;
        final text = label == null
            ? formatDealRemaining(remaining)
            : '$label ${formatDealRemaining(remaining)}';
        final pill = Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(FontAwesomeIcons.stopwatch, size: 10, color: foreground),
              const SizedBox(width: 5),
              Flexible(
                child: Text(
                  text,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.auroraMonoPrice.copyWith(
                    color: foreground,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    height: 1.0,
                  ),
                ),
              ),
            ],
          ),
        );
        if (!hot || reduceMotionOf(context)) return pill;
        return LoopingPulse(child: pill);
      },
    );
  }
}

/// Repeats a gentle scale up and back while mounted.
class LoopingPulse extends StatefulWidget {
  final Widget child;
  final double scale;
  final Duration period;

  const LoopingPulse({
    super.key,
    required this.child,
    this.scale = 1.04,
    this.period = const Duration(milliseconds: 1200),
  });

  @override
  State<LoopingPulse> createState() => _LoopingPulseState();
}

class _LoopingPulseState extends State<LoopingPulse>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.period,
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: Tween(begin: 1.0, end: widget.scale).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
      ),
      child: widget.child,
    );
  }
}

/// Rocks a child back and forth around [baseAngle], or holds it still when
/// reduced motion is on.
class LoopingWobble extends StatefulWidget {
  final Widget child;
  final double baseAngle;

  const LoopingWobble({super.key, required this.child, this.baseAngle = 0.17});

  @override
  State<LoopingWobble> createState() => _LoopingWobbleState();
}

class _LoopingWobbleState extends State<LoopingWobble>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1500),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (reduceMotionOf(context)) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = Curves.easeInOut.transform(_controller.value);
        return Transform.rotate(
          angle: widget.baseAngle - t * 0.28,
          child: Transform.scale(scale: 1 + t * 0.05, child: child),
        );
      },
      child: widget.child,
    );
  }
}

/// Floats a child up and down, or holds it still when reduced motion is on.
class LoopingFloat extends StatefulWidget {
  final Widget child;
  final double distance;
  final Duration period;

  const LoopingFloat({
    super.key,
    required this.child,
    this.distance = 8,
    this.period = const Duration(seconds: 2),
  });

  @override
  State<LoopingFloat> createState() => _LoopingFloatState();
}

class _LoopingFloatState extends State<LoopingFloat>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.period,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (reduceMotionOf(context)) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Transform.translate(
        offset: Offset(
          0,
          -widget.distance * Curves.easeInOut.transform(_controller.value),
        ),
        child: child,
      ),
      child: widget.child,
    );
  }
}

/// The small uppercase heading on a wide deal card, with its icon tile.
class DealTypeLabel extends StatelessWidget {
  final FaIconData icon;
  final String label;
  final Color tint;
  final bool isDark;

  const DealTypeLabel({
    super.key,
    required this.icon,
    required this.label,
    required this.tint,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final palette = DealPalette(isDark);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 24,
          height: 24,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: tint.withValues(alpha: 0.16),
            borderRadius: BorderRadius.circular(8),
          ),
          child: FaIcon(icon, size: 12, color: tint),
        ),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            label.toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.captionSmall.copyWith(
              color: palette.ink,
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.6,
            ),
          ),
        ),
      ],
    );
  }
}

/// The rounded card every deal sits in. It fades and rises in once on first
/// build, unless reduced motion is on.
class DealCardShell extends StatelessWidget {
  final Widget child;
  final bool isDark;
  final EdgeInsetsGeometry padding;
  final Gradient? gradient;

  /// The deal's condition is met: a green outline and a soft green wash.
  final bool unlocked;

  const DealCardShell({
    super.key,
    required this.child,
    required this.isDark,
    this.padding = EdgeInsets.zero,
    this.gradient,
    this.unlocked = false,
  });

  @override
  Widget build(BuildContext context) {
    final palette = DealPalette(isDark);
    final card = Container(
      padding: padding,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: unlocked
            ? Color.alphaBlend(palette.winSoft, palette.surface)
            : gradient == null
            ? palette.surface
            : null,
        gradient: unlocked ? null : gradient,
        borderRadius: BorderRadius.circular(16),
        border: unlocked
            ? Border.all(color: palette.win, width: 2)
            : Border.all(color: palette.border),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: AppColors.shadowMedium,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: child,
    );
    if (reduceMotionOf(context)) return card;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOut,
      builder: (context, t, child) => Opacity(
        opacity: t,
        child: Transform.translate(offset: Offset(0, 10 * (1 - t)), child: child),
      ),
      child: card,
    );
  }
}

/// Compact gradient action button used inside deal cards. Shows a spinner
/// while [isLoading], and a green check once [isDone].
class DealActionButton extends StatelessWidget {
  final String label;
  final FaIconData icon;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isDone;
  final bool expand;

  const DealActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.isLoading = false,
    this.isDone = false,
    this.expand = false,
  });

  @override
  Widget build(BuildContext context) {
    final disabled = onPressed == null && !isLoading && !isDone;
    final content = isLoading
        ? const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FaIcon(
                isDone ? FontAwesomeIcons.check : icon,
                size: 12,
                color: AppColors.white,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.buttonSmall.copyWith(
                    color: AppColors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          );

    return Opacity(
      opacity: disabled ? 0.45 : 1,
      child: AnimatedContainer(
        duration: reduceMotionOf(context)
            ? Duration.zero
            : const Duration(milliseconds: 200),
        height: 36,
        width: expand ? double.infinity : null,
        decoration: BoxDecoration(
          color: isDone ? AppColors.verifiedGreen : null,
          gradient: isDone
              ? null
              : const LinearGradient(colors: AppColors.auroraGradient),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: isLoading || isDone ? null : onPressed,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Center(widthFactor: 1, child: content),
            ),
          ),
        ),
      ),
    );
  }
}

/// Item count shown in a quantity bubble, with localized digits.
String quantityBubble(int quantity) =>
    'deals.times'.tr(namedArgs: {'count': localizedNumber(quantity)});

/// A small purple circle joining two thumbnails with a plus or equals sign.
class DealJoinCircle extends StatelessWidget {
  final String symbol;

  const DealJoinCircle({super.key, required this.symbol});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: AppColors.auroraPurple,
        shape: BoxShape.circle,
      ),
      child: Text(
        symbol,
        style: AppTextStyles.badgeText.copyWith(
          color: AppColors.white,
          fontSize: 13,
          fontWeight: FontWeight.w800,
          height: 1.0,
        ),
      ),
    );
  }
}

/// The "x2" bubble on a thumbnail.
class DealQuantityBubble extends StatelessWidget {
  final int quantity;
  final bool isDark;

  const DealQuantityBubble({
    super.key,
    required this.quantity,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.auroraPurple,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: isDark ? AppColors.auroraDeepBase : AppColors.white,
          width: 2,
        ),
      ),
      child: Text(
        quantityBubble(quantity),
        style: AppTextStyles.badgeText.copyWith(
          color: AppColors.white,
          fontSize: 11,
          fontWeight: FontWeight.w800,
          height: 1.1,
        ),
      ),
    );
  }
}

/// A square deal item image drawn by the product card's own image widget.
Widget dealItemImage(String? url, double size, {double radius = 14}) =>
    ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox(
        width: size,
        height: size,
        child: ProductCardImage(url: url),
      ),
    );

/// The header of a wide deal card: its type label, and an Unlocked badge on
/// the end side once the deal's condition is met.
class DealCardHead extends StatelessWidget {
  final Widget label;
  final bool unlocked;

  const DealCardHead({super.key, required this.label, required this.unlocked});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 8,
      runSpacing: 6,
      children: [label, if (unlocked) const UnlockedBadge()],
    );
  }
}

/// A green pill marking a deal whose condition the cart meets.
class UnlockedBadge extends StatelessWidget {
  const UnlockedBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.verifiedGreen,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const FaIcon(FontAwesomeIcons.lockOpen, size: 9, color: AppColors.white),
          const SizedBox(width: 4),
          Text(
            'deals.unlocked_badge'.tr(),
            style: AppTextStyles.badgeText.copyWith(
              color: AppColors.white,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}

/// One item inside a bundle, multi-buy or free gift card, drawn with the
/// product card's own image and title. Opens the item screen when tapped,
/// which is the only place items go into the cart. Outlined in green with an
/// in-cart badge once the cart holds some.
class DealItemTile extends StatelessWidget {
  final ItemListItemDto? item;
  final int lineQuantity;
  final int inCart;

  /// The cart holds the full quantity this deal needs.
  final bool covered;
  final double size;
  final bool isDark;

  const DealItemTile({
    super.key,
    required this.item,
    required this.inCart,
    required this.covered,
    required this.isDark,
    this.lineQuantity = 1,
    this.size = 60,
  });

  @override
  Widget build(BuildContext context) {
    final palette = DealPalette(isDark);
    final tile = item;
    final image = tile != null && tile.colorImages.isNotEmpty
        ? tile.colorImages.first
        : null;
    final highlighted = covered || inCart > 0;

    return GestureDetector(
      onTap: tile == null
          ? null
          : () => openItemDetail(context, tile.id),
      child: SizedBox(
        width: size + 12,
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: highlighted ? palette.win : palette.border,
                      width: 2,
                    ),
                  ),
                  child: dealItemImage(image, size),
                ),
                if (lineQuantity > 1)
                  PositionedDirectional(
                    top: -6,
                    end: -6,
                    child: DealQuantityBubble(
                      quantity: lineQuantity,
                      isDark: isDark,
                    ),
                  ),
                if (inCart > 0)
                  PositionedDirectional(
                    bottom: -6,
                    start: -6,
                    end: -6,
                    child: Center(child: InCartBadge(count: inCart, fontSize: 8)),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            ProductCardTitle(
              title: tile?.title ?? '',
              isDark: isDark,
              maxLines: 2,
              fontSize: 10,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// The line under a deal's items: green once unlocked, otherwise what is
/// still needed.
class DealProgressText extends StatelessWidget {
  final String text;
  final bool unlocked;
  final bool isDark;

  const DealProgressText({
    super.key,
    required this.text,
    required this.unlocked,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final palette = DealPalette(isDark);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: FaIcon(
            unlocked ? FontAwesomeIcons.lockOpen : FontAwesomeIcons.lock,
            size: 12,
            color: unlocked ? palette.win : palette.ink,
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.bodySmall.copyWith(
              color: unlocked ? palette.win : palette.text,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
