import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../backend_integration/dtos/item/item_detail_dto.dart';
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

  final List<ItemDetailColorDto> colors;
  final ItemDetailColorDto? selected;
  final ValueChanged<ItemDetailColorDto> onSelected;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService.instance,
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;
        final mutedLabel =
            (isDark ? AppColors.white : AppColors.primaryPurple)
                .withValues(alpha: 0.65);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'color_selector.color_label'.tr(),
              style: AppFonts.primary(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: mutedLabel,
                letterSpacing: 1.4,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: colors.map((c) {
                final available =
                    c.sizes.isEmpty || c.sizes.any((s) => s.stock > 0);
                return ColorSwatchWidget(
                  color: c,
                  selected: selected == c,
                  isAvailable: available,
                  onTap: () => onSelected(c),
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}
