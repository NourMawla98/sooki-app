import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../backend_integration/dtos/item/color_dto.dart';
import '../../../../backend_integration/dtos/item/size_standard_dto.dart';
import '../../../../backend_integration/dtos/item/size_value_dto.dart';
import '../../../../services/theme_service.dart';
import '../../../../themes/app_colors.dart';
import '../../../../themes/app_text_styles.dart';
import '../../../../utils/number_localization.dart';
import '../../../reusable_components/aurora/aurora_primary_button.dart';
import 'filter_state.dart';

class FilterSheet extends StatefulWidget {
  final FilterState initial;
  final double priceMin;
  final double priceMax;
  final List<ColorDto> availableColors;
  final List<SizeStandardDto> availableSizeStandards;

  const FilterSheet({
    super.key,
    required this.initial,
    required this.priceMin,
    required this.priceMax,
    required this.availableColors,
    required this.availableSizeStandards,
  });

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  late FilterState _draft = widget.initial;

  int get _activeCount => _draft.activeCount(
        priceMin: widget.priceMin,
        priceMax: widget.priceMax,
      );

  void _resetAll() => setState(() {
        _draft = FilterState.initial(
          priceMin: widget.priceMin,
          priceMax: widget.priceMax,
        );
      });

  void _togglePrice(RangeValues v) =>
      setState(() => _draft = _draft.copyWith(priceRange: v));

  void _toggleColor(int id) {
    final next = {..._draft.colorIds};
    next.contains(id) ? next.remove(id) : next.add(id);
    setState(() => _draft = _draft.copyWith(colorIds: next));
  }

