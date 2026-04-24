import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../services/cart_service.dart';
import '../../../../services/theme_service.dart';
import '../../../../themes/app_colors.dart';
import '../../../../themes/app_text_styles.dart';

const double _revealWidth = 72;
const double _cardRadius = 12;

/// Ultra-compact single-row cart item card.
///
/// Layout: [thumb 48px] · [name + inline meta] · [S3 stepper] · [price column]
/// with an X remove button at the top-right. Swiping the card to the right
/// reveals a red delete action behind it; the card snaps back when released
/// short of the threshold.
class CartItemCard extends StatefulWidget {
  final CartItem item;
  final ValueChanged<int> onQuantityChanged;
  final VoidCallback onRemove;

  const CartItemCard({
    super.key,
    required this.item,
    required this.onQuantityChanged,
    required this.onRemove,
  });

  @override
  State<CartItemCard> createState() => _CartItemCardState();
}

class _CartItemCardState extends State<CartItemCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _snap;
  double _offset = 0;

  @override
  void initState() {
    super.initState();
    _snap = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
  }

  @override
  void dispose() {
    _snap.dispose();
    super.dispose();
  }

  void _close() {
    final start = _offset;
    final anim = Tween<double>(begin: start, end: 0).animate(
      CurvedAnimation(parent: _snap, curve: Curves.easeOutCubic),
    );
    void listener() {
      setState(() => _offset = anim.value);
    }

    anim.addListener(listener);
    _snap
      ..reset()
      ..forward().whenComplete(() => anim.removeListener(listener));
  }

  void _openFull() {
    final start = _offset;
    final anim = Tween<double>(begin: start, end: _revealWidth).animate(
      CurvedAnimation(parent: _snap, curve: Curves.easeOutCubic),
    );
    void listener() {
      setState(() => _offset = anim.value);
    }

    anim.addListener(listener);
    _snap
      ..reset()
      ..forward().whenComplete(() => anim.removeListener(listener));
  }

  void _handleDragUpdate(DragUpdateDetails d) {
    setState(() {
      _offset = (_offset + d.delta.dx).clamp(0.0, _revealWidth);
    });
  }

  void _handleDragEnd(DragEndDetails d) {
    final threshold = _revealWidth * 0.5;
    if (_offset >= threshold) {
      _openFull();
    } else {
      _close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService.instance,
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(_cardRadius),
            child: Stack(
              children: [
                _DeleteBehindCard(
                  onTap: () {
                    widget.onRemove();
                  },
                  isDark: isDark,
                  revealed: _offset > 2,
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onHorizontalDragUpdate: _handleDragUpdate,
                  onHorizontalDragEnd: _handleDragEnd,
                  onTap: _offset > 0 ? _close : null,
                  child: Transform.translate(
                    offset: Offset(_offset, 0),
                    child: _CardBody(
                      item: widget.item,
                      onQuantityChanged: widget.onQuantityChanged,
                      onRemove: widget.onRemove,
                      isDark: isDark,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ─── Red "delete" action revealed behind the card ────────────────────────
class _DeleteBehindCard extends StatelessWidget {
  final VoidCallback onTap;
  final bool isDark;
  final bool revealed;

  const _DeleteBehindCard({
    required this.onTap,
    required this.isDark,
    required this.revealed,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Align(
        alignment: Alignment.centerLeft,
        child: AnimatedOpacity(
          opacity: revealed ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 120),
          child: SizedBox(
            width: _revealWidth,
            child: Material(
              color: AppColors.accentRed,
              child: InkWell(
                onTap: onTap,
                child: Center(
                  child: FaIcon(
                    FontAwesomeIcons.trashCan,
                    color: AppColors.white,
                    size: 18,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── The card body (V1 layout) ───────────────────────────────────────────
class _CardBody extends StatelessWidget {
  final CartItem item;
  final ValueChanged<int> onQuantityChanged;
  final VoidCallback onRemove;
  final bool isDark;

  const _CardBody({
    required this.item,
    required this.onQuantityChanged,
    required this.onRemove,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final glassFill = isDark
        ? AppColors.white.withValues(alpha: 0.03)
        : AppColors.white.withValues(alpha: 0.75);
    final glassBorder = isDark
        ? AppColors.white.withValues(alpha: 0.08)
        : AppColors.auroraPurple.withValues(alpha: 0.16);
    final textColor = isDark ? AppColors.white : AppColors.auroraDeepBase;
    final mutedColor = isDark
        ? AppColors.white.withValues(alpha: 0.55)
        : AppColors.auroraDeepBase.withValues(alpha: 0.65);
    final mutedColor3 = isDark
        ? AppColors.white.withValues(alpha: 0.22)
        : AppColors.auroraDeepBase.withValues(alpha: 0.30);
    final removeColor = isDark
        ? AppColors.white.withValues(alpha: 0.35)
        : AppColors.auroraDeepBase.withValues(alpha: 0.45);

    final hasDiscount = (item.product.originalPrice ?? 0) > item.product.price;
    final discountPct = hasDiscount
        ? ((1 - item.product.price / item.product.originalPrice!) * 100)
            .round()
        : 0;
    final lineTotal = item.product.price * item.quantity;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: glassFill,
        border: Border.all(color: glassBorder, width: 1),
        borderRadius: BorderRadius.circular(_cardRadius),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _Thumb(url: item.product.thumbnailUrl, isDark: isDark),
                const SizedBox(width: 10),
                Expanded(
                  child: _NameAndMeta(
                    item: item,
                    textColor: textColor,
                    mutedColor: mutedColor,
                    mutedColor3: mutedColor3,
                  ),
                ),
                const SizedBox(width: 8),
                _S3Stepper(
                  quantity: item.quantity,
                  onChanged: onQuantityChanged,
                  isDark: isDark,
                  textColor: textColor,
                ),
                const SizedBox(width: 8),
                _PriceColumn(
                  lineTotal: lineTotal,
                  discountPct: discountPct,
                  showDiscount: hasDiscount,
                ),
              ],
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onRemove,
              child: Container(
                width: 22,
                height: 22,
                alignment: Alignment.center,
                color: Colors.transparent,
                child: FaIcon(
                  FontAwesomeIcons.xmark,
                  size: 10,
                  color: removeColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Thumbnail (real image with muted glass fallback) ────────────────────
class _Thumb extends StatelessWidget {
  final String url;
  final bool isDark;

  const _Thumb({required this.url, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final fallbackFill = isDark
        ? AppColors.white.withValues(alpha: 0.04)
        : AppColors.primaryPurple.withValues(alpha: 0.06);
    final border = isDark
        ? AppColors.white.withValues(alpha: 0.08)
        : AppColors.auroraPurple.withValues(alpha: 0.16);

    Widget? image;
    if (url.isNotEmpty) {
      image = url.startsWith('http')
          ? Image.network(
              url,
              fit: BoxFit.cover,
              errorBuilder: (_, e, s) => const SizedBox.shrink(),
            )
          : Image.asset(
              url,
              fit: BoxFit.cover,
              errorBuilder: (_, e, s) => const SizedBox.shrink(),
            );
    }

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: fallbackFill,
        border: Border.all(color: border, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.hardEdge,
      child: image ?? const SizedBox.shrink(),
    );
  }
}

// ─── Name + inline meta stack ────────────────────────────────────────────
class _NameAndMeta extends StatelessWidget {
  final CartItem item;
  final Color textColor;
  final Color mutedColor;
  final Color mutedColor3;

  const _NameAndMeta({
    required this.item,
    required this.textColor,
    required this.mutedColor,
    required this.mutedColor3,
  });

  @override
  Widget build(BuildContext context) {
    final color = item.selectedColor;
    final size = item.selectedSize;
    final stock = item.product.stockCount;
    final lowStock = stock > 0 && stock <= 6;

    final metaParts = <Widget>[];
    if (color != null) {
      metaParts.add(_ColorDot(hex: color.hexCode, mutedColor3: mutedColor3));
      metaParts.add(const SizedBox(width: 4));
      metaParts.add(Flexible(
        child: Text(
          color.name,
          style: AppTextStyles.caption.copyWith(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: mutedColor,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ));
    }
    if (size != null) {
      if (metaParts.isNotEmpty) metaParts.add(_Dot(color: mutedColor3));
      metaParts.add(Text(
        'Size ${size.label}',
        style: AppTextStyles.caption.copyWith(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: mutedColor,
        ),
      ));
    }
    if (lowStock) {
      if (metaParts.isNotEmpty) metaParts.add(_Dot(color: mutedColor3));
      metaParts.add(Text(
        'Only $stock left',
        style: AppTextStyles.caption.copyWith(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          color: AppColors.auroraPink,
          letterSpacing: 0.1,
        ),
      ));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 18),
          child: Text(
            item.product.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodyMedium.copyWith(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              height: 1.2,
              letterSpacing: -0.1,
              color: textColor,
            ),
          ),
        ),
        if (metaParts.isNotEmpty) ...[
          const SizedBox(height: 4),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 4,
            runSpacing: 2,
            children: metaParts,
          ),
        ],
      ],
    );
  }
}

class _ColorDot extends StatelessWidget {
  final String hex;
  final Color mutedColor3;

  const _ColorDot({required this.hex, required this.mutedColor3});

  @override
  Widget build(BuildContext context) {
    Color parsed;
    try {
      final cleaned = hex.replaceAll('#', '');
      final value = int.parse(
        cleaned.length == 6 ? 'FF$cleaned' : cleaned,
        radix: 16,
      );
      parsed = Color(value);
    } catch (_) {
      parsed = mutedColor3;
    }
    return Container(
      width: 7,
      height: 7,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: parsed,
        border: Border.all(color: mutedColor3, width: 0.5),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final Color color;
  const _Dot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      '·',
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: color,
        height: 1,
      ),
    );
  }
}

// ─── S3 stepper — 20px buttons ───────────────────────────────────────────
class _S3Stepper extends StatelessWidget {
  final int quantity;
  final ValueChanged<int> onChanged;
  final bool isDark;
  final Color textColor;

  const _S3Stepper({
    required this.quantity,
    required this.onChanged,
    required this.isDark,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final chipFill = isDark
        ? AppColors.white.withValues(alpha: 0.04)
        : AppColors.white;
    final chipBorder = isDark
        ? AppColors.white.withValues(alpha: 0.10)
        : AppColors.auroraPurple.withValues(alpha: 0.18);

    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: chipFill,
        border: Border.all(color: chipBorder, width: 1),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepperButton(
            icon: FontAwesomeIcons.minus,
            color: AppColors.auroraPink,
            enabled: quantity > 1,
            onTap: () => onChanged(quantity - 1),
          ),
          const SizedBox(width: 2),
          SizedBox(
            width: 20,
            child: Center(
              child: Text(
                '$quantity',
                style: AppTextStyles.caption.copyWith(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w800,
                  color: textColor,
                  height: 1,
                ),
              ),
            ),
          ),
          const SizedBox(width: 2),
          _StepperButton(
            icon: FontAwesomeIcons.plus,
            color: AppColors.auroraElectricBlue,
            enabled: true,
            onTap: () => onChanged(quantity + 1),
          ),
        ],
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  final FaIconData icon;
  final Color color;
  final bool enabled;
  final VoidCallback onTap;

  const _StepperButton({
    required this.icon,
    required this.color,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1.0 : 0.35,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: enabled ? onTap : null,
        child: Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(5),
          ),
          alignment: Alignment.center,
          child: FaIcon(icon, size: 7.5, color: color),
        ),
      ),
    );
  }
}

// ─── Price column (gradient total + optional -XX%) ──────────────────────
class _PriceColumn extends StatelessWidget {
  final double lineTotal;
  final int discountPct;
  final bool showDiscount;

  const _PriceColumn({
    required this.lineTotal,
    required this.discountPct,
    required this.showDiscount,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 62,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ShaderMask(
            shaderCallback: (rect) => const LinearGradient(
              colors: [AppColors.auroraPink, AppColors.auroraElectricBlue],
            ).createShader(rect),
            child: Text(
              '\$${lineTotal.toStringAsFixed(2)}',
              textAlign: TextAlign.right,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.productPrice.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w900,
                color: AppColors.white,
                letterSpacing: -0.2,
                height: 1.1,
              ),
            ),
          ),
          if (showDiscount) ...[
            const SizedBox(height: 2),
            Text(
              '−$discountPct%',
              style: AppTextStyles.caption.copyWith(
                fontSize: 9.5,
                fontWeight: FontWeight.w800,
                color: AppColors.auroraPink,
                letterSpacing: 0.2,
                height: 1,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
