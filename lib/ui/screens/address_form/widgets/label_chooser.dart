import 'package:flutter/material.dart';

import '../../../../services/theme_service.dart';
import '../../../../themes/app_colors.dart';
import '../../../../themes/app_text_styles.dart';

enum AddressLabelType { home, office, other }

class LabelChooser extends StatelessWidget {
  final AddressLabelType selected;
  final ValueChanged<AddressLabelType> onChanged;

  const LabelChooser({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService.instance,
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;
        return Row(
          children: [
            Expanded(child: _pill(AddressLabelType.home, 'Home', isDark)),
            const SizedBox(width: 8),
            Expanded(child: _pill(AddressLabelType.office, 'Office', isDark)),
            const SizedBox(width: 8),
            Expanded(child: _pill(AddressLabelType.other, 'Other', isDark)),
          ],
        );
      },
    );
  }

  Widget _pill(AddressLabelType type, String label, bool isDark) {
    final isSelected = selected == type;
    final innerFill = isDark ? AppColors.auroraDeepBase : AppColors.white;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onChanged(type),
      child: SizedBox(
        height: 40,
        child: isSelected
            // Selected → secondary active: gradient border + gradient text
            ? DecoratedBox(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: AppColors.auroraGradient,
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(1.5),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: innerFill,
                      borderRadius: BorderRadius.circular(8.5),
                    ),
                    child: Center(
                      child: ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: AppColors.auroraGradient,
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ).createShader(
                          Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                        ),
                        blendMode: BlendMode.srcIn,
                        child: Text(
                          label,
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.3,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            // Not selected → secondary disabled: faded secondary active
            : Opacity(
                opacity: 0.38,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: AppColors.auroraGradient,
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(1.5),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: innerFill,
                        borderRadius: BorderRadius.circular(8.5),
                      ),
                      child: Center(
                        child: ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: AppColors.auroraGradient,
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ).createShader(
                            Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                          ),
                          blendMode: BlendMode.srcIn,
                          child: Text(
                            label,
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.3,
                              color: AppColors.white,
                            ),
                          ),
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
