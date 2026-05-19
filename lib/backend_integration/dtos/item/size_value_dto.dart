import 'package:freezed_annotation/freezed_annotation.dart';

part 'size_value_dto.freezed.dart';
part 'size_value_dto.g.dart';

@Freezed(toJson: false, fromJson: true)
abstract class SizeValueDto with _$SizeValueDto {
  const factory SizeValueDto({
    required int id,
    required String displayValue,
  }) = _SizeValueDto;

  factory SizeValueDto.fromJson(Map<String, dynamic> json) =>
      _$SizeValueDtoFromJson(json);
}
