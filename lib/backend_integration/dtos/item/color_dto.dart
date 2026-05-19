import 'package:freezed_annotation/freezed_annotation.dart';

part 'color_dto.freezed.dart';
part 'color_dto.g.dart';

@Freezed(toJson: false, fromJson: true)
abstract class ColorDto with _$ColorDto {
  const factory ColorDto({
    required int id,
    required String name,
    required String hexCode,
  }) = _ColorDto;

  factory ColorDto.fromJson(Map<String, dynamic> json) =>
      _$ColorDtoFromJson(json);
}
