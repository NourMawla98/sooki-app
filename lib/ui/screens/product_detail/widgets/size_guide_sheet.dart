import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../services/theme_service.dart';
import '../../../../themes/themes.dart';

class _SizeRow {
  const _SizeRow({
    required this.label,
    required this.bust,
    required this.waist,
    required this.hip,
  });

  final String label;
  final int bust;
  final int waist;
  final int hip;
}

const List<_SizeRow> _staticChart = [
  _SizeRow(label: 'XS', bust: 32, waist: 24, hip: 34),
  _SizeRow(label: 'S', bust: 34, waist: 26, hip: 36),
  _SizeRow(label: 'M', bust: 36, waist: 28, hip: 38),
  _SizeRow(label: 'L', bust: 38, waist: 30, hip: 40),
  _SizeRow(label: 'XL', bust: 40, waist: 32, hip: 42),
];

class SizeGuideSheet extends StatefulWidget {
  const SizeGuideSheet({super.key, this.selectedLabel});

  final String? selectedLabel;

  static Future<void> show(BuildContext context, {String? selectedLabel}) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SizeGuideSheet(selectedLabel: selectedLabel),
    );
  }

  @override
  State<SizeGuideSheet> createState() => _SizeGuideSheetState();
}

class _SizeGuideSheetState extends State<SizeGuideSheet> {
  bool _useCm = false;
  bool _measureExpanded = false;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService.instance,
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;
        final bg =
            isDark ? AppColors.auroraDeepBase : AppColors.auroraLightBase;
        final textColor =
            isDark ? AppColors.white : AppColors.primaryPurple;
        final mutedLabel =
            (isDark ? AppColors.white : AppColors.primaryPurple)
                .withValues(alpha: 0.55);
        final mutedBody =
            (isDark ? AppColors.white : AppColors.primaryPurple)
                .withValues(alpha: 0.85);
        final cellBg = isDark
            ? AppColors.white.withValues(alpha: 0.04)
            : AppColors.primaryPurple.withValues(alpha: 0.04);
        final cellBorder = isDark
            ? AppColors.white.withValues(alpha: 0.10)
            : AppColors.primaryPurple.withValues(alpha: 0.18);
        final divider = isDark
            ? AppColors.white.withValues(alpha: 0.08)
            : AppColors.primaryPurple.withValues(alpha: 0.12);
        final handle = isDark
            ? AppColors.white.withValues(alpha: 0.22)
            : AppColors.primaryPurple.withValues(alpha: 0.30);

        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: bg,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
              border: Border(top: BorderSide(color: cellBorder)),
            ),
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.85,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: handle,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 14),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Size Guide',
                        style: AppFonts.primary(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: textColor,
                          height: 1.2,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(context).maybePop(),
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: cellBg,
                            border: Border.all(color: cellBorder),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: FaIcon(
                              FontAwesomeIcons.xmark,
                              size: 13,
                              color: textColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _UnitToggle(
                          useCm: _useCm,
                          cellBg: cellBg,
                          cellBorder: cellBorder,
                          textColor: textColor,
                          mutedLabel: mutedLabel,
                          onChanged: (v) => setState(() => _useCm = v),
                        ),
                        const SizedBox(height: 16),
                        _SizeTable(
                          selectedLabel: widget.selectedLabel,
                          unitSuffix: _useCm ? 'cm' : 'in',
                          cellBg: cellBg,
                          cellBorder: cellBorder,
                          divider: divider,
                          textColor: textColor,
                          mutedLabel: mutedLabel,
                        ),
                        const SizedBox(height: 14),
                        _FitNote(mutedBody: mutedBody),
                        const SizedBox(height: 14),
                        _HowToMeasureCard(
                          expanded: _measureExpanded,
                          onToggle: () => setState(
                              () => _measureExpanded = !_measureExpanded),
                          cellBg: cellBg,
                          cellBorder: cellBorder,
                          divider: divider,
                          textColor: textColor,
                          mutedLabel: mutedLabel,
                          mutedBody: mutedBody,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _UnitToggle extends StatelessWidget {
  const _UnitToggle({
    required this.useCm,
    required this.cellBg,
    required this.cellBorder,
    required this.textColor,
    required this.mutedLabel,
    required this.onChanged,
  });

  final bool useCm;
  final Color cellBg;
  final Color cellBorder;
  final Color textColor;
  final Color mutedLabel;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: cellBg,
          border: Border.all(color: cellBorder),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _UnitChip(
              label: 'IN',
              isSelected: !useCm,
              textColor: textColor,
              mutedLabel: mutedLabel,
              onTap: () => onChanged(false),
            ),
            _UnitChip(
              label: 'CM',
              isSelected: useCm,
              textColor: textColor,
              mutedLabel: mutedLabel,
              onTap: () => onChanged(true),
            ),
          ],
        ),
      ),
    );
  }
}

class _UnitChip extends StatelessWidget {
  const _UnitChip({
    required this.label,
    required this.isSelected,
    required this.textColor,
    required this.mutedLabel,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final Color textColor;
  final Color mutedLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.auroraPink,
                    AppColors.auroraPurple,
                    AppColors.auroraElectricBlue,
                  ],
                )
              : null,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: AppFonts.primary(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: isSelected ? AppColors.white : mutedLabel,
            letterSpacing: 1.0,
            height: 1.1,
          ),
        ),
      ),
    );
  }
}

class _SizeTable extends StatelessWidget {
  const _SizeTable({
    required this.selectedLabel,
    required this.unitSuffix,
    required this.cellBg,
    required this.cellBorder,
    required this.divider,
    required this.textColor,
    required this.mutedLabel,
  });

