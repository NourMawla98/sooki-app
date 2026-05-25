// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AddressDto _$AddressDtoFromJson(Map<String, dynamic> json) => _AddressDto(
  id: (json['id'] as num).toInt(),
  label: json['label'] as String?,
  fullName: json['fullName'] as String,
  street: json['street'] as String,
  building: json['buildingName'] as String?,
  floor: json['floor'] as String?,
  apt: json['apartment'] as String?,
  instructions: json['instructions'] as String?,
  city: LocationItemDto.fromJson(json['city'] as Map<String, dynamic>),
  area: json['area'] == null
      ? null
      : LocationItemDto.fromJson(json['area'] as Map<String, dynamic>),
  latitude: (json['latitude'] as num?)?.toDouble(),
  longitude: (json['longitude'] as num?)?.toDouble(),
  isDefault: json['isDefault'] as bool? ?? false,
);
