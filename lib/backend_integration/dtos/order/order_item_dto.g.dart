// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_item_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OrderItemDto _$OrderItemDtoFromJson(Map<String, dynamic> json) =>
    _OrderItemDto(
      id: (json['id'] as num).toInt(),
      itemId: (json['itemId'] as num?)?.toInt() ?? 0,
      status: (json['status'] as num).toInt(),
      quantity: (json['quantity'] as num).toInt(),
      unitPrice: (json['unitPrice'] as num).toDouble(),
      totalPrice: (json['totalPrice'] as num).toDouble(),
      itemTitle: json['itemTitle'] as String,
      colorName: json['colorName'] as String,
      sizeName: json['sizeName'] as String,
      imageUrl: json['imageUrl'] as String?,
    );
