// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_deal_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CustomerDealDto _$CustomerDealDtoFromJson(Map<String, dynamic> json) =>
    _CustomerDealDto(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      description: json['description'] as String?,
      startsAt: const ServerUtcDateConverter().fromJson(
        json['startsAt'] as String,
      ),
      expiresAt: _$JsonConverterFromJson<String, DateTime>(
        json['expiresAt'],
        const ServerUtcDateConverter().fromJson,
      ),
      isLive: json['isLive'] as bool,
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => ItemListItemDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      type: (json['type'] as num?)?.toInt() ?? 1,
      discountPercent: (json['discountPercent'] as num?)?.toDouble(),
      minQuantity: (json['minQuantity'] as num?)?.toInt(),
      bundlePrice: (json['bundlePrice'] as num?)?.toDouble(),
      originalTotal: (json['originalTotal'] as num?)?.toDouble(),
      spendThreshold: (json['spendThreshold'] as num?)?.toDouble(),
      lines:
          (json['lines'] as List<dynamic>?)
              ?.map((e) => DealLineDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

_DealLineDto _$DealLineDtoFromJson(Map<String, dynamic> json) => _DealLineDto(
  itemId: (json['itemId'] as num).toInt(),
  quantity: (json['quantity'] as num?)?.toInt() ?? 1,
  role: (json['role'] as num?)?.toInt() ?? 1,
);
