// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'for_you_item_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ForYouItemDto _$ForYouItemDtoFromJson(Map<String, dynamic> json) =>
    _ForYouItemDto(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      imageUrl: json['imageUrl'] as String?,
      originalPrice: (json['originalPrice'] as num).toDouble(),
      discountedPrice: (json['discountedPrice'] as num?)?.toDouble(),
      reasonMessage: json['reasonMessage'] as String,
    );
