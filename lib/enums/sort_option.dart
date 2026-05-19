import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// The five ways a user can sort the Shopping screen's product grid. The
/// per-option `label` + `icon` are consumed by the sort bottom sheet; the
/// enum itself drives the actual comparator in [_ShoppingScreenState].
enum SortOption {
  newest,
  priceLowToHigh,
  priceHighToLow,
  rating,
  mostPopular,
  biggestDiscount;

  String get label {
    switch (this) {
      case SortOption.newest:
        return 'Newest';
      case SortOption.priceLowToHigh:
        return 'Price: Low to High';
      case SortOption.priceHighToLow:
        return 'Price: High to Low';
      case SortOption.rating:
        return 'Rating';
      case SortOption.mostPopular:
        return 'Most popular';
      case SortOption.biggestDiscount:
        return 'Biggest discount';
    }
  }

  FaIconData get icon {
    switch (this) {
      case SortOption.newest:
        return FontAwesomeIcons.clockRotateLeft;
      case SortOption.priceLowToHigh:
        return FontAwesomeIcons.arrowUpShortWide;
      case SortOption.priceHighToLow:
        return FontAwesomeIcons.arrowDownWideShort;
      case SortOption.rating:
        return FontAwesomeIcons.solidStar;
      case SortOption.mostPopular:
        return FontAwesomeIcons.fire;
      case SortOption.biggestDiscount:
        return FontAwesomeIcons.percent;
    }
  }

  /// Maps to the backend's SortBy enum values.
  int toSortBy() {
    switch (this) {
      case SortOption.newest:
        return 1;
      case SortOption.priceLowToHigh:
        return 2;
      case SortOption.priceHighToLow:
        return 3;
      case SortOption.rating:
        return 4; // PopularViews — closest available
      case SortOption.mostPopular:
        return 5; // PopularOrders
      case SortOption.biggestDiscount:
        return 6;
    }
  }

  /// Compact label shown inside the SORT button so the user sees the
  /// currently-applied sort without opening the sheet.
  String get buttonLabel {
    switch (this) {
      case SortOption.newest:
        return 'NEWEST';
      case SortOption.priceLowToHigh:
        return 'PRICE \u2191';
      case SortOption.priceHighToLow:
        return 'PRICE \u2193';
      case SortOption.rating:
        return 'RATING';
      case SortOption.mostPopular:
        return 'POPULAR';
      case SortOption.biggestDiscount:
        return 'DEAL';
    }
  }
}
