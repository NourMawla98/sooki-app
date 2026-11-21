// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_offer_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ItemOfferDto _$ItemOfferDtoFromJson(Map<String, dynamic> json) =>
    _ItemOfferDto(
      dealId: (json['dealId'] as num).toInt(),
      type: (json['type'] as num?)?.toInt() ?? 1,
      title: json['title'] as String? ?? '',
      discountPercent: (json['discountPercent'] as num?)?.toDouble(),
      minQuantity: (json['minQuantity'] as num?)?.toInt(),
      bundlePrice: (json['bundlePrice'] as num?)?.toDouble(),
      originalTotal: (json['originalTotal'] as num?)?.toDouble(),
      role: (json['role'] as num?)?.toInt() ?? 1,
      expiresAt: _$JsonConverterFromJson<String, DateTime>(
        json['expiresAt'],
        const ServerUtcDateConverter().fromJson,
      ),
    );

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);
