// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CartResponseDto _$CartResponseDtoFromJson(Map<String, dynamic> json) =>
    _CartResponseDto(
      itemCount: (json['itemCount'] as num).toInt(),
      subtotal: (json['subtotal'] as num).toDouble(),
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => CartItemDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

_CartItemDto _$CartItemDtoFromJson(Map<String, dynamic> json) => _CartItemDto(
  id: (json['id'] as num).toInt(),
  itemId: (json['itemId'] as num).toInt(),
  itemTitle: json['itemTitle'] as String,
  itemColorId: (json['itemColorId'] as num).toInt(),
  colorName: json['colorName'] as String,
  mainImageUrl: json['mainImageUrl'] as String?,
  itemSizeId: (json['itemSizeId'] as num).toInt(),
  sizeName: json['sizeName'] as String,
  unitPrice: (json['unitPrice'] as num).toDouble(),
  quantity: (json['quantity'] as num).toInt(),
  lineTotal: (json['lineTotal'] as num).toDouble(),
  stock: (json['stock'] as num).toInt(),
  isAvailable: json['isAvailable'] as bool,
);
