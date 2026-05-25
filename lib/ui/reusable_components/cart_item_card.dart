import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../backend_integration/dtos/cart/cart_dto.dart';
import '../../services/theme_service.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_text_styles.dart';

class CartItemCard extends StatelessWidget {
  final CartLineItem item;
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
                _Thumb(url: item.imageUrl, isDark: isDark),
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
                      lineTotal: item.lineTotal,
                      stock: item.stock,
                      isAvailable: item.isAvailable,
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

// ─── Thumbnail ────────────────────────────────────────────────────────────────

class _Thumb extends StatelessWidget {
  final String? url;
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
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: placeholderColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.hardEdge,
      child: (url != null && url!.isNotEmpty)
          ? Image.network(
              url!,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => fallback,
            )
          : fallback,
    );
  }
}

// ─── Name + meta ──────────────────────────────────────────────────────────────

class _Info extends StatelessWidget {
  final CartLineItem item;
  final Color textColor;
  final Color muteColor;

  const _Info({
    required this.item,
    required this.textColor,
    required this.muteColor,
  });

  @override
  Widget build(BuildContext context) {
    final lowStock = item.stock > 0 && item.stock <= 6;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          item.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.bodyMedium.copyWith(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: textColor,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 4),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 5,
          runSpacing: 2,
          children: [
            Text(
              item.colorName,
              style: AppTextStyles.caption.copyWith(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: muteColor,
              ),
            ),
            Text(
              'Size ${item.sizeName}',
              style: AppTextStyles.caption.copyWith(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: muteColor,
              ),
            ),
            if (lowStock)
              Text(
                'Only ${item.stock} left',
                style: AppTextStyles.caption.copyWith(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: AppColors.auroraPink,
                ),
              ),
            if (!item.isAvailable)
              Text(
                'Unavailable',
                style: AppTextStyles.caption.copyWith(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: AppColors.accentRed,
                ),
              ),
          ],
        ),
      ],
    );
  }
}

// ─── Price + stepper ──────────────────────────────────────────────────────────

class _RightBottom extends StatelessWidget {
  final int quantity;
  final double lineTotal;
  final int stock;
  final bool isAvailable;
  final ValueChanged<int> onQuantityChanged;
  final bool isDark;
  final Color textColor;
  final Color muteColor;

  const _RightBottom({
    required this.quantity,
    required this.lineTotal,
    required this.stock,
    required this.isAvailable,
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
        const SizedBox(width: 8),
        _Stepper(
          quantity: quantity,
          maxStock: stock,
          isAvailable: isAvailable,
          onChanged: onQuantityChanged,
          isDark: isDark,
          textColor: textColor,
        ),
      ],
    );
  }
}

// ─── Quantity stepper ──────────────────────────────────────────────────────────

class _Stepper extends StatelessWidget {
  final int quantity;
  final int maxStock;
  final bool isAvailable;
  final ValueChanged<int> onChanged;
  final bool isDark;
  final Color textColor;

  const _Stepper({
    required this.quantity,
    required this.maxStock,
    required this.isAvailable,
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

    final minusEnabled = quantity > 1;
    final plusEnabled = isAvailable && (maxStock == 0 || quantity < maxStock);

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
            enabled: minusEnabled,
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
            enabled: plusEnabled,
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
