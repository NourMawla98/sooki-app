import 'package:flutter/material.dart';

import '../../../../models/product.dart';
import '../../../../services/theme_service.dart';
import '../../../../themes/themes.dart';
import '../../../reusable_components/swatch/color_swatch_widget.dart';

class ColorSelector extends StatelessWidget {
  const ColorSelector({
    super.key,
    required this.colors,
    this.selected,
    required this.onSelected,
  });

  final List<ColorVariant> colors;
  final ColorVariant? selected;
  final ValueChanged<ColorVariant> onSelected;

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
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  'COLOR',
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
                  Flexible(
                    child: Text(
                      selected!.name,
                      style: AppFonts.primary(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: strongLabel,
                        height: 1.1,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: colors
                  .map(
                    (variant) => ColorSwatchWidget(
                      variant: variant,
                      selected: selected == variant,
                      onTap: () => onSelected(variant),
                    ),
                  )
                  .toList(),
            ),
          ],
        );
      },
    );
  }
}
