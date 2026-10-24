import 'package:json_annotation/json_annotation.dart';

/// Reads a backend timestamp as UTC.
///
/// The backend stores times in UTC but can send them without a zone designator,
/// and `DateTime.parse` would then read them as local time, shifting every
/// countdown by the device's offset. A value that already carries a zone is
/// parsed as sent.
DateTime parseServerUtc(String value) {
  final hasZone =
      value.endsWith('Z') || RegExp(r'[+-]\d{2}:?\d{2}$').hasMatch(value);
  return DateTime.parse(hasZone ? value : '${value}Z');
}

class ServerUtcDateConverter implements JsonConverter<DateTime, String> {
  const ServerUtcDateConverter();

  @override
  DateTime fromJson(String json) => parseServerUtc(json);

  @override
  String toJson(DateTime object) => object.toUtc().toIso8601String();
}
