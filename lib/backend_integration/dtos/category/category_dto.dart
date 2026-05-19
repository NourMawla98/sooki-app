import 'package:freezed_annotation/freezed_annotation.dart';

import 'sub_category_dto.dart';

part 'category_dto.freezed.dart';
part 'category_dto.g.dart';

@Freezed(toJson: false, fromJson: true)
abstract class CategoryDto with _$CategoryDto {
  const factory CategoryDto({
    required int id,
    required String name,
    String? imageUrl,
    @Default([]) List<SubCategoryDto> subCategories,
  }) = _CategoryDto;

  factory CategoryDto.fromJson(Map<String, dynamic> json) =>
      _$CategoryDtoFromJson(json);
}
