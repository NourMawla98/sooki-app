import 'package:easy_localization/easy_localization.dart';
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
        return 'enums.sort_option.newest'.tr();
      case SortOption.priceLowToHigh:
        return 'enums.sort_option.price_low_to_high'.tr();
      case SortOption.priceHighToLow:
        return 'enums.sort_option.price_high_to_low'.tr();
      case SortOption.rating:
        return 'enums.sort_option.rating'.tr();
      case SortOption.mostPopular:
        return 'enums.sort_option.most_popular'.tr();
      case SortOption.biggestDiscount:
        return 'enums.sort_option.biggest_discount'.tr();
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
        return 4; // PopularViews, the closest available
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
        return 'enums.sort_option_short.newest'.tr();
      case SortOption.priceLowToHigh:
        return '${'enums.sort_option_short.price'.tr()} \u2191';
      case SortOption.priceHighToLow:
        return '${'enums.sort_option_short.price'.tr()} \u2193';
      case SortOption.rating:
        return 'enums.sort_option_short.rating'.tr();
      case SortOption.mostPopular:
        return 'enums.sort_option_short.most_popular'.tr();
      case SortOption.biggestDiscount:
        return 'enums.sort_option_short.biggest_discount'.tr();
    }
  }
}
