import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/cart_service.dart';
import '../../services/language_service.dart';
import '../../services/search_history_service.dart';
import '../../services/wishlist_service.dart';
import '../dio/client/api_client.dart';
import 'dependency_injection.config.dart';

/// Global service locator instance
final GetIt serviceLocator = GetIt.instance;

/// API base URL for Android emulator localhost
const String apiBaseUrl = 'http://10.0.2.2:1010/api/';

/// Initializes the dependency injection container
///
/// Call this once at app startup before using any dependencies.
/// SharedPreferences and LanguageService must be initialized before calling this.
///
/// Example:
/// ```dart
/// void main() async {
///   WidgetsFlutterBinding.ensureInitialized();
///   final prefs = await SharedPreferences.getInstance();
///   final languageService = await LanguageService.initialize(prefs);
///   await setupDependencyInjection(prefs: prefs, languageService: languageService);
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
  required SharedPreferences prefs,
  required LanguageService languageService,
}) async {
  // Register pre-initialized dependencies
  serviceLocator.registerSingleton<SharedPreferences>(prefs);
  serviceLocator.registerSingleton<LanguageService>(languageService);

  // Cart & Wishlist services
  serviceLocator.registerSingleton<CartService>(
    CartService(serviceLocator<SharedPreferences>()),
  );
  serviceLocator.registerSingleton<WishlistService>(
    WishlistService(serviceLocator<SharedPreferences>()),
  );

  final searchHistory =
      SearchHistoryService(serviceLocator<SharedPreferences>());
  await searchHistory.load();
  serviceLocator.registerSingleton<SearchHistoryService>(searchHistory);

  // Register Dio client with language service
  serviceLocator.registerSingleton<Dio>(
    createApiClient(
      baseUrl: apiBaseUrl,
      languageService: languageService,
    ),
    instanceName: apiClientKey,
  );

  // Initialize injectable dependencies
  $initGetIt(serviceLocator, environment: environment);
}

/// Module for registering external dependencies
@module
abstract class AppModule {
  // SharedPreferences and LanguageService are registered manually in setupDependencyInjection
  // Dio client is also registered manually to inject LanguageService
}
