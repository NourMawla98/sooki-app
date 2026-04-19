import 'package:flutter/material.dart';

import '../../../../models/product.dart';

/// Immutable snapshot of every filter the user can toggle from the Filter
/// bottom sheet. The Shopping screen owns the canonical instance; draft
/// edits happen inside the sheet and only land back on the screen via
/// `Navigator.pop(newState)`.
@immutable
class FilterState {
  /// Selected price band. The defaults span the screen's full price axis
  /// so a freshly-opened sheet doesn't accidentally filter products out.
  final RangeValues priceRange;

  /// Set of `ColorVariant.name` strings. Empty = no color filter.
  final Set<String> colors;

  /// Set of `SizeVariant.label` strings. Empty = no size filter.
  final Set<String> sizes;

  /// Minimum star rating, 1–5. `0` = no rating filter.
  final int minRating;

  const FilterState({
    this.priceRange = const RangeValues(0, 0),
    this.colors = const {},
    this.sizes = const {},
    this.minRating = 0,
  });

  /// Factory helper that returns the "no filters applied" state for a
  /// catalog spanning [priceMin] → [priceMax].
  factory FilterState.initial({
    required double priceMin,
    required double priceMax,
  }) {
    return FilterState(priceRange: RangeValues(priceMin, priceMax));
  }

  FilterState copyWith({
    RangeValues? priceRange,
    Set<String>? colors,
    Set<String>? sizes,
    int? minRating,
  }) {
    return FilterState(
      priceRange: priceRange ?? this.priceRange,
      colors: colors ?? this.colors,
      sizes: sizes ?? this.sizes,
      minRating: minRating ?? this.minRating,
    );
  }

  /// True when [p] satisfies every currently-active condition.
  bool matches(Product p) {
    if (p.price < priceRange.start || p.price > priceRange.end) return false;
    if (colors.isNotEmpty &&
        !p.colors.any((c) => colors.contains(c.name))) {
      return false;
    }
    if (sizes.isNotEmpty &&
        !p.sizes.any((s) => sizes.contains(s.label))) {
      return false;
    }
    if (minRating > 0 && p.rating < minRating) return false;
    return true;
  }

  /// Number of *user-visible* filters currently active. Powers the pink
  /// count badge on the Filter button and the "RESET ALL" enable state.
  ///
  /// Price counts as active only if the user has moved at least one
  /// handle off its catalog bound.
  int activeCount({required double priceMin, required double priceMax}) {
    var n = 0;
    if (priceRange.start > priceMin || priceRange.end < priceMax) n++;
    if (colors.isNotEmpty) n++;
    if (sizes.isNotEmpty) n++;
    if (minRating > 0) n++;
    return n;
  }
}
