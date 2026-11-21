import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../themes/app_colors.dart';
import '../../../../themes/app_text_styles.dart';
import '../../../../utils/number_localization.dart';
import 'deal_card_parts.dart';

/// The banner on top of the Deals tab: how many deals are live, a live
/// countdown to the soonest one ending, and a button down to the deals.
class DealsHero extends StatelessWidget {
  final int liveCount;
  final DateTime? endsAt;
  final VoidCallback onShop;
  final VoidCallback? onElapsed;

  const DealsHero({
    super.key,
    required this.liveCount,
    required this.endsAt,
    required this.onShop,
    this.onElapsed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.auroraPurple, AppColors.auroraElectricBlue],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.auroraPurple.withValues(alpha: 0.30),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          _Blob(top: -50, end: -40, size: 160, color: AppColors.auroraGold, alpha: 0.22),
          _Blob(bottom: -40, end: 60, size: 90, color: AppColors.auroraPink, alpha: 0.35),
          const PositionedDirectional(
            top: 18,
            start: 200,
            child: LoopingFloat(
              child: _Dot(size: 16, color: AppColors.verifiedGreen),
            ),
          ),
          const PositionedDirectional(
            top: 90,
            end: 40,
            child: LoopingFloat(
              period: Duration(milliseconds: 2500),
              child: _Dot(size: 10, color: AppColors.auroraGold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const FaIcon(FontAwesomeIcons.bolt, size: 10, color: AppColors.white),
                      const SizedBox(width: 6),
                      Text(
                        'deals.hero.eyebrow'.tr(
                          namedArgs: {'count': localizedNumber(liveCount)},
                        ).toUpperCase(),
                        style: AppTextStyles.captionSmall.copyWith(
                          color: AppColors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: 'deals.hero.title_start'.tr()),
                      TextSpan(
                        text: 'deals.hero.title_highlight'.tr(),
                        style: const TextStyle(color: AppColors.auroraGold),
                      ),
                    ],
                  ),
                  style: AppTextStyles.heading2.copyWith(
                    color: AppColors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  endsAt == null
                      ? 'deals.hero.subtitle'.tr()
                      : 'deals.hero.subtitle_ends'.tr(),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.white.withValues(alpha: 0.9),
                    fontSize: 13,
                  ),
                ),
                if (endsAt != null) ...[
                  const SizedBox(height: 10),
                  DealTicker(
                    target: endsAt,
                    onElapsed: onElapsed,
                    builder: (context, remaining) => _CountdownBoxes(remaining: remaining),
                  ),
                ],
                const SizedBox(height: 16),
                _ShopButton(onTap: onShop),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CountdownBoxes extends StatelessWidget {
  final Duration remaining;

  const _CountdownBoxes({required this.remaining});

  @override
  Widget build(BuildContext context) {
    String two(int n) => localizedDigits(n.toString().padLeft(2, '0'));
    // A day or more shows a days box, and hours then run 0 to 23.
    final days = remaining.inDays;
    final parts = [
      if (days > 0) (localizedNumber(days), 'deals.hero.days'.tr()),
      (two(remaining.inHours % 24), 'deals.hero.hours'.tr()),
      (two(remaining.inMinutes % 60), 'deals.hero.minutes'.tr()),
      (two(remaining.inSeconds % 60), 'deals.hero.seconds'.tr()),
    ];
    final colon = Text(
      ':',
      style: AppTextStyles.heading3.copyWith(
        color: AppColors.white,
        fontSize: 20,
        fontWeight: FontWeight.w800,
      ),
    );

    // Hours, minutes, seconds read left to right in every language.
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < parts.length; i++) ...[
            if (i > 0) Padding(padding: const EdgeInsets.symmetric(horizontal: 6), child: colon),
            _TimeBox(value: parts[i].$1, label: parts[i].$2),
          ],
        ],
      ),
    );
  }
}

class _TimeBox extends StatelessWidget {
  final String value;
  final String label;

  const _TimeBox({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    final reduce = reduceMotionOf(context);
    return Container(
      constraints: const BoxConstraints(minWidth: 54),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.white.withValues(alpha: 0.25)),
      ),
      child: Column(
        children: [
          AnimatedSwitcher(
            duration: reduce ? Duration.zero : const Duration(milliseconds: 350),
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween(begin: const Offset(0, -0.3), end: Offset.zero)
                    .animate(animation),
                child: child,
              ),
            ),
            child: Text(
              value,
              key: ValueKey(value),
              style: AppTextStyles.auroraMonoPrice.copyWith(
                color: AppColors.white,
                fontSize: 22,
                fontWeight: FontWeight.w800,
                height: 1.1,
              ),
            ),
          ),
          Text(
            label.toUpperCase(),
            style: AppTextStyles.captionSmall.copyWith(
              color: AppColors.white.withValues(alpha: 0.85),
              fontSize: 9,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}

class _ShopButton extends StatelessWidget {
  final VoidCallback onTap;

  const _ShopButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.auroraGold,
      borderRadius: BorderRadius.circular(12),
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const FaIcon(FontAwesomeIcons.fire, size: 14, color: AppColors.auroraDeepBase),
              const SizedBox(width: 8),
              Text(
                'deals.hero.shop'.tr(),
                style: AppTextStyles.buttonMedium.copyWith(
                  color: AppColors.auroraDeepBase,
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Blob extends StatelessWidget {
  final double? top;
  final double? bottom;
  final double end;
  final double size;
  final Color color;
  final double alpha;

  const _Blob({
    this.top,
    this.bottom,
    required this.end,
    required this.size,
    required this.color,
    required this.alpha,
  });

  @override
  Widget build(BuildContext context) {
    return PositionedDirectional(
      top: top,
      bottom: bottom,
      end: end,
      child: IgnorePointer(
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: color.withValues(alpha: alpha),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final double size;
  final Color color;

  const _Dot({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
