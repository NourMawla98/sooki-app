import 'package:freezed_annotation/freezed_annotation.dart';

part 'detail_category_dto.freezed.dart';
part 'detail_category_dto.g.dart';

@Freezed(toJson: false, fromJson: true)
abstract class DetailCategoryDto with _$DetailCategoryDto {
  const factory DetailCategoryDto({
    required int id,
    required String name,
    String? imageUrl,
  }) = _DetailCategoryDto;

  factory DetailCategoryDto.fromJson(Map<String, dynamic> json) =>
      _$DetailCategoryDtoFromJson(json);
}
