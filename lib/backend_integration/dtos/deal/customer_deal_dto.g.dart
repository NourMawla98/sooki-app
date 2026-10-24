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
    );

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);
