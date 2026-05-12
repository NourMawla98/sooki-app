// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'banner_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BannerDto _$BannerDtoFromJson(Map<String, dynamic> json) => _BannerDto(
  id: (json['id'] as num).toInt(),
  type: (json['type'] as num).toInt(),
  url: json['url'] as String?,
  title: json['title'] as String?,
  subtitle: json['subtitle'] as String?,
  description: json['description'] as String?,
  redirectionRoute: json['redirectionRoute'] as String?,
);
