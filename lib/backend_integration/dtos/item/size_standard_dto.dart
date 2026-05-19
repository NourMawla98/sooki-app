import 'package:freezed_annotation/freezed_annotation.dart';

import 'size_value_dto.dart';

part 'size_standard_dto.freezed.dart';
part 'size_standard_dto.g.dart';

@Freezed(toJson: false, fromJson: true)
abstract class SizeStandardDto with _$SizeStandardDto {
  const factory SizeStandardDto({
    required int id,
    required String name,
    @Default([]) List<SizeValueDto> values,
  }) = _SizeStandardDto;

  factory SizeStandardDto.fromJson(Map<String, dynamic> json) =>
      _$SizeStandardDtoFromJson(json);
}
