import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/address_service.dart';
import '../../services/auth_service.dart';
import '../../services/cart_service.dart';
import '../../services/language_service.dart';
import '../../services/orders_service.dart';
import '../../services/places_service.dart';
import '../apis/address_api.dart';
import '../apis/cart_api.dart';
import '../apis/location_api.dart';
import '../apis/orders_api.dart';
import '../../services/search_history_service.dart';
import '../../services/user_profile_service.dart';
import '../../services/viewed_items_service.dart';
import '../../services/wishlist_service.dart';
import '../apis/wishlist_api.dart';
import '../dio/client/api_client.dart';
import 'dependency_injection.config.dart';

/// Global service locator instance
final GetIt serviceLocator = GetIt.instance;

/// API base URL for Android emulator localhost
const String apiBaseUrl = 'http://10.0.2.2:1010/api/';

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
  serviceLocator.registerSingleton<SharedPreferences>(prefs);
  serviceLocator.registerSingleton<LanguageService>(languageService);

  final searchHistory = SearchHistoryService(serviceLocator<SharedPreferences>());
  await searchHistory.load();
  serviceLocator.registerSingleton<SearchHistoryService>(searchHistory);

  final viewedItems = ViewedItemsService(serviceLocator<SharedPreferences>());
  await viewedItems.load();
  serviceLocator.registerSingleton<ViewedItemsService>(viewedItems);

  // AddressService and PlacesService are registered after Dio (below)

  final authService = AuthService();
  serviceLocator.registerSingleton<AuthService>(authService);

  final userProfileService = UserProfileService(serviceLocator<SharedPreferences>());
  await userProfileService.load();
  serviceLocator.registerSingleton<UserProfileService>(userProfileService);

  serviceLocator.registerSingleton<Dio>(
    createApiClient(
      baseUrl: apiBaseUrl,
      languageService: languageService,
      authService: serviceLocator<AuthService>(),
    ),
    instanceName: apiClientKey,
  );

  $initGetIt(serviceLocator, environment: environment);

  final wishlistService = WishlistService(serviceLocator<WishlistApi>());
  serviceLocator.registerSingleton<WishlistService>(wishlistService);

  final cartService = CartService(serviceLocator<CartApi>());
  serviceLocator.registerSingleton<CartService>(cartService);

  final addressService = AddressService(serviceLocator<AddressApi>());
  serviceLocator.registerSingleton<AddressService>(addressService);

  final placesService = PlacesService(serviceLocator<LocationApi>());
  serviceLocator.registerSingleton<PlacesService>(placesService);

  final ordersService = OrdersService(serviceLocator<OrdersApi>());
  serviceLocator.registerSingleton<OrdersService>(ordersService);
}

@module
abstract class AppModule {}
