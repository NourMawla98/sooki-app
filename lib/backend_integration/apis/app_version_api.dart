import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../models/app_version.dart';
import '../dio/client/api_client.dart';
import '../dio/client/request_executor.dart';

@injectable
class AppVersionApi {
  final Dio _dio;

  AppVersionApi(@Named(apiClientKey) this._dio);

  /// The supported and latest versions of this app on [platform]
  /// (android or ios). Silent, since a failed check never bothers the shopper.
  Future<Either<ApiFailure, AppVersionConfig?>> getConfig({
    required String app,
    required String platform,
  }) {
    return executeRequest(
      client: _dio,
      method: HttpMethod.get,
      path: 'app-version',
      queryParameters: {'app': app, 'platform': platform},
      // Anonymous, so it never waits on a token refresh at launch.
      extra: const {'silentError': true, 'skipAuth': true},
      operationName: 'getAppVersion',
      successParser: (response) => AppVersionConfig.tryParse(
        (response.data as Map<String, dynamic>?)?['data'],
      ),
    );
  }
}
