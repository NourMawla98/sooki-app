import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../utils/server_date.dart';

part 'item_deal_dto.freezed.dart';
part 'item_deal_dto.g.dart';

/// The live deal on an item. [dealPrice] is the base price; a size surcharge
/// is added on top of it, as it is on top of a discount.
@Freezed(toJson: false, fromJson: true)
abstract class ItemDealDto with _$ItemDealDto {
  const ItemDealDto._();

  const factory ItemDealDto({
    required int dealId,
    required double dealPrice,
    // Null when the deal never ends, so no countdown is shown.
    @ServerUtcDateConverter() DateTime? expiresAt,
  }) = _ItemDealDto;

  factory ItemDealDto.fromJson(Map<String, dynamic> json) =>
      _$ItemDealDtoFromJson(json);

  /// False once the end has passed on this device, so a screen left open does
  /// not keep offering an ended deal before its next fetch.
  bool get isLive => expiresAt == null || expiresAt!.isAfter(DateTime.now());
}
