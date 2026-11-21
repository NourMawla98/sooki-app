import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sooki_app/backend_integration/apis/app_version_api.dart';
import 'package:sooki_app/backend_integration/dio/client/request_executor.dart';
import 'package:sooki_app/models/app_version.dart';
import 'package:sooki_app/services/app_reload_signal.dart';
import 'package:sooki_app/services/app_version_gate.dart';

const _config = AppVersionConfig(
  minSupportedVersion: '1.2.0',
  latestVersion: '1.4.0',
  storeUrl: 'https://play.google.com/store/apps/details?id=com.sooki.app',
);

class _FakeApi extends AppVersionApi {
  _FakeApi(this.answer) : super(Dio());

  Future<Either<ApiFailure, AppVersionConfig?>> Function() answer;

  @override
  Future<Either<ApiFailure, AppVersionConfig?>> getConfig({
    required String app,
    required String platform,
  }) => answer();
}

void main() {
  group('compareVersions', () {
    test('compares part by part as numbers', () {
      expect(compareVersions('1.10.0', '1.9.9'), 1);
      expect(compareVersions('1.2.3', '1.2.4'), -1);
      expect(compareVersions('2.0', '1.99.99'), 1);
    });

    test('treats missing parts as zero', () {
      expect(compareVersions('1.2', '1.2.0'), 0);
      expect(compareVersions('1', '1.0.1'), -1);
    });

    test('ignores build and pre-release suffixes', () {
      expect(compareVersions('1.2.3+45', '1.2.3'), 0);
      expect(compareVersions('1.2.3-beta', '1.2.3'), 0);
    });
  });

  group('evaluateAppVersion', () {
    test('below the minimum must update', () {
      expect(evaluateAppVersion('1.1.9', _config), AppUpdateStatus.updateRequired);
    });

    test('between minimum and latest may update', () {
      expect(evaluateAppVersion('1.2', _config), AppUpdateStatus.updateAvailable);
      expect(evaluateAppVersion('1.3.9', _config), AppUpdateStatus.updateAvailable);
    });

    test('at or above latest has nothing to do', () {
      expect(evaluateAppVersion('1.4.0', _config), AppUpdateStatus.upToDate);
      expect(evaluateAppVersion('1.5', _config), AppUpdateStatus.upToDate);
    });
  });

  group('AppVersionConfig.tryParse', () {
    test('reads the backend payload, blank message as none', () {
      final config = AppVersionConfig.tryParse({
        'minSupportedVersion': '1.0.0',
        'latestVersion': '1.1.0',
        'storeUrl': 'https://example.test',
        'message': '  ',
      });
      expect(config?.latestVersion, '1.1.0');
      expect(config?.message, isNull);
    });

    test('a malformed payload is null, never a block', () {
      expect(AppVersionConfig.tryParse(null), isNull);
      expect(AppVersionConfig.tryParse({'latestVersion': '1.0.0'}), isNull);
    });
  });

  group('AppVersionGate', () {
    final gate = AppVersionGate.instance;
    setUp(gate.reset);

    test('blocks below the minimum, banners below latest', () async {
      await gate.check(
        api: _FakeApi(() async => const Right(_config)),
        currentVersion: '1.0.0',
        platform: 'android',
      );
      expect(gate.isBlocked, isTrue);

      gate.reset();
      await gate.check(
        api: _FakeApi(() async => const Right(_config)),
        currentVersion: '1.3.0',
        platform: 'android',
      );
      expect(gate.isBlocked, isFalse);
      expect(gate.showBanner, isTrue);
      gate.dismissBanner();
      expect(gate.showBanner, isFalse);
    });

    test('a failed or slow check fails open but keeps a block', () async {
      final failure = (message: 'down', error: Exception('down'));
      await gate.check(
        api: _FakeApi(() async => Left(failure)),
        currentVersion: '1.0.0',
        platform: 'android',
      );
      expect(gate.isBlocked, isFalse);

      gate.requireUpdate(_config);
      await gate.check(
        api: _FakeApi(() async => Left(failure)),
        currentVersion: '1.0.0',
        platform: 'android',
      );
      expect(gate.isBlocked, isTrue);
    });

    test('a failed attempt is retried once', () async {
      var calls = 0;
      final flaky = _FakeApi(() async {
        calls++;
        return calls == 1
            ? Left((message: 'down', error: Exception('down')))
            : const Right(_config);
      });
      await gate.check(api: flaky, currentVersion: '1.0.0', platform: 'android');
      expect(calls, 2);
      expect(gate.isBlocked, isTrue);
    });

    test('a check that never answers gives up after the timeout', () async {
      final hung = _FakeApi(
        () => Future<Either<ApiFailure, AppVersionConfig?>>.delayed(
          const Duration(seconds: 1),
          () => const Right(_config),
        ),
      );
      await gate.check(
        api: hung,
        currentVersion: '1.0.0',
        platform: 'android',
        timeout: const Duration(milliseconds: 20),
      );
      expect(gate.isBlocked, isFalse);
    });

    test('lifting a block asks the screens to reload, once', () {
      var reloads = 0;
      void count() => reloads++;
      AppReloadSignal.instance.addListener(count);
      addTearDown(() => AppReloadSignal.instance.removeListener(count));

      gate.apply('1.3.0', _config);
      expect(reloads, 0);
      gate.requireUpdate(_config);
      gate.apply('1.4.0', _config);
      expect(gate.isBlocked, isFalse);
      expect(reloads, 1);
      gate.apply('1.4.0', _config);
      expect(reloads, 1);
    });

    test('a 426 config blocks right away', () {
      gate.requireUpdate(_config);
      expect(gate.isBlocked, isTrue);
      expect(gate.config?.storeUrl, _config.storeUrl);
    });
  });
}

