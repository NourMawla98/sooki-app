import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../utils/server_date.dart';
import '../item/item_list_item_dto.dart';

part 'customer_deal_dto.freezed.dart';
part 'customer_deal_dto.g.dart';

/// A deal on the Deals tab. A live deal's items carry their deal price; an
/// upcoming deal's items carry no deal and show their normal price.
@Freezed(toJson: false, fromJson: true)
abstract class CustomerDealDto with _$CustomerDealDto {
  const factory CustomerDealDto({
    required int id,
    required String title,
    String? description,
    @ServerUtcDateConverter() required DateTime startsAt,
    // Null when the deal never ends.
    @ServerUtcDateConverter() DateTime? expiresAt,
    required bool isLive,
    @Default([]) List<ItemListItemDto> items,
  }) = _CustomerDealDto;

  factory CustomerDealDto.fromJson(Map<String, dynamic> json) =>
      _$CustomerDealDtoFromJson(json);
}
