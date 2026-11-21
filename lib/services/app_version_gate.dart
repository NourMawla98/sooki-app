import 'dart:async';

import 'package:flutter/foundation.dart';

import '../backend_integration/apis/app_version_api.dart';
import '../models/app_version.dart';
import 'app_reload_signal.dart';

/// Holds whether this build may keep running, may be updated, or must be.
///
/// Checked on cold start and every resume. A 426 from any request also lands
/// here. Failures fail open: a network error or a slow answer never blocks the
/// app, but never lifts a block already shown either.
class AppVersionGate extends ChangeNotifier {
  AppVersionGate._();

  static final AppVersionGate instance = AppVersionGate._();

  /// The name the backend knows this app by.
  static const String appName = 'customer';

  static const Duration checkTimeout = Duration(seconds: 15);

  AppUpdateStatus _status = AppUpdateStatus.upToDate;
  AppVersionConfig? _config;
  bool _bannerDismissed = false;
  bool _checking = false;

  AppUpdateStatus get status => _status;
  AppVersionConfig? get config => _config;

  bool get isBlocked => _status == AppUpdateStatus.updateRequired;

  bool get showBanner =>
      _status == AppUpdateStatus.updateAvailable && !_bannerDismissed;

  /// Asks the backend which versions it supports and compares [currentVersion].
  /// A failed or slow attempt is tried once more before giving up.
  Future<void> check({
    required AppVersionApi api,
    required String currentVersion,
    required String platform,
    Duration timeout = checkTimeout,
  }) async {
    if (_checking || platform.isEmpty) return;
    _checking = true;
    try {
      for (var attempt = 0; attempt < 2; attempt++) {
        final config = await _fetch(api, platform, timeout);
        if (config != null) {
          apply(currentVersion, config);
          return;
        }
      }
      // Fail open: no answer leaves the current state as it is.
    } finally {
      _checking = false;
    }
  }

  Future<AppVersionConfig?> _fetch(
    AppVersionApi api,
    String platform,
    Duration timeout,
  ) async {
    try {
      final result = await api
          .getConfig(app: appName, platform: platform)
          .timeout(timeout);
      return result.fold((_) => null, (config) => config);
    } on TimeoutException {
      return null;
    }
  }

  /// Applies a config. A block, once shown, is only lifted by a config that
  /// says this version is supported.
  void apply(String currentVersion, AppVersionConfig config) {
    final next = evaluateAppVersion(currentVersion, config);
    if (next == _status && config == _config) return;
    final wasBlocked = isBlocked;
    if (next != AppUpdateStatus.updateAvailable) _bannerDismissed = false;
    _status = next;
    _config = config;
    notifyListeners();
    // Requests made while blocked were refused, so the screens behind the
    // block hold errors; they load again once it lifts.
    if (wasBlocked && !isBlocked) AppReloadSignal.instance.reloadAll();
  }

  /// A request was refused with 426: block with the config the backend sent.
  void requireUpdate(AppVersionConfig config) {
    _status = AppUpdateStatus.updateRequired;
    _config = config;
    notifyListeners();
  }

  void dismissBanner() {
    if (_bannerDismissed) return;
    _bannerDismissed = true;
    notifyListeners();
  }

  @visibleForTesting
  void reset() {
    _status = AppUpdateStatus.upToDate;
    _config = null;
    _bannerDismissed = false;
    _checking = false;
  }
}
