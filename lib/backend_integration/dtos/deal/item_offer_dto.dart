import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../enums/deal_type.dart';
import '../../../utils/server_date.dart';

part 'item_offer_dto.freezed.dart';
part 'item_offer_dto.g.dart';

/// A bundle, multi-buy or free gift deal an item takes part in. Fixed price
/// deals travel on the item's own deal instead.
@Freezed(toJson: false, fromJson: true)
abstract class ItemOfferDto with _$ItemOfferDto {
  const ItemOfferDto._();

  const factory ItemOfferDto({
    required int dealId,
    @Default(1) int type,
    @Default('') String title,
    // Multi-buy: the percent off once [minQuantity] units are in the cart.
    double? discountPercent,
    int? minQuantity,
    // Bundle: one full set for [bundlePrice] instead of [originalTotal].
    double? bundlePrice,
    double? originalTotal,
    // Whether this item is bought or handed out free in the deal.
    @Default(1) int role,
    // Null when the deal never ends.
    @ServerUtcDateConverter() DateTime? expiresAt,
  }) = _ItemOfferDto;

  factory ItemOfferDto.fromJson(Map<String, dynamic> json) =>
      _$ItemOfferDtoFromJson(json);

  DealType get dealType => DealType.fromInt(type);
  DealLineRole get lineRole => DealLineRole.fromInt(role);

  /// False once the end has passed on this device.
  bool get isLive => expiresAt == null || expiresAt!.isAfter(DateTime.now());
}
