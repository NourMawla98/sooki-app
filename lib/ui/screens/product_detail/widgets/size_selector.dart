import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../backend_integration/dtos/item/item_detail_dto.dart';
import '../../../../services/theme_service.dart';
import '../../../../themes/themes.dart';
import 'size_guide_data.dart';

class SizeSelector extends StatelessWidget {
  const SizeSelector({
    super.key,
    required this.sizes,
    required this.selected,
    required this.onSelected,
    required this.onSizeGuide,
    this.standardName,
  });

  final List<ItemDetailSizeDto> sizes;
  final ItemDetailSizeDto? selected;
  final ValueChanged<ItemDetailSizeDto> onSelected;
  final VoidCallback onSizeGuide;
  final String? standardName;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService.instance,
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;
        final mutedLabel =
            (isDark ? AppColors.white : AppColors.primaryPurple)
                .withValues(alpha: 0.65);
        final strongLabel =
            isDark ? AppColors.white : AppColors.primaryPurple;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      'SIZE',
                      style: AppFonts.primary(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: mutedLabel,
                        letterSpacing: 1.4,
                        height: 1.1,
                      ),
                    ),
                    if (selected != null) ...[
                      const SizedBox(width: 6),
                      Text(
                        '·',
                        style: AppFonts.primary(
                          fontSize: 11,
                          color: mutedLabel,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        selected!.displayValue,
                        style: AppFonts.primary(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: strongLabel,
                          height: 1.1,
                        ),
                      ),
                    ],
                  ],
                ),
                if (kSizeGuides.containsKey(standardName))
                GestureDetector(
                  onTap: onSizeGuide,
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.auroraElectricBlue
                          .withValues(alpha: 0.10),
                      border: Border.all(
                        color: AppColors.auroraElectricBlue
                            .withValues(alpha: 0.45),
                      ),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'SIZE GUIDE',
                          style: AppFonts.primary(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: AppColors.auroraElectricBlue,
                            letterSpacing: 0.8,
                            height: 1.0,
                          ),
                        ),
                        const SizedBox(width: 5),
                        const FaIcon(
                          FontAwesomeIcons.chevronRight,
                          size: 9,
                          color: AppColors.auroraElectricBlue,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: sizes.map((size) {
                final isAvailable = size.stock > 0;
                return _SizeChip(
                  label: size.displayValue,
                  isSelected: selected == size,
                  isAvailable: isAvailable,
                  isDark: isDark,
                  onTap: isAvailable ? () => onSelected(size) : null,
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}

class _SizeChip extends StatelessWidget {
  const _SizeChip({
    required this.label,
    required this.isSelected,
    required this.isAvailable,
    required this.isDark,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final bool isAvailable;
  final bool isDark;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final innerFill =
        isDark ? AppColors.auroraDeepBase : AppColors.auroraLightBase;

    Widget chip = DecoratedBox(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: AppColors.auroraGradient,
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: const EdgeInsets.all(1.5),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: innerFill,
            borderRadius: BorderRadius.circular(4.5),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: AppColors.auroraGradient,
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ).createShader(
                  Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
              blendMode: BlendMode.srcIn,
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: AppFonts.primary(
                  fontSize: 12,
                  fontWeight:
                      isSelected ? FontWeight.w800 : FontWeight.w600,
                  color: AppColors.white,
                  decoration: !isAvailable
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                  decorationColor: AppColors.white,
                  letterSpacing: 0.3,
                  height: 1.1,
                ),
              ),
            ),
          ),
        ),
      ),
    );

    final opacity =
        !isAvailable ? 0.18 : (!isSelected ? 0.38 : 1.0);
    if (opacity < 1.0) chip = Opacity(opacity: opacity, child: chip);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: chip,
    );
  }
}
