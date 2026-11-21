import 'package:dio/dio.dart';

import '../../../models/app_version.dart';
import '../../../services/app_version_gate.dart';

/// Turns a 426 from any request into the blocking update screen, using the
/// version config the backend sends with it.
class AppVersionInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final response = err.response;
    if (response?.statusCode == 426) {
      final body = response?.data;
      final config = AppVersionConfig.tryParse(
        body is Map<String, dynamic> ? body['data'] : null,
      );
      if (config != null) AppVersionGate.instance.requireUpdate(config);
    }
    handler.next(err);
  }
}
