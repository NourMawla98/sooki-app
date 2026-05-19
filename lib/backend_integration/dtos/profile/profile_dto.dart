import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_dto.freezed.dart';
part 'profile_dto.g.dart';

@Freezed(toJson: false, fromJson: true)
abstract class ProfileDto with _$ProfileDto {
  const factory ProfileDto({
    required int id,
    required String email,
    required String firstName,
    required String lastName,
    String? phoneCountryCode,
    String? phoneNumber,
    required bool isVerified,
  }) = _ProfileDto;

  factory ProfileDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileDtoFromJson(json);
}
