import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../themes/app_colors.dart';
import '../../../../themes/app_text_styles.dart';
import '../../cart/widgets/_cart_surface_theme.dart';

/// Aurora-styled select field. Looks like an input; taps to open a bottom
/// sheet list of options. `value` renders in the brand text color;
/// `hint` renders muted when value is null.
class AuroraSelect extends StatelessWidget {
  final String? value;
  final String hint;
  final List<String> options;
  final ValueChanged<String> onChanged;
  final FaIconData? prefixIcon;
  final CartSurfaceColors surfaceColors;
  final bool enabled;
  final String sheetTitle;

  const AuroraSelect({
    super.key,
    required this.value,
    required this.hint,
    required this.options,
    required this.onChanged,
    required this.surfaceColors,
    required this.sheetTitle,
    this.prefixIcon,
    this.enabled = true,
  });

  Future<void> _open(BuildContext context) async {
    if (!enabled || options.isEmpty) return;
    final picked = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _OptionsSheet(
        title: sheetTitle,
        options: options,
        selected: value,
        surfaceColors: surfaceColors,
      ),
    );
    if (picked != null) onChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    final c = surfaceColors;
    final hasValue = value != null && value!.isNotEmpty;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _open(context),
      child: Opacity(
        opacity: enabled ? 1.0 : 0.5,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
          decoration: BoxDecoration(
            color: c.chipFill,
            border: Border.all(color: c.chipBorder, width: 1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              if (prefixIcon != null) ...[
                FaIcon(
                  prefixIcon!,
                  size: 14,
                  color: c.textMute,
                ),
                const SizedBox(width: 10),
              ],
              Expanded(
                child: Text(
                  hasValue ? value! : hint,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontSize: 14,
                    fontWeight:
                        hasValue ? FontWeight.w600 : FontWeight.w500,
                    color: hasValue ? c.text : c.textMute2,
                  ),
                ),
              ),
              FaIcon(
                FontAwesomeIcons.chevronDown,
                size: 12,
                color: c.textMute2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OptionsSheet extends StatelessWidget {
  final String title;
  final List<String> options;
  final String? selected;
  final CartSurfaceColors surfaceColors;

  const _OptionsSheet({
    required this.title,
    required this.options,
    required this.selected,
    required this.surfaceColors,
  });

  @override
  Widget build(BuildContext context) {
    final c = surfaceColors;
    return DraggableScrollableSheet(
      initialChildSize: 0.55,
      minChildSize: 0.35,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) => Container(
        decoration: BoxDecoration(
          color: c.sheet,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
          border: Border(top: BorderSide(color: c.sheetTop, width: 1)),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: c.textMute3,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    title.toUpperCase(),
                    style: AppTextStyles.label.copyWith(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2,
                      color: AppColors.auroraPink,
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(18, 4, 18, 18),
                itemCount: options.length,
                separatorBuilder: (_, i) => Divider(
                  height: 1,
                  thickness: 1,
                  color: c.divider,
                ),
                itemBuilder: (context, i) {
                  final opt = options[i];
                  final isSelected = opt == selected;
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => Navigator.of(context).pop(opt),
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(vertical: 14),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              opt,
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontSize: 14,
                                fontWeight: isSelected
                                    ? FontWeight.w800
                                    : FontWeight.w600,
                                color: isSelected
                                    ? AppColors.auroraPurple
                                    : c.text,
                              ),
                            ),
                          ),
                          if (isSelected)
                            FaIcon(
                              FontAwesomeIcons.check,
                              size: 13,
                              color: AppColors.auroraPurple,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
