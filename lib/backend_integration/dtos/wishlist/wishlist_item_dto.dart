import 'package:freezed_annotation/freezed_annotation.dart';

part 'wishlist_item_dto.freezed.dart';
part 'wishlist_item_dto.g.dart';

@Freezed(toJson: false, fromJson: true)
abstract class WishlistItemDto with _$WishlistItemDto {
  const factory WishlistItemDto({
    required int id,
    required int itemId,
    required String itemTitle,
    String? mainImageUrl,
    required double originalPrice,
    double? discountedPrice,
    required bool isAvailable,
  }) = _WishlistItemDto;

  factory WishlistItemDto.fromJson(Map<String, dynamic> json) =>
      _$WishlistItemDtoFromJson(json);
}
