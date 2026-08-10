import 'package:flutter/material.dart';

import '../../../themes/app_colors.dart';

/// Aurora-styled toggle switch.
///
/// Pass [activeColor] for a solid on-state. Omit it (or pass null) to use
/// the aurora gradient (auroraPurple -> auroraElectricBlue).
class AuroraSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color? activeColor;
  final bool isDark;

  const AuroraSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final offColor = isDark
        ? AppColors.white.withValues(alpha: 0.14)
        : AppColors.auroraPurple.withValues(alpha: 0.14);

    return GestureDetector(
      onTap: () => onChanged(!value),
      child: SizedBox(
        width: 44,
        height: 26,
        child: Stack(
          children: [
            // Off-state track
            Container(
              width: 44,
              height: 26,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(13),
                color: offColor,
              ),
            ),
            // On-state track (fades in)
            AnimatedOpacity(
              duration: const Duration(milliseconds: 180),
              opacity: value ? 1.0 : 0.0,
              child: Container(
                width: 44,
                height: 26,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(13),
                  color: activeColor,
                  gradient: activeColor == null
                      ? const LinearGradient(
                          colors: [
                            AppColors.auroraPurple,
                            AppColors.auroraElectricBlue,
                          ],
                        )
                      : null,
                ),
              ),
            ),
            // Thumb
            AnimatedAlign(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeInOut,
              alignment: value
                  ? AlignmentDirectional.centerEnd
                  : AlignmentDirectional.centerStart,
              child: Container(
                margin: const EdgeInsets.all(3),
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.white,
                  boxShadow: [
                    BoxShadow(color: Color(0x33000000), blurRadius: 4),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
