import 'package:flutter/material.dart';

import 'aurora_category_l1_pill.dart';

/// Horizontal scrolling row of detail-category (L3) selection chips.
///
/// Each chip uses [AuroraCategoryL1Pill] with the disabled-secondary style:
/// faded aurora gradient border + surface fill + gradient text when unselected,
/// animated rotating border when selected.
class AuroraDetailChipRow extends StatelessWidget {
  final List<String> labels;
  final String? selected;
  final ValueChanged<String> onSelected;

  const AuroraDetailChipRow({
    super.key,
    required this.labels,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (labels.isEmpty) return const SizedBox.shrink();
    return SizedBox(
      height: 32,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        itemCount: labels.length,
        separatorBuilder: (_, _) => const SizedBox(width: 7),
        itemBuilder: (_, i) {
          final label = labels[i];
          return AuroraCategoryL1Pill(
            label: label,
            isSelected: label == selected,
            onTap: () => onSelected(label),
            disabledStyleWhenUnselected: true,
          );
        },
      ),
    );
  }
}
