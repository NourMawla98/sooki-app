import 'package:flutter/material.dart';

import '../../../../services/theme_service.dart';
import '../../../../themes/themes.dart';

class ProductInfo extends StatelessWidget {
  const ProductInfo({
    super.key,
    required this.categoryName,
    required this.title,
    this.subtitle,
    required this.stock,
    this.brand,
    this.description,
  });

  final String categoryName;
  final String title;
  final String? subtitle;
  final int stock;
  final String? brand;
  final String? description;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService.instance,
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;
        final textColor = isDark ? AppColors.white : AppColors.primaryPurple;
        final mutedColor =
            (isDark ? AppColors.white : AppColors.primaryPurple)
                .withValues(alpha: 0.55);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Category chip + stock pill ──────────────────────────────────
            Row(
              children: [
                _CategoryChip(categoryName: categoryName, isDark: isDark),
                const SizedBox(width: 10),
                _StockPill(stockCount: stock),
              ],
            ),
            const SizedBox(height: 14),

            // ── Title ───────────────────────────────────────────────────────
            Text(
              title,
              style: AppFonts.primary(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: textColor,
                height: 1.2,
                letterSpacing: -0.2,
              ),
            ),

            // ── Subtitle ────────────────────────────────────────────────────
            if (subtitle != null) ...[
              const SizedBox(height: 6),
              Text(
                subtitle!,
                style: AppFonts.primary(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: mutedColor,
                  height: 1.3,
                ),
              ),
            ],

            // ── Brand pill (optional) ────────────────────────────────────────
            if (brand != null) ...[
              const SizedBox(height: 12),
              _BrandPill(brand: brand!, isDark: isDark),
            ],

            const SizedBox(height: 18),

            // ── About glass box ─────────────────────────────────────────────
            if (description != null && description!.isNotEmpty)
              _AboutGlass(description: description!, isDark: isDark),
          ],
        );
      },
    );
  }
}

// ─── Category chip ────────────────────────────────────────────────────────────

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.categoryName, required this.isDark});

  final String categoryName;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final base = isDark ? AppColors.auroraPurple : AppColors.primaryPurple;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: base.withValues(alpha: 0.12),
        border: Border.all(color: base.withValues(alpha: isDark ? 0.30 : 0.22)),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        categoryName.toUpperCase(),
        style: AppFonts.primary(
          fontSize: 9,
          fontWeight: FontWeight.w800,
          color: base,
          letterSpacing: 1.4,
          height: 1.1,
        ),
      ),
    );
  }
}

// ─── Stock pill ───────────────────────────────────────────────────────────────

class _StockPill extends StatelessWidget {
  const _StockPill({required this.stockCount});
  final int stockCount;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (stockCount) {
      <= 0 => ('Out of stock', AppColors.accentRed),
      < 5 => ('Only $stockCount left', AppColors.accentYellow),
      _ => ('In stock', AppColors.verifiedGreen),
    };

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: AppFonts.primary(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: color,
            height: 1.1,
          ),
        ),
      ],
    );
  }
}

// ─── Brand pill ───────────────────────────────────────────────────────────────

class _BrandPill extends StatelessWidget {
  const _BrandPill({required this.brand, required this.isDark});

  final String brand;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final fillColor = (isDark ? AppColors.white : AppColors.primaryPurple)
        .withValues(alpha: 0.05);
    final borderColor = (isDark ? AppColors.white : AppColors.primaryPurple)
        .withValues(alpha: 0.12);
    final labelColor = (isDark ? AppColors.white : AppColors.primaryPurple)
        .withValues(alpha: 0.30);
    final sepColor = (isDark ? AppColors.white : AppColors.primaryPurple)
        .withValues(alpha: 0.15);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: fillColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'BRAND',
            style: AppFonts.primary(
              fontSize: 8,
              fontWeight: FontWeight.w800,
              color: labelColor,
              letterSpacing: 1.2,
              height: 1.1,
            ),
          ),
          const SizedBox(width: 7),
          Container(width: 1, height: 10, color: sepColor),
          const SizedBox(width: 7),
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: AppColors.auroraGradient,
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
            blendMode: BlendMode.srcIn,
            child: Text(
              brand,
              style: AppFonts.primary(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: AppColors.white,
                height: 1.1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── About glass box ─────────────────────────────────────────────────────────

class _AboutGlass extends StatefulWidget {
  const _AboutGlass({required this.description, required this.isDark});

  final String description;
  final bool isDark;

  @override
  State<_AboutGlass> createState() => _AboutGlassState();
}

class _AboutGlassState extends State<_AboutGlass> {
  bool _expanded = false;

  bool _overflows(double maxWidth) {
    final tp = TextPainter(
      text: TextSpan(
        text: widget.description,
        style: AppFonts.primary(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.white,
          height: 1.65,
        ),
      ),
      maxLines: 3,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: maxWidth);
    return tp.didExceedMaxLines;
  }

  @override
  Widget build(BuildContext context) {
    final base = widget.isDark ? AppColors.white : AppColors.primaryPurple;
    final fillColor = base.withValues(alpha: 0.04);
    final borderColor = base.withValues(alpha: widget.isDark ? 0.08 : 0.10);
    final labelColor = base.withValues(alpha: widget.isDark ? 0.28 : 0.40);
    final textColor = base.withValues(alpha: widget.isDark ? 0.55 : 0.60);

    return LayoutBuilder(
      builder: (context, constraints) {
        final needsToggle = _overflows(constraints.maxWidth - 32);
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: fillColor,
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ABOUT THIS ITEM',
                style: AppFonts.primary(
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  color: labelColor,
                  letterSpacing: 1.8,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                widget.description,
                maxLines: _expanded ? null : 3,
                overflow:
                    _expanded ? TextOverflow.visible : TextOverflow.ellipsis,
                style: AppFonts.primary(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                  height: 1.65,
                ),
              ),
              if (needsToggle) ...[
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => setState(() => _expanded = !_expanded),
                  behavior: HitTestBehavior.opaque,
                  child: ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: AppColors.auroraGradient,
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ).createShader(
                        Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                    blendMode: BlendMode.srcIn,
                    child: Text(
                      _expanded ? 'Show less' : 'Read more',
                      style: AppFonts.primary(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.white,
                        height: 1.1,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