  final String? selectedLabel;
  final String unitSuffix;
  final Color cellBg;
  final Color cellBorder;
  final Color divider;
  final Color textColor;
  final Color mutedLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: cellBg,
        border: Border.all(color: cellBorder),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          _TableHeader(mutedLabel: mutedLabel, unitSuffix: unitSuffix),
          Container(height: 1, color: divider),
          for (var i = 0; i < _staticChart.length; i++) ...[
            _TableDataRow(
              row: _staticChart[i],
              isSelected: _staticChart[i].label == selectedLabel,
              textColor: textColor,
              mutedLabel: mutedLabel,
            ),
            if (i < _staticChart.length - 1)
              Container(height: 1, color: divider),
          ],
        ],
      ),
    );
  }
}

class _TableHeader extends StatelessWidget {
  const _TableHeader({required this.mutedLabel, required this.unitSuffix});
  final Color mutedLabel;
  final String unitSuffix;

  @override
  Widget build(BuildContext context) {
    TextStyle style() => AppFonts.primary(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          color: mutedLabel,
          letterSpacing: 1.2,
          height: 1.1,
        );

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
      child: Row(
        children: [
          SizedBox(width: 48, child: Text('SIZE', style: style())),
          Expanded(child: Text('BUST ($unitSuffix)', style: style())),
          Expanded(child: Text('WAIST ($unitSuffix)', style: style())),
          Expanded(
            child: Text(
              'HIP ($unitSuffix)',
              style: style(),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

class _TableDataRow extends StatelessWidget {
  const _TableDataRow({
    required this.row,
    required this.isSelected,
    required this.textColor,
    required this.mutedLabel,
  });

  final _SizeRow row;
  final bool isSelected;
  final Color textColor;
  final Color mutedLabel;

  @override
  Widget build(BuildContext context) {
    final cellStyle = AppFonts.primary(
      fontSize: 13,
      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
      color: textColor,
      height: 1.2,
    );
    final labelStyle = AppFonts.primary(
      fontSize: 13,
      fontWeight: FontWeight.w800,
      color: textColor,
      height: 1.2,
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: isSelected
            ? LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  AppColors.auroraPink.withValues(alpha: 0.18),
                  AppColors.auroraPurple.withValues(alpha: 0.12),
                  AppColors.auroraElectricBlue.withValues(alpha: 0.10),
                ],
              )
            : null,
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 3,
              decoration: isSelected
                  ? const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.auroraPink,
                          AppColors.auroraPurple,
                          AppColors.auroraElectricBlue,
                        ],
                      ),
                    )
                  : null,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(11, 12, 14, 12),
                child: Row(
                  children: [
                    SizedBox(
                        width: 48, child: Text(row.label, style: labelStyle)),
                    Expanded(child: Text('${row.bust}', style: cellStyle)),
                    Expanded(child: Text('${row.waist}', style: cellStyle)),
                    Expanded(
                      child: Text(
                        '${row.hip}',
                        style: cellStyle,
                        textAlign: TextAlign.right,
                      ),
                    ),
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

class _FitNote extends StatelessWidget {
  const _FitNote({required this.mutedBody});
  final Color mutedBody;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: AppColors.auroraElectricBlue.withValues(alpha: 0.10),
        border: Border.all(
          color: AppColors.auroraElectricBlue.withValues(alpha: 0.35),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FaIcon(
            FontAwesomeIcons.circleInfo,
            size: 14,
            color: AppColors.auroraElectricBlue,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'If you\'re between sizes, we recommend sizing up for a relaxed fit or sizing down for a fitted look.',
              style: AppFonts.primary(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: mutedBody,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HowToMeasureCard extends StatelessWidget {
  const _HowToMeasureCard({
    required this.expanded,
    required this.onToggle,
    required this.cellBg,
    required this.cellBorder,
    required this.divider,
    required this.textColor,
    required this.mutedLabel,
    required this.mutedBody,
  });

  final bool expanded;
  final VoidCallback onToggle;
  final Color cellBg;
  final Color cellBorder;
  final Color divider;
  final Color textColor;
  final Color mutedLabel;
  final Color mutedBody;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: cellBg,
        border: Border.all(color: cellBorder),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: onToggle,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'HOW TO MEASURE',
                      style: AppFonts.primary(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: mutedLabel,
                        letterSpacing: 1.4,
                        height: 1.1,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: expanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: FaIcon(
                      FontAwesomeIcons.chevronDown,
                      size: 11,
                      color: mutedLabel,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            child: expanded
                ? Column(
                    children: [
                      Container(height: 1, color: divider),
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(14, 12, 14, 14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _MeasureTip(
                              title: 'Bust',
                              body:
                                  'Measure around the fullest part of your bust, keeping the tape parallel to the floor.',
                              textColor: textColor,
                              mutedBody: mutedBody,
                            ),
                            const SizedBox(height: 10),
                            _MeasureTip(
                              title: 'Waist',
                              body:
                                  'Measure around the narrowest part of your waist, usually just above the belly button.',
                              textColor: textColor,
                              mutedBody: mutedBody,
                            ),
                            const SizedBox(height: 10),
                            _MeasureTip(
                              title: 'Hip',
                              body:
                                  'Measure around the fullest part of your hips, about 20 cm below your waist.',
                              textColor: textColor,
                              mutedBody: mutedBody,
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

class _MeasureTip extends StatelessWidget {
  const _MeasureTip({
    required this.title,
    required this.body,
    required this.textColor,
    required this.mutedBody,
  });

  final String title;
  final String body;
  final Color textColor;
  final Color mutedBody;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppFonts.primary(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: textColor,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          body,
          style: AppFonts.primary(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: mutedBody,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
