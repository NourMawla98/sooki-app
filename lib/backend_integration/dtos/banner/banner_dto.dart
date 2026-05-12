import 'package:freezed_annotation/freezed_annotation.dart';

part 'banner_dto.freezed.dart';
part 'banner_dto.g.dart';

@Freezed(toJson: false, fromJson: true)
abstract class BannerDto with _$BannerDto {
  const factory BannerDto({
    required int id,
    required int type,
    String? url,
    String? title,
    String? subtitle,
    String? description,
    String? redirectionRoute,
  }) = _BannerDto;

  factory BannerDto.fromJson(Map<String, dynamic> json) =>
      _$BannerDtoFromJson(json);
}
