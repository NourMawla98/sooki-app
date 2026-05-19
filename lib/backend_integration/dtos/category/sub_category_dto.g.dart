// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sub_category_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SubCategoryDto _$SubCategoryDtoFromJson(Map<String, dynamic> json) =>
    _SubCategoryDto(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String?,
      detailCategories:
          (json['detailCategories'] as List<dynamic>?)
              ?.map(
                (e) => DetailCategoryDto.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
    );
