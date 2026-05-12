// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_list_item_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ItemListItemDto _$ItemListItemDtoFromJson(Map<String, dynamic> json) =>
    _ItemListItemDto(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      originalPrice: (json['originalPrice'] as num).toDouble(),
      discountedPrice: (json['discountedPrice'] as num?)?.toDouble(),
      storeName: json['storeName'] as String,
      categoryName: json['categoryName'] as String,
      colorImages:
          (json['colorImages'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );
