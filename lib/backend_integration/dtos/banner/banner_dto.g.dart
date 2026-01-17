// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'banner_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BannerDtoImpl _$$BannerDtoImplFromJson(Map<String, dynamic> json) =>
    _$BannerDtoImpl(
      id: (json['id'] as num).toInt(),
      type: (json['type'] as num).toInt(),
      title: json['title'] as String,
      subtitle: json['subtitle'] as String?,
      description: json['description'] as String?,
      redirectionRoute: json['redirectionRoute'] as String?,
      imageUrls:
          (json['imageUrls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );
