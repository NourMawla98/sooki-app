// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wishlist_item_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WishlistItemDto _$WishlistItemDtoFromJson(Map<String, dynamic> json) =>
    _WishlistItemDto(
      id: (json['id'] as num).toInt(),
      itemId: (json['itemId'] as num).toInt(),
      itemTitle: json['itemTitle'] as String,
      mainImageUrl: json['mainImageUrl'] as String?,
      originalPrice: (json['originalPrice'] as num).toDouble(),
      discountedPrice: (json['discountedPrice'] as num?)?.toDouble(),
      isAvailable: json['isAvailable'] as bool,
    );