  void _toggleSize(int id) {
    final next = {..._draft.sizeValueIds};
    next.contains(id) ? next.remove(id) : next.add(id);
    setState(() => _draft = _draft.copyWith(sizeValueIds: next));
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService.instance,
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;
        final bg = isDark ? AppColors.auroraDeepBase : AppColors.white;
        final resetEnabled = _activeCount > 0;

        final mq = MediaQuery.of(context);
        final maxScrollHeight =
            (mq.size.height - mq.viewPadding.top - mq.viewPadding.bottom) *
                0.60;

        return DecoratedBox(
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ShaderMask(
                      shaderCallback: (b) => const LinearGradient(
                        colors: AppColors.auroraGradient,
                      ).createShader(b),
                      blendMode: BlendMode.srcIn,
                      child: Text(
                        'filter_sheet.filters'.tr(),
                        style: AppTextStyles.heading3.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 22,
                        ),
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: resetEnabled ? _resetAll : null,
                      behavior: HitTestBehavior.opaque,
                      child: Opacity(
                        opacity: resetEnabled ? 1.0 : 0.35,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: AppColors.auroraGradient,
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(1.5),
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: isDark
                                    ? AppColors.auroraDeepBase
                                    : AppColors.white,
                                borderRadius: BorderRadius.circular(6.5),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 7),
                                child: ShaderMask(
                                  shaderCallback: (b) => const LinearGradient(
                                    colors: AppColors.auroraGradient,
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ).createShader(b),
                                  blendMode: BlendMode.srcIn,
                                  child: Text(
                                    'filter_sheet.reset_all'.tr(),
                                    style: AppTextStyles.caption.copyWith(
                                      color: AppColors.white,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 12,
                                      letterSpacing: 0.5,
                                      height: 1.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 2),
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: maxScrollHeight),
                child: SingleChildScrollView(
                  padding: const EdgeInsetsDirectional.fromSTEB(20, 10, 20, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SectionHeading('filter_sheet.price'.tr(), isDark: isDark),
                      _PriceSection(
                        min: widget.priceMin,
                        max: widget.priceMax,
                        current: _draft.priceRange,
                        isDark: isDark,
                        onChanged: _togglePrice,
                      ),
                      if (widget.availableColors.isNotEmpty) ...[
                        const SizedBox(height: 14),
                        _FilterDropdown(
                          label: 'filter_sheet.color'.tr(),
                          isDark: isDark,
                          searchable: true,
                          searchHint: 'filter_sheet.search_colors'.tr(),
                          preview: _ColorTriggerPreview(
                            colors: widget.availableColors,
                            selectedIds: _draft.colorIds,
                            isDark: isDark,
                          ),
                          childrenBuilder: (q) {
                            final filtered = widget.availableColors
                                .where((c) => c.name
                                    .toLowerCase()
                                    .contains(q.toLowerCase()))
                                .toList();
                            return [
                              for (var i = 0; i < filtered.length; i++)
                                _ColorItem(
                                  color: filtered[i],
                                  isSelected:
                                      _draft.colorIds.contains(filtered[i].id),
                                  isDark: isDark,
                                  isLast: i == filtered.length - 1,
                                  onTap: () => _toggleColor(filtered[i].id),
                                ),
                            ];
                          },
                        ),
                      ],
                      for (final standard in widget.availableSizeStandards) ...[
                        const SizedBox(height: 14),
                        _FilterDropdown(
                          label: standard.name.toUpperCase(),
                          isDark: isDark,
                          searchable: true,
                          searchHint: 'filter_sheet.search_sizes'.tr(),
                          preview: _SizeTriggerPreview(
                            standard: standard,
                            selectedIds: _draft.sizeValueIds,
                            isDark: isDark,
                          ),
                          childrenBuilder: (q) {
                            final filtered = standard.values
                                .where((v) => v.displayValue
                                    .toLowerCase()
                                    .contains(q.toLowerCase()))
                                .toList();
                            return [
                              for (var i = 0; i < filtered.length; i++)
                                _SizeItem(
                                  sizeValue: filtered[i],
                                  isSelected: _draft.sizeValueIds
                                      .contains(filtered[i].id),
                                  isDark: isDark,
                                  isLast: i == filtered.length - 1,
                                  onTap: () => _toggleSize(filtered[i].id),
                                ),
                            ];
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(20, 6, 20, 20),
                child: AuroraPrimaryButton(
                  text: 'filter_sheet.apply'.tr(),
                  height: 48,
                  onPressed: () => Navigator.of(context).pop(_draft),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─── Section heading ──────────────────────────────────────────────────────────

class _SectionHeading extends StatelessWidget {
  final String text;
  final bool isDark;
  const _SectionHeading(this.text, {required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.caption.copyWith(
        color: isDark ? AppColors.white : AppColors.primaryPurple,
        fontWeight: FontWeight.w800,
        fontSize: 12,
        letterSpacing: 1.2,
      ),
    );
  }
}

// ─── Price ────────────────────────────────────────────────────────────────────

class _PriceSection extends StatelessWidget {
  final double min;
  final double max;
  final RangeValues current;
  final bool isDark;
  final ValueChanged<RangeValues> onChanged;

  const _PriceSection({
    required this.min,
    required this.max,
    required this.current,
    required this.isDark,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Row(
          children: [
            _GradientPriceText(value: current.start),
            Expanded(
              child: SliderTheme(
                data: SliderThemeData(
                  activeTrackColor: AppColors.auroraPink,
                  inactiveTrackColor: isDark
                      ? AppColors.white.withValues(alpha: 0.08)
                      : AppColors.primaryPurple.withValues(alpha: 0.12),
                  thumbColor: AppColors.white,
                  overlayColor:
                      AppColors.auroraPink.withValues(alpha: 0.20),
                  rangeThumbShape: const RoundRangeSliderThumbShape(
                    enabledThumbRadius: 9,
                    elevation: 4,
                  ),
                  rangeTrackShape:
                      const RoundedRectRangeSliderTrackShape(),
                  trackHeight: 3,
                  showValueIndicator: ShowValueIndicator.never,
                ),
                child: RangeSlider(
                  values: current,
                  min: min,
                  max: max,
                  onChanged: onChanged,
                ),
              ),
            ),
            _GradientPriceText(value: current.end),
          ],
        ),
      ],
    );
  }
}

class _GradientPriceText extends StatelessWidget {
  final double value;
  const _GradientPriceText({required this.value});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: AppColors.auroraGradient,
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
      blendMode: BlendMode.srcIn,
      child: Text(
        '\$${localizedNumber(value, decimals: 0)}',
        style: AppTextStyles.auroraMonoPrice.copyWith(
          color: AppColors.white,
          fontSize: 13,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

// ─── Collapsible dropdown ─────────────────────────────────────────────────────

class _FilterDropdown extends StatefulWidget {
  final String label;
  final bool isDark;
  final Widget preview;
  final bool searchable;
  final String searchHint;
  final List<Widget> Function(String query) childrenBuilder;

  const _FilterDropdown({
    required this.label,
    required this.isDark,
    required this.preview,
    required this.childrenBuilder,
    this.searchable = false,
    this.searchHint = 'Search...',
  });

  @override
  State<_FilterDropdown> createState() => _FilterDropdownState();
}

class _FilterDropdownState extends State<_FilterDropdown> {
  bool _expanded = false;
  String _query = '';
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fill = widget.isDark
        ? AppColors.white.withValues(alpha: 0.04)
        : AppColors.auroraPurple.withValues(alpha: 0.04);
    final borderColor = widget.isDark
        ? AppColors.white.withValues(alpha: 0.12)
        : AppColors.auroraPurple.withValues(alpha: 0.18);
    final labelColor = widget.isDark ? AppColors.white : AppColors.primaryPurple;
    final chevronColor = widget.isDark
        ? AppColors.white.withValues(alpha: 0.40)
        : AppColors.auroraPurple.withValues(alpha: 0.40);

    final children = widget.childrenBuilder(_query);

    return AnimatedSize(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeInOut,
      alignment: Alignment.topCenter,
      child: Container(
        decoration: BoxDecoration(
          color: fill,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () => setState(() => _expanded = !_expanded),
              behavior: HitTestBehavior.opaque,
              child: SizedBox(
                height: 48,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Row(
                    children: [
                      Text(
                        widget.label,
                        style: AppTextStyles.caption.copyWith(
                          color: labelColor,
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                          letterSpacing: 1.1,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: widget.preview),
                      AnimatedRotation(
                        turns: _expanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: FaIcon(FontAwesomeIcons.chevronDown,
                            size: 12, color: chevronColor),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (_expanded) ...[
              Container(height: 1, color: borderColor),
              if (widget.searchable)
                _SearchField(
                  controller: _controller,
                  hint: widget.searchHint,
                  isDark: widget.isDark,
                  borderColor: borderColor,
                  onChanged: (v) => setState(() => _query = v),
                ),
              if (children.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: Text(
                      'filter_sheet.no_results'.tr(),
                      style: AppTextStyles.caption.copyWith(
                        color: widget.isDark
                            ? AppColors.white.withValues(alpha: 0.35)
                            : AppColors.primaryPurple.withValues(alpha: 0.40),
                        fontSize: 12,
                      ),
                    ),
                  ),
                )
              else
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 220),
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: children,
                    ),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool isDark;
  final Color borderColor;
  final ValueChanged<String> onChanged;

  const _SearchField({
    required this.controller,
    required this.hint,
    required this.isDark,
    required this.borderColor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final hintColor = isDark
        ? AppColors.white.withValues(alpha: 0.30)
        : AppColors.primaryPurple.withValues(alpha: 0.35);
    final textColor = isDark ? AppColors.white : AppColors.auroraDeepBase;
    final iconColor = isDark
        ? AppColors.white.withValues(alpha: 0.35)
        : AppColors.primaryPurple.withValues(alpha: 0.40);
    final fieldBg = isDark
        ? AppColors.white.withValues(alpha: 0.06)
        : AppColors.primaryPurple.withValues(alpha: 0.06);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(12, 10, 12, 8),
          child: Container(
            height: 36,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: fieldBg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                FaIcon(FontAwesomeIcons.magnifyingGlass, size: 11, color: iconColor),
                const SizedBox(width: 9),
                Expanded(
                  child: TextField(
                    controller: controller,
                    onChanged: onChanged,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: textColor,
                      fontSize: 13,
                    ),
                    decoration: InputDecoration(
                      hintText: hint,
                      hintStyle: AppTextStyles.caption.copyWith(
                        color: hintColor,
                        fontSize: 13,
                      ),
                      isDense: true,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                if (controller.text.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      controller.clear();
                      onChanged('');
                    },
                    child: FaIcon(FontAwesomeIcons.xmark, size: 11, color: iconColor),
                  ),
              ],
            ),
          ),
        ),
        Container(height: 1, color: borderColor),
      ],
    );
  }
}

// ─── Shared checkbox ──────────────────────────────────────────────────────────

class _CheckBox extends StatelessWidget {
  final bool isChecked;
  final bool isDark;

  const _CheckBox({required this.isChecked, required this.isDark});

  @override
  Widget build(BuildContext context) {
    if (isChecked) {
      return Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: AppColors.auroraGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        child: const Center(
          child: FaIcon(FontAwesomeIcons.check, size: 11, color: AppColors.white),
        ),
      );
    }
    final borderColor = isDark
        ? AppColors.white.withValues(alpha: 0.22)
        : AppColors.primaryPurple.withValues(alpha: 0.25);
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: borderColor, width: 1.5),
      ),
    );
  }
}

// ─── Color helpers ────────────────────────────────────────────────────────────

Color _hexToColor(String hex) {
  final c = hex.replaceAll('#', '');
  return Color(int.parse('FF$c', radix: 16));
}

// ─── Color trigger preview ────────────────────────────────────────────────────

class _ColorTriggerPreview extends StatelessWidget {
  final List<ColorDto> colors;
  final Set<int> selectedIds;
  final bool isDark;

  const _ColorTriggerPreview({
    required this.colors,
    required this.selectedIds,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final selected = colors.where((c) => selectedIds.contains(c.id)).toList();

    if (selected.isEmpty) {
      return Text(
        'filter_sheet.all_colors'.tr(),
        style: AppTextStyles.caption.copyWith(
          color: isDark
              ? AppColors.white.withValues(alpha: 0.38)
              : AppColors.primaryPurple.withValues(alpha: 0.45),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      );
    }

    const maxDots = 4;
    final visible = selected.take(maxDots).toList();
    final overflow = selected.length - visible.length;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < visible.length; i++)
          Padding(
            padding: EdgeInsetsDirectional.only(start: i == 0 ? 0 : 5),
            child: Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: _hexToColor(visible[i].hexCode),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.white.withValues(alpha: 0.25),
                  width: 0.8,
                ),
              ),
            ),
          ),
        if (overflow > 0)
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 5),
            child: Text(
              '+${localizedNumber(overflow)}',
              style: AppTextStyles.captionSmall.copyWith(
                color: AppColors.auroraPink,
                fontWeight: FontWeight.w800,
                fontSize: 11,
              ),
            ),
          ),
      ],
    );
  }
}

class _ColorItem extends StatelessWidget {
  final ColorDto color;
  final bool isSelected;
  final bool isDark;
  final bool isLast;
  final VoidCallback onTap;

  const _ColorItem({
    required this.color,
    required this.isSelected,
    required this.isDark,
    required this.isLast,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dividerColor = isDark
        ? AppColors.white.withValues(alpha: 0.06)
        : AppColors.auroraPurple.withValues(alpha: 0.08);
    final nameColor = isSelected
        ? (isDark ? AppColors.white : AppColors.auroraPurple)
        : (isDark
            ? AppColors.white.withValues(alpha: 0.85)
            : AppColors.primaryPurple);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            child: Row(
              children: [
                _CheckBox(isChecked: isSelected, isDark: isDark),
                const SizedBox(width: 12),
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: _hexToColor(color.hexCode),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDark
                          ? AppColors.white.withValues(alpha: 0.18)
                          : AppColors.primaryPurple.withValues(alpha: 0.20),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  color.name,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: nameColor,
                    fontWeight:
                        isSelected ? FontWeight.w700 : FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          if (!isLast) Container(height: 1, color: dividerColor),
        ],
      ),
    );
  }
}

// ─── Size trigger preview ─────────────────────────────────────────────────────

class _SizeTriggerPreview extends StatelessWidget {
  final SizeStandardDto standard;
  final Set<int> selectedIds;
  final bool isDark;

  const _SizeTriggerPreview({
    required this.standard,
    required this.selectedIds,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final selected =
        standard.values.where((v) => selectedIds.contains(v.id)).toList();

    if (selected.isEmpty) {
      return Text(
        'filter_sheet.all_sizes'.tr(),
        style: AppTextStyles.caption.copyWith(
          color: isDark
              ? AppColors.white.withValues(alpha: 0.38)
              : AppColors.primaryPurple.withValues(alpha: 0.45),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      );
    }

    // Size labels (XS, S, 38) are identifiers, so their digits stay Western.
    final labels = selected.map((v) => v.displayValue).toList();
    final preview = labels.take(3).join(', ');
    final overflow = labels.length - 3;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: AppColors.auroraGradient,
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            localizedNumber(labels.length),
            style: AppTextStyles.captionSmall.copyWith(
              color: AppColors.white,
              fontSize: 10,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          overflow > 0 ? '$preview +${localizedNumber(overflow)}' : preview,
          style: AppTextStyles.caption.copyWith(
            color: isDark
                ? AppColors.white.withValues(alpha: 0.75)
                : AppColors.primaryPurple.withValues(alpha: 0.80),
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _SizeItem extends StatelessWidget {
  final SizeValueDto sizeValue;
  final bool isSelected;
  final bool isDark;
  final bool isLast;
  final VoidCallback onTap;

  const _SizeItem({
    required this.sizeValue,
    required this.isSelected,
    required this.isDark,
    required this.isLast,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dividerColor = isDark
        ? AppColors.white.withValues(alpha: 0.06)
        : AppColors.auroraPurple.withValues(alpha: 0.08);
    final nameColor = isSelected
        ? (isDark ? AppColors.white : AppColors.auroraPurple)
        : (isDark
            ? AppColors.white.withValues(alpha: 0.85)
            : AppColors.primaryPurple);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            child: Row(
              children: [
                _CheckBox(isChecked: isSelected, isDark: isDark),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    sizeValue.displayValue,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: nameColor,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (!isLast) Container(height: 1, color: dividerColor),
        ],
      ),
    );
  }
}
