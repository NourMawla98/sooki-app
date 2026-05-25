// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_list_item_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OrderListItemDto _$OrderListItemDtoFromJson(Map<String, dynamic> json) =>
    _OrderListItemDto(
      id: (json['id'] as num).toInt(),
      trackingNumber: json['trackingNumber'] as String,
      status: (json['status'] as num).toInt(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => OrderItemDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
