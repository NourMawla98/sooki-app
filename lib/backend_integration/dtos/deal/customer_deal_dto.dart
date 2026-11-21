import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../enums/deal_type.dart';
import '../../../utils/server_date.dart';
import '../item/item_list_item_dto.dart';

part 'customer_deal_dto.freezed.dart';
part 'customer_deal_dto.g.dart';

/// A deal on the Deals tab. A live deal's items carry their deal price; an
/// upcoming deal's items carry no deal and show their normal price.
///
/// Every field after [items] is optional so a backend that only knows fixed
/// price deals still parses, and reads as a [DealType.singleItem] deal.
@Freezed(toJson: false, fromJson: true)
abstract class CustomerDealDto with _$CustomerDealDto {
  const CustomerDealDto._();

  const factory CustomerDealDto({
    required int id,
    required String title,
    String? description,
    @ServerUtcDateConverter() required DateTime startsAt,
    // Null when the deal never ends.
    @ServerUtcDateConverter() DateTime? expiresAt,
    required bool isLive,
    // Every item in the deal, the free one included.
    @Default([]) List<ItemListItemDto> items,
    @Default(1) int type,
    // Multi-buy and spend deals.
    double? discountPercent,
    // Multi-buy deals: the fewest units that unlock the discount.
    int? minQuantity,
    // Bundle deals: what one full set costs.
    double? bundlePrice,
    // Bundle and free gift deals: one full set at normal prices, the free
    // line included.
    double? originalTotal,
    // Spend deals: the cart subtotal that unlocks the discount.
    double? spendThreshold,
    @Default([]) List<DealLineDto> lines,
  }) = _CustomerDealDto;

  factory CustomerDealDto.fromJson(Map<String, dynamic> json) =>
      _$CustomerDealDtoFromJson(json);

  DealType get dealType => DealType.fromInt(type);

  List<DealLineDto> get buyLines =>
      lines.where((l) => l.lineRole == DealLineRole.buy).toList();

  /// The free line of a free gift deal, or null for every other deal.
  DealLineDto? get freeLine {
    for (final line in lines) {
      if (line.lineRole == DealLineRole.free) return line;
    }
    return null;
  }

  /// The item a line points at, or null when the backend left it out.
  ItemListItemDto? itemFor(DealLineDto line) {
    for (final item in items) {
      if (item.id == line.itemId) return item;
    }
    return null;
  }
}

/// One item in a deal and how many of it one set needs.
@Freezed(toJson: false, fromJson: true)
abstract class DealLineDto with _$DealLineDto {
  const DealLineDto._();

  const factory DealLineDto({
    required int itemId,
    @Default(1) int quantity,
    @Default(1) int role,
  }) = _DealLineDto;

  factory DealLineDto.fromJson(Map<String, dynamic> json) =>
      _$DealLineDtoFromJson(json);

  DealLineRole get lineRole => DealLineRole.fromInt(role);
}
