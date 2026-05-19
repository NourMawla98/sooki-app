import 'package:freezed_annotation/freezed_annotation.dart';

import 'detail_category_dto.dart';

part 'sub_category_dto.freezed.dart';
part 'sub_category_dto.g.dart';

@Freezed(toJson: false, fromJson: true)
abstract class SubCategoryDto with _$SubCategoryDto {
  const factory SubCategoryDto({
    required int id,
    required String name,
    String? imageUrl,
    @Default([]) List<DetailCategoryDto> detailCategories,
  }) = _SubCategoryDto;

  factory SubCategoryDto.fromJson(Map<String, dynamic> json) =>
      _$SubCategoryDtoFromJson(json);
}
