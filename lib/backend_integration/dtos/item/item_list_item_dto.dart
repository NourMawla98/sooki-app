import 'package:freezed_annotation/freezed_annotation.dart';

import '../deal/item_deal_dto.dart';
import '../deal/item_offer_dto.dart';
import 'item_tag_dto.dart';

part 'item_list_item_dto.freezed.dart';
part 'item_list_item_dto.g.dart';

@Freezed(toJson: false, fromJson: true)
abstract class ItemListItemDto with _$ItemListItemDto {
  const factory ItemListItemDto({
    required int id,
    required String title,
    required double originalPrice,
    double? discountedPrice,
    required String categoryName,
    @Default([]) List<String> colorImages,
    @Default([]) List<ItemTagDto> tags,
    ItemDealDto? deal,
    // Bundle, multi-buy and free gift deals the item is part of.
    @Default([]) List<ItemOfferDto> offers,
  }) = _ItemListItemDto;

  factory ItemListItemDto.fromJson(Map<String, dynamic> json) =>
      _$ItemListItemDtoFromJson(json);
}
