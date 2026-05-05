import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../services/cart_service.dart';
import '../../services/theme_service.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_text_styles.dart';

class CartItemCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService.instance,
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;
        final fill = isDark
            ? AppColors.white.withValues(alpha: 0.05)
            : AppColors.white.withValues(alpha: 0.80);
        final border = isDark
            ? AppColors.white.withValues(alpha: 0.10)
            : AppColors.auroraPurple.withValues(alpha: 0.18);
        final textColor = isDark ? AppColors.white : AppColors.auroraDeepBase;
        final muteColor = isDark
            ? AppColors.white.withValues(alpha: 0.50)
            : AppColors.auroraDeepBase.withValues(alpha: 0.60);

        final lineTotal = item.product.price * item.quantity;
        final hasDiscount =
            (item.product.originalPrice ?? 0) > item.product.price;
        final discountPct = hasDiscount
            ? ((1 - item.product.price / item.product.originalPrice!) * 100)
                .round()
            : 0;

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: fill,
            border: Border.all(color: border),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Thumb(url: item.product.thumbnailUrl, isDark: isDark),
                const SizedBox(width: 10),
                Expanded(
                  child: _Info(
                    item: item,
                    textColor: textColor,
                    muteColor: muteColor,
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: onRemove,
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: FaIcon(FontAwesomeIcons.xmark,
                            size: 11, color: muteColor),
                      ),
                    ),
                    _RightBottom(
                      quantity: item.quantity,
                      lineTotal: lineTotal,
                      discountPct: discountPct,
                      showDiscount: hasDiscount,
                      onQuantityChanged: onQuantityChanged,
                      isDark: isDark,
                      textColor: textColor,
                      muteColor: muteColor,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ─── Thumbnail ───────────────────────────────────────────────────────────
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

    final fallback = Center(
      child: FaIcon(FontAwesomeIcons.image, size: 16, color: iconColor),
    );

    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: placeholderColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.hardEdge,
      child: url.isNotEmpty
          ? Image(
              image: url.startsWith('http')
                  ? NetworkImage(url)
                  : AssetImage(url) as ImageProvider,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stack) => fallback,
            )
          : fallback,
    );
  }
}

// ─── Name + color/size meta ───────────────────────────────────────────────
class _Info extends StatelessWidget {
  final CartItem item;
  final Color textColor;
  final Color muteColor;

  const _Info({
    required this.item,
    required this.textColor,
    required this.muteColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = item.selectedColor;
    final size = item.selectedSize;
    final stock = item.product.stockCount;
    final lowStock = stock > 0 && stock <= 6;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          item.product.name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.bodyMedium.copyWith(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: textColor,
            height: 1.2,
          ),
        ),
        if (color != null || size != null || lowStock) ...[
          const SizedBox(height: 4),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 5,
            runSpacing: 2,
            children: [
              if (color != null) ...[
                _ColorDot(hex: color.hexCode),
                Text(
                  color.name,
                  style: AppTextStyles.caption.copyWith(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: muteColor,
                  ),
                ),
              ],
              if (size != null)
                Text(
                  'Size ${size.label}',
                  style: AppTextStyles.caption.copyWith(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: muteColor,
                  ),
                ),
              if (lowStock)
                Text(
                  'Only $stock left',
                  style: AppTextStyles.caption.copyWith(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: AppColors.auroraPink,
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }
}

class _ColorDot extends StatelessWidget {
  final String hex;
  const _ColorDot({required this.hex});

  @override
  Widget build(BuildContext context) {
    Color color;
    try {
      final v =
          int.parse('FF${hex.replaceAll('#', '')}', radix: 16);
      color = Color(v);
    } catch (_) {
      color = AppColors.auroraPurple;
    }
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}

// ─── Price + stepper, sits at the bottom of the right column ─────────────
class _RightBottom extends StatelessWidget {
  final int quantity;
  final double lineTotal;
  final int discountPct;
  final bool showDiscount;
  final ValueChanged<int> onQuantityChanged;
  final bool isDark;
  final Color textColor;
  final Color muteColor;

  const _RightBottom({
    required this.quantity,
    required this.lineTotal,
    required this.discountPct,
    required this.showDiscount,
    required this.onQuantityChanged,
    required this.isDark,
    required this.textColor,
    required this.muteColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ShaderMask(
              shaderCallback: (rect) => const LinearGradient(
                colors: [AppColors.auroraPink, AppColors.auroraElectricBlue],
              ).createShader(rect),
              child: Text(
                '\$${lineTotal.toStringAsFixed(2)}',
                style: AppTextStyles.productPrice.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: AppColors.white,
                  letterSpacing: -0.2,
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
                ),
              ),
            ],
          ],
        ),
        const SizedBox(width: 8),
        _Stepper(
          quantity: quantity,
          onChanged: onQuantityChanged,
          isDark: isDark,
          textColor: textColor,
        ),
      ],
    );
  }
}

// ─── Quantity stepper ─────────────────────────────────────────────────────
class _Stepper extends StatelessWidget {
  final int quantity;
  final ValueChanged<int> onChanged;
  final bool isDark;
  final Color textColor;

  const _Stepper({
    required this.quantity,
    required this.onChanged,
    required this.isDark,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final chipFill =
        isDark ? AppColors.white.withValues(alpha: 0.04) : AppColors.white;
    final chipBorder = isDark
        ? AppColors.white.withValues(alpha: 0.10)
        : AppColors.auroraPurple.withValues(alpha: 0.18);

    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: chipFill,
        border: Border.all(color: chipBorder),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepBtn(
            icon: FontAwesomeIcons.minus,
            color: AppColors.auroraPink,
            enabled: quantity > 1,
            onTap: () => onChanged(quantity - 1),
          ),
          SizedBox(
            width: 24,
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
          _StepBtn(
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


class _StepBtn extends StatelessWidget {
  final FaIconData icon;
  final Color color;
  final bool enabled;
  final VoidCallback onTap;

  const _StepBtn({
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
