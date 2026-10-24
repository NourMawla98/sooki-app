// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_deal_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ItemDealDto _$ItemDealDtoFromJson(Map<String, dynamic> json) => _ItemDealDto(
  dealId: (json['dealId'] as num).toInt(),
  dealPrice: (json['dealPrice'] as num).toDouble(),
  expiresAt: _$JsonConverterFromJson<String, DateTime>(
    json['expiresAt'],
    const ServerUtcDateConverter().fromJson,
  ),
);

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);
