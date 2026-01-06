import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import '../dio/client/api_client.dart';
import 'dependency_injection.config.dart';

/// Global service locator instance
final GetIt serviceLocator = GetIt.instance;

/// Initializes the dependency injection container
///
/// Call this once at app startup before using any dependencies
///
/// Example:
/// ```dart
/// void main() async {
///   WidgetsFlutterBinding.ensureInitialized();
///   await setupDependencyInjection();
///   runApp(MyApp());
/// }
/// ```
@InjectableInit(
  initializerName: r'$initGetIt',
  preferRelativeImports: true,
  asExtension: false,
)
Future<void> setupDependencyInjection({
  String environment = 'dev',
}) async {
  $initGetIt(serviceLocator, environment: environment);
}

/// Module for registering external dependencies
@module
abstract class AppModule {
  /// Provides the Dio HTTP client as a singleton
  ///
  /// TODO: Update base URL based on environment
  @Singleton()
  @Named(apiClientKey)
  Dio get apiClient {
    const String baseUrl = 'http://10.0.2.2:3000/api/'; // Android emulator localhost

    return createApiClient(baseUrl: baseUrl);
  }

  // TODO: Add other external dependencies here (SharedPreferences, etc.)
  // @preResolve
  // @singleton
  // Future<SharedPreferences> get prefs => SharedPreferences.getInstance();
}
