// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'size_standard_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SizeStandardDto _$SizeStandardDtoFromJson(Map<String, dynamic> json) =>
    _SizeStandardDto(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      values:
          (json['values'] as List<dynamic>?)
              ?.map((e) => SizeValueDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
