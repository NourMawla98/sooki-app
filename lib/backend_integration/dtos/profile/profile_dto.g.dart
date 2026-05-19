// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProfileDto _$ProfileDtoFromJson(Map<String, dynamic> json) => _ProfileDto(
  id: (json['id'] as num).toInt(),
  email: json['email'] as String,
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
  phoneCountryCode: json['phoneCountryCode'] as String?,
  phoneNumber: json['phoneNumber'] as String?,
  isVerified: json['isVerified'] as bool,
);
