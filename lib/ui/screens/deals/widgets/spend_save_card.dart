import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../backend_integration/dtos/cart/cart_dto.dart';
import '../../../../models/deal_progress.dart';
import '../../../../themes/app_colors.dart';
import '../../../../themes/app_text_styles.dart';
import '../../../../utils/number_localization.dart';
import '../../../reusable_components/product_card/product_grid_card.dart';
import 'deal_card_parts.dart';

/// Spend and save: a striped bar fills with the cart's eligible subtotal
/// toward the threshold, and the card lights up once it is reached.
class SpendSaveCard extends StatelessWidget {
  final SpendDealDto spendDeal;
  final bool isDark;

  const SpendSaveCard({
    super.key,
    required this.spendDeal,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final palette = DealPalette(isDark);
    final progress = SpendProgress(spendDeal);
    final percent = localizedNumber(spendDeal.discountPercent.round());
    final threshold = formatCardPrice(spendDeal.spendThreshold);

    return DealCardShell(
      isDark: isDark,
      unlocked: progress.unlocked,
      padding: const EdgeInsets.all(14),
      gradient: LinearGradient(
        begin: AlignmentDirectional.topStart,
        end: AlignmentDirectional.bottomEnd,
        colors: [
          palette.surface,
          palette.surface,
          AppColors.auroraGold.withValues(alpha: isDark ? 0.14 : 0.16),
        ],
        stops: const [0, 0.55, 1],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          DealCardHead(
            unlocked: progress.unlocked,
            label: DealTypeLabel(
              icon: FontAwesomeIcons.cartShopping,
              label: 'deals.types.spend_label'.tr(),
              tint: AppColors.auroraPink,
              isDark: isDark,
            ),
          ),
          const SizedBox(height: 8),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'deals.spend.headline_start'.tr(
                    namedArgs: {'amount': threshold},
                  ),
                ),
                TextSpan(
                  text: 'deals.spend.headline_percent'.tr(
                    namedArgs: {'percent': percent},
                  ),
                  style: const TextStyle(color: AppColors.auroraPink),
                ),
                TextSpan(text: 'deals.spend.headline_end'.tr()),
              ],
            ),
            style: AppTextStyles.heading3.copyWith(
              color: palette.text,
              fontSize: 17,
              fontWeight: FontWeight.w800,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 16),
          _StripedBar(
            fraction: progress.fraction,
            win: progress.unlocked,
            isDark: isDark,
          ),
          const SizedBox(height: 10),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            spacing: 8,
            runSpacing: 4,
            children: [
              Text(
                'deals.spend.cart_of'.tr(
                  namedArgs: {
                    'amount': formatCardPrice(spendDeal.eligibleSubtotal),
                    'threshold': threshold,
                  },
                ),
                style: AppTextStyles.bodySmall.copyWith(
                  color: palette.text,
                  fontSize: 13,
                ),
              ),
              Text(
                progress.unlocked
                    ? 'deals.spend.unlocked'.tr(
                        namedArgs: {
                          'percent': percent,
                          'amount': formatCardPrice(progress.saving),
                        },
                      )
                    : 'deals.spend.away'.tr(
                        namedArgs: {
                          'amount': formatCardPrice(progress.remaining),
                        },
                      ),
                style: AppTextStyles.bodySmall.copyWith(
                  color: progress.unlocked ? palette.win : palette.ink,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// A rounded bar with moving diagonal stripes, filling to [fraction], with a
/// gift goal at the end. It turns green and the goal bumps once [win].
class _StripedBar extends StatefulWidget {
  final double fraction;
  final bool win;
  final bool isDark;

  const _StripedBar({
    required this.fraction,
    required this.win,
    required this.isDark,
  });

  @override
  State<_StripedBar> createState() => _StripedBarState();
}

class _StripedBarState extends State<_StripedBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _stripes = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 1),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (reduceMotionOf(context)) {
      _stripes.stop();
    } else if (!_stripes.isAnimating) {
      _stripes.repeat();
    }
  }

  @override
  void dispose() {
    _stripes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = DealPalette(widget.isDark);
    final reduce = reduceMotionOf(context);
    final colors = widget.win
        ? [
            AppColors.verifiedGreen,
            AppColors.verifiedGreen.withValues(alpha: 0.75),
          ]
        : [AppColors.auroraPurple, AppColors.auroraElectricBlue];

    return SizedBox(
      height: 34,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: AlignmentDirectional.centerStart,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 14),
            child: Container(
              height: 22,
              decoration: BoxDecoration(
                color: palette.surfaceSoft,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: palette.border),
              ),
              clipBehavior: Clip.antiAlias,
              child: TweenAnimationBuilder<double>(
                tween: Tween(end: widget.fraction),
                duration: reduce
                    ? Duration.zero
                    : const Duration(milliseconds: 700),
                curve: Curves.easeOutBack,
                builder: (context, value, _) => FractionallySizedBox(
                  alignment: AlignmentDirectional.centerStart,
                  widthFactor: value.clamp(0.0, 1.0),
                  child: AnimatedBuilder(
                    animation: _stripes,
                    builder: (context, _) => CustomPaint(
                      painter: _StripePainter(
                        colors: colors,
                        shift: _stripes.value,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          PositionedDirectional(
            end: 0,
            child: AnimatedScale(
              scale: widget.win ? 1.15 : 1,
              duration: reduce
                  ? Duration.zero
                  : const Duration(milliseconds: 300),
              curve: Curves.elasticOut,
              child: Container(
                width: 34,
                height: 34,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.auroraGold,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: widget.isDark
                        ? AppColors.auroraDeepBase
                        : AppColors.white,
                    width: 3,
                  ),
                ),
                child: const FaIcon(
                  FontAwesomeIcons.gift,
                  size: 14,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StripePainter extends CustomPainter {
  final List<Color> colors;
  final double shift;

  _StripePainter({required this.colors, required this.shift});

  static const double _band = 10;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.clipRRect(RRect.fromRectAndRadius(rect, const Radius.circular(12)));
    canvas.drawRect(rect, Paint()..color = colors.first);
    final paint = Paint()..color = colors.last;
    final offset = shift * _band * 2;
    for (
      var x = -size.height - _band * 2 + offset;
      x < size.width + size.height;
      x += _band * 2
    ) {
      final path = Path()
        ..moveTo(x, size.height)
        ..lineTo(x + _band, size.height)
        ..lineTo(x + _band + size.height, 0)
        ..lineTo(x + size.height, 0)
        ..close();
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_StripePainter oldDelegate) =>
      oldDelegate.shift != shift || oldDelegate.colors != colors;
}
