/// The versions the backend supports for this app on this platform.
class AppVersionConfig {
  final String minSupportedVersion;
  final String latestVersion;
  final String storeUrl;

  /// Free text from the backend shown as is, or null for the default text.
  final String? message;

  const AppVersionConfig({
    required this.minSupportedVersion,
    required this.latestVersion,
    required this.storeUrl,
    this.message,
  });

  /// Null when the payload is missing a version, so a malformed answer never
  /// blocks the app.
  static AppVersionConfig? tryParse(Object? json) {
    if (json is! Map<String, dynamic>) return null;
    final min = json['minSupportedVersion'];
    final latest = json['latestVersion'];
    if (min is! String || latest is! String) return null;
    final message = json['message'];
    return AppVersionConfig(
      minSupportedVersion: min,
      latestVersion: latest,
      storeUrl: json['storeUrl'] as String? ?? '',
      message: message is String && message.trim().isNotEmpty ? message : null,
    );
  }
}

/// What the app must do about its version.
enum AppUpdateStatus {
  /// At or above the latest version: nothing to show.
  upToDate,

  /// Supported but behind the latest: a banner the shopper can dismiss.
  updateAvailable,

  /// Below the minimum: a screen that blocks the app until it is updated.
  updateRequired,
}

/// Compares two dotted versions part by part as numbers, so "1.10" is above
/// "1.9" and "1.2" equals "1.2.0". A build suffix ("1.2.3+4") and anything
/// that is not a number in a part are ignored. Negative when [a] is lower.
int compareVersions(String a, String b) {
  List<int> parts(String v) => v
      .split('+')
      .first
      .split('-')
      .first
      .trim()
      .split('.')
      .map((p) => int.tryParse(p.trim()) ?? 0)
      .toList();

  final left = parts(a);
  final right = parts(b);
  final length = left.length > right.length ? left.length : right.length;
  for (var i = 0; i < length; i++) {
    final l = i < left.length ? left[i] : 0;
    final r = i < right.length ? right[i] : 0;
    if (l != r) return l < r ? -1 : 1;
  }
  return 0;
}

/// Where [current] stands against [config].
AppUpdateStatus evaluateAppVersion(String current, AppVersionConfig config) {
  if (compareVersions(current, config.minSupportedVersion) < 0) {
    return AppUpdateStatus.updateRequired;
  }
  if (compareVersions(current, config.latestVersion) < 0) {
    return AppUpdateStatus.updateAvailable;
  }
  return AppUpdateStatus.upToDate;
}
