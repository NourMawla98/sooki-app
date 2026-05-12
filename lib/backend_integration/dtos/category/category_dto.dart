import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_dto.freezed.dart';
part 'category_dto.g.dart';

@Freezed(toJson: false, fromJson: true)
abstract class CategoryDto with _$CategoryDto {
  const factory CategoryDto({
    required int id,
    required String name,
  }) = _CategoryDto;

  factory CategoryDto.fromJson(Map<String, dynamic> json) =>
      _$CategoryDtoFromJson(json);
}
