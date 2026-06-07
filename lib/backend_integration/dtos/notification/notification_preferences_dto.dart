class NotificationPreferencesDto {
  final bool pushNotificationsEnabled;
  final bool emailNotificationsEnabled;

  const NotificationPreferencesDto({
    required this.pushNotificationsEnabled,
    required this.emailNotificationsEnabled,
  });

  factory NotificationPreferencesDto.fromJson(Map<String, dynamic> json) =>
      NotificationPreferencesDto(
        pushNotificationsEnabled:
            json['pushNotificationsEnabled'] as bool? ?? false,
        emailNotificationsEnabled:
            json['emailNotificationsEnabled'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        'pushNotificationsEnabled': pushNotificationsEnabled,
        'emailNotificationsEnabled': emailNotificationsEnabled,
      };
}
