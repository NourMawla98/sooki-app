import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../services/theme_service.dart';
import '../../../../themes/themes.dart';
import '../../../../utils/number_localization.dart';
import 'size_guide_data.dart';

class SizeGuideSheet extends StatefulWidget {
  const SizeGuideSheet({super.key, this.sizeStandardId, this.selectedLabel});

  final int? sizeStandardId;
  final String? selectedLabel;

  static Future<void> show(
    BuildContext context, {
    int? sizeStandardId,
    String? selectedLabel,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: SizeGuideSheet(
          sizeStandardId: sizeStandardId,
          selectedLabel: selectedLabel,
        ),
      ),
    );
  }

  @override
  State<SizeGuideSheet> createState() => _SizeGuideSheetState();
}

class _SizeGuideSheetState extends State<SizeGuideSheet> {
  bool _useCm = true;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService.instance,
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;
        final bg = isDark
            ? AppColors.auroraDeepBase
            : AppColors.auroraLightBase;
        final textColor = isDark ? AppColors.white : AppColors.auroraPurple;
        final mutedLabel = (isDark ? AppColors.white : AppColors.auroraPurple)
            .withValues(alpha: 0.55);
        final mutedBody = (isDark ? AppColors.white : AppColors.auroraPurple)
            .withValues(alpha: 0.85);
        final cellBg = isDark
            ? AppColors.white.withValues(alpha: 0.04)
            : AppColors.auroraPurple.withValues(alpha: 0.04);
        final headerBg = isDark
            ? AppColors.white.withValues(alpha: 0.06)
            : AppColors.auroraPurple.withValues(alpha: 0.06);
        final cellBorder = isDark
            ? AppColors.white.withValues(alpha: 0.10)
            : AppColors.auroraPurple.withValues(alpha: 0.18);
        final divider = isDark
            ? AppColors.white.withValues(alpha: 0.08)
            : AppColors.auroraPurple.withValues(alpha: 0.12);

        final content = sizeGuideFor(widget.sizeStandardId);

