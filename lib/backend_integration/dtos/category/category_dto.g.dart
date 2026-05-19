// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CategoryDto _$CategoryDtoFromJson(Map<String, dynamic> json) => _CategoryDto(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  imageUrl: json['imageUrl'] as String?,
  subCategories:
      (json['subCategories'] as List<dynamic>?)
          ?.map((e) => SubCategoryDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);
