// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_detail_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OrderDetailDto _$OrderDetailDtoFromJson(Map<String, dynamic> json) =>
    _OrderDetailDto(
      id: (json['id'] as num).toInt(),
      trackingNumber: json['trackingNumber'] as String,
      status: (json['status'] as num).toInt(),
      customerName: json['customerName'] as String,
      addressLabel: json['addressLabel'] as String?,
      city: json['city'] as String,
      area: json['area'] as String?,
      street: json['street'] as String?,
      building: json['building'] as String?,
      floor: json['floor'] as String?,
      customerNote: json['customerNote'] as String?,
      subtotal: (json['subtotal'] as num).toDouble(),
      discountAmount: (json['discountAmount'] as num).toDouble(),
      deliveryFee: (json['deliveryFee'] as num).toDouble(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      paymentMethod: (json['paymentMethod'] as num?)?.toInt(),
      paymentStatus: (json['paymentStatus'] as num?)?.toInt(),
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => OrderItemDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