        return Container(
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: cellBorder),
          ),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.82,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 14),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'size_guide_sheet.title'.tr(),
                            style: AppFonts.primary(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: textColor,
                              height: 1.2,
                            ),
                          ),
                          if (content != null) ...[
                            const SizedBox(height: 2),
                            Text(
                              content.subtitle.tr(),
                              style: AppFonts.primary(
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                                color: mutedLabel,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
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
              if (content == null)
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 24),
                  child: Text(
                    'size_guide_sheet.no_guide_available'.tr(),
                    style: AppFonts.primary(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: mutedBody,
                      height: 1.4,
                    ),
                  ),
                )
              else
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                      20,
                      0,
                      20,
                      24,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (content.hasUnitToggle) ...[
                          _UnitToggle(
                            useCm: _useCm,
                            cellBg: cellBg,
                            cellBorder: cellBorder,
                            textColor: textColor,
                            mutedLabel: mutedLabel,
                            onChanged: (v) => setState(() => _useCm = v),
                          ),
                          const SizedBox(height: 16),
                        ],
                        _buildBody(
                          content: content,
                          cellBg: cellBg,
                          headerBg: headerBg,
                          cellBorder: cellBorder,
                          divider: divider,
                          textColor: textColor,
                          mutedLabel: mutedLabel,
                          mutedBody: mutedBody,
                        ),
                        if (content.howToMeasure != null) ...[
                          const SizedBox(height: 14),
                          _TipCard(
                            text: content.howToMeasure!.tr(),
                            mutedBody: mutedBody,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBody({
    required SizeGuideContent content,
    required Color cellBg,
    required Color headerBg,
    required Color cellBorder,
    required Color divider,
    required Color textColor,
    required Color mutedLabel,
    required Color mutedBody,
  }) {
    switch (content.type) {
      case SizeGuideType.bra:
        return _BraGuide(
          cellBg: cellBg,
          cellBorder: cellBorder,
          divider: divider,
          textColor: textColor,
          mutedLabel: mutedLabel,
          mutedBody: mutedBody,
        );
      case SizeGuideType.bed:
        return _GuideTable(
          content: content,
          rows: content.rowsIn,
          selectedLabel: widget.selectedLabel,
          firstColMatch: true,
          cellBg: cellBg,
          headerBg: headerBg,
          cellBorder: cellBorder,
          divider: divider,
          textColor: textColor,
          mutedLabel: mutedLabel,
        );
      case SizeGuideType.table:
        final rows = (content.hasUnitToggle && _useCm && content.rowsCm != null)
            ? content.rowsCm!
            : content.rowsIn;
        return _GuideTable(
          content: content,
          rows: rows,
          selectedLabel: widget.selectedLabel,
          firstColMatch: true,
          cellBg: cellBg,
          headerBg: headerBg,
          cellBorder: cellBorder,
          divider: divider,
          textColor: textColor,
          mutedLabel: mutedLabel,
        );
    }
  }
}

// ─── Generic guide table ──────────────────────────────────────────────────────

class _GuideTable extends StatelessWidget {
  const _GuideTable({
    required this.content,
    required this.rows,
    required this.selectedLabel,
    required this.firstColMatch,
    required this.cellBg,
    required this.headerBg,
    required this.cellBorder,
    required this.divider,
    required this.textColor,
    required this.mutedLabel,
  });

  final SizeGuideContent content;
  final List<List<String>> rows;
  final String? selectedLabel;
  final bool firstColMatch;
  final Color cellBg;
  final Color headerBg;
  final Color cellBorder;
  final Color divider;
  final Color textColor;
  final Color mutedLabel;

  /// Row the customer's size points at, or -1 when nothing matches.
  ///
  /// The label is compared as it is first. The backend only sends the
  /// translated display value, so a numeric fallback follows, and it is only
  /// trusted when exactly one row answers to it.
  int get _selectedRowIndex {
    final label = selectedLabel;
    if (label == null) return -1;

    final exact = rows.indexWhere((row) => row.isNotEmpty && row[0] == label);
    if (exact != -1) return exact;

    final key = sizeMatchKey(label);
    if (key.isEmpty) return -1;
    final matches = <int>[];
    for (var i = 0; i < rows.length; i++) {
      final row = rows[i];
      if (row.isNotEmpty && sizeMatchKey(row[0]) == key) matches.add(i);
    }
    return matches.length == 1 ? matches.first : -1;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: cellBg,
        border: Border.all(color: cellBorder),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header with tinted background
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: headerBg,
              border: Border(bottom: BorderSide(color: divider)),
            ),
            child: Row(
              children: content.columns
                  .map(
                    (col) => Expanded(
                      child: Text(
                        col.tr().toUpperCase(),
                        style: AppFonts.primary(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: mutedLabel,
                          letterSpacing: 1.3,
                          height: 1.1,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          // Data rows
          ...rows.asMap().entries.expand((entry) {
            final i = entry.key;
            final row = entry.value;
            final isSelected = firstColMatch && i == _selectedRowIndex;
            return [
              _GuideRow(
                row: row,
                isSelected: isSelected,
                textColor: textColor,
                mutedLabel: mutedLabel,
              ),
              if (i < rows.length - 1) Container(height: 1, color: divider),
            ];
          }),
        ],
      ),
    );
  }
}

class _GuideRow extends StatelessWidget {
  const _GuideRow({
    required this.row,
    required this.isSelected,
    required this.textColor,
    required this.mutedLabel,
  });

  final List<String> row;
  final bool isSelected;
  final Color textColor;
  final Color mutedLabel;

  @override
  Widget build(BuildContext context) {
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
            // Leading gradient accent bar (selected only)
            Container(
              width: 3,
              decoration: isSelected
                  ? const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: AppColors.auroraGradient,
                      ),
                    )
                  : null,
            ),
            ...row.asMap().entries.map((e) {
              final isFirst = e.key == 0;
              return Expanded(
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(
                    isFirst ? 11 : 8,
                    11,
                    8,
                    11,
                  ),
                  // The first column holds the size label (38, XL, 90x200). It
                  // stays in Western digits so it matches the picked size.
                  child: Text(
                    isSizeGuideKey(e.value)
                        ? e.value.tr()
                        : (isFirst ? e.value : localizedDigits(e.value)),
                    style: AppFonts.primary(
                      fontSize: 12,
                      fontWeight: isFirst || isSelected
                          ? FontWeight.w700
                          : FontWeight.w500,
                      color: isSelected || isFirst ? textColor : mutedLabel,
                      height: 1.2,
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

// ─── Bra guide ────────────────────────────────────────────────────────────────

class _BraGuide extends StatelessWidget {
  const _BraGuide({
    required this.cellBg,
    required this.cellBorder,
    required this.divider,
    required this.textColor,
    required this.mutedLabel,
    required this.mutedBody,
  });

  final Color cellBg;
  final Color cellBorder;
  final Color divider;
  final Color textColor;
  final Color mutedLabel;
  final Color mutedBody;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _BraStep(
          step: '1',
          title: 'size_guide_sheet.bra_step1_title'.tr(),
          body: 'size_guide_sheet.bra_step1_body'.tr(),
          cellBg: cellBg,
          cellBorder: cellBorder,
          textColor: textColor,
          mutedBody: mutedBody,
        ),
        const SizedBox(height: 10),
        _BraStep(
          step: '2',
          title: 'size_guide_sheet.bra_step2_title'.tr(),
          body: 'size_guide_sheet.bra_step2_body'.tr(),
          cellBg: cellBg,
          cellBorder: cellBorder,
          textColor: textColor,
          mutedBody: mutedBody,
          extra: _CupDiffTable(
            cellBg: cellBg,
            cellBorder: cellBorder,
            divider: divider,
            textColor: textColor,
            mutedLabel: mutedLabel,
          ),
        ),
        const SizedBox(height: 10),
        _BraStep(
          step: '3',
          title: 'size_guide_sheet.bra_step3_title'.tr(),
          body: 'size_guide_sheet.bra_step3_body'.tr(),
          cellBg: cellBg,
          cellBorder: cellBorder,
          textColor: textColor,
          mutedBody: mutedBody,
        ),
      ],
    );
  }
}

class _BraStep extends StatelessWidget {
  const _BraStep({
    required this.step,
    required this.title,
    required this.body,
    required this.cellBg,
    required this.cellBorder,
    required this.textColor,
    required this.mutedBody,
    this.extra,
  });

  final String step;
  final String title;
  final String body;
  final Color cellBg;
  final Color cellBorder;
  final Color textColor;
  final Color mutedBody;
  final Widget? extra;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cellBg,
        border: Border.all(color: cellBorder),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ShaderMask(
                shaderCallback: (b) => const LinearGradient(
                  colors: AppColors.auroraGradient,
                ).createShader(b),
                blendMode: BlendMode.srcIn,
                child: Text(
                  'size_guide_sheet.step_label'.tr(
                    namedArgs: {'step': localizedDigits(step)},
                  ),
                  style: AppFonts.primary(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: AppColors.white,
                    letterSpacing: 0.8,
                    height: 1.1,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: AppFonts.primary(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                    height: 1.2,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: AppFonts.primary(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: mutedBody,
              height: 1.45,
            ),
          ),
          if (extra != null) ...[const SizedBox(height: 12), extra!],
        ],
      ),
    );
  }
}

const _kCupDiffs = [
  ['AA', '0–2 cm'],
  ['A', '2–4 cm'],
  ['B', '4–6 cm'],
  ['C', '6–8 cm'],
  ['D', '8–10 cm'],
  ['E', '10–12 cm'],
  ['F', '12–14 cm'],
  ['G', '14–16 cm'],
];

class _CupDiffTable extends StatelessWidget {
  const _CupDiffTable({
    required this.cellBg,
    required this.cellBorder,
    required this.divider,
    required this.textColor,
    required this.mutedLabel,
  });

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
        border: Border.all(color: cellBorder),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsetsDirectional.fromSTEB(12, 8, 12, 8),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: divider)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'size_guide_sheet.cup_header'.tr(),
                    style: AppFonts.primary(
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      color: mutedLabel,
                      letterSpacing: 1.2,
                      height: 1.1,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'size_guide_sheet.difference_header'.tr(),
                    style: AppFonts.primary(
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      color: mutedLabel,
                      letterSpacing: 1.2,
                      height: 1.1,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ...List.generate(_kCupDiffs.length, (i) {
            final row = _kCupDiffs[i];
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(12, 8, 12, 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          row[0],
                          style: AppFonts.primary(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: textColor,
                            height: 1.2,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          localizedDigits(row[1]),
                          style: AppFonts.primary(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: mutedLabel,
                            height: 1.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (i < _kCupDiffs.length - 1)
                  Container(height: 1, color: divider),
              ],
            );
          }),
        ],
      ),
    );
  }
}

// ─── Tip card ─────────────────────────────────────────────────────────────────

class _TipCard extends StatelessWidget {
  const _TipCard({required this.text, required this.mutedBody});

  final String text;
  final Color mutedBody;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsDirectional.fromSTEB(14, 12, 14, 12),
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
              text,
              style: AppFonts.primary(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: mutedBody,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Unit toggle ─────────────────────────────────────────────────────────────

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
      alignment: AlignmentDirectional.centerEnd,
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
              label: 'size_guide_sheet.unit_in'.tr(),
              isSelected: !useCm,
              textColor: textColor,
              mutedLabel: mutedLabel,
              onTap: () => onChanged(false),
            ),
            _UnitChip(
              label: 'size_guide_sheet.unit_cm'.tr(),
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
                  colors: AppColors.auroraGradient,
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
