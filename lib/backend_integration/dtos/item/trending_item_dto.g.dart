// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trending_item_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TrendingItemDto _$TrendingItemDtoFromJson(Map<String, dynamic> json) =>
    _TrendingItemDto(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      imageUrl: json['imageUrl'] as String,
      price: (json['price'] as num).toDouble(),
    );
