import 'package:flutter/material.dart';

/// Immutable snapshot of every filter the user can toggle from the Filter
/// bottom sheet. The Shopping screen owns the canonical instance; draft
/// edits happen inside the sheet and only land back on the screen via
/// `Navigator.pop(newState)`.
@immutable
class FilterState {
  /// Selected price band. The defaults span the screen's full price axis
  /// so a freshly-opened sheet doesn't accidentally filter products out.
  final RangeValues priceRange;

  /// Set of `ColorDto.id` values. Empty = no color filter.
  final Set<int> colorIds;

  /// Set of `SizeValueDto.id` values. Empty = no size filter.
  final Set<int> sizeValueIds;

  const FilterState({
    this.priceRange = const RangeValues(0, 0),
    this.colorIds = const {},
    this.sizeValueIds = const {},
  });

  factory FilterState.initial({
    required double priceMin,
    required double priceMax,
  }) {
    return FilterState(priceRange: RangeValues(priceMin, priceMax));
  }

  FilterState copyWith({
    RangeValues? priceRange,
    Set<int>? colorIds,
    Set<int>? sizeValueIds,
  }) {
    return FilterState(
      priceRange: priceRange ?? this.priceRange,
      colorIds: colorIds ?? this.colorIds,
      sizeValueIds: sizeValueIds ?? this.sizeValueIds,
    );
  }

  int activeCount({required double priceMin, required double priceMax}) {
    var n = 0;
    if (priceRange.start > priceMin || priceRange.end < priceMax) n++;
    if (colorIds.isNotEmpty) n++;
    if (sizeValueIds.isNotEmpty) n++;
    return n;
  }
}
