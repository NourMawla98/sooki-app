// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../apis/address_api.dart' as _i645;
import '../apis/announcement_api.dart' as _i733;
import '../apis/auth_api.dart' as _i42;
import '../apis/banner_api.dart' as _i923;
import '../apis/cart_api.dart' as _i692;
import '../apis/categories_api.dart' as _i985;
import '../apis/colors_api.dart' as _i256;
import '../apis/items_api.dart' as _i94;
import '../apis/location_api.dart' as _i734;
import '../apis/notification_preferences_api.dart' as _i433;
import '../apis/notifications_api.dart' as _i625;
import '../apis/orders_api.dart' as _i143;
import '../apis/profile_api.dart' as _i48;
import '../apis/reports_api.dart' as _i851;
import '../apis/size_standards_api.dart' as _i464;
import '../apis/wishlist_api.dart' as _i1055;

// initializes the registration of main-scope dependencies inside of GetIt
_i174.GetIt $initGetIt(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i526.GetItHelper(getIt, environment, environmentFilter);
  gh.factory<_i645.AddressApi>(
    () => _i645.AddressApi(gh<_i361.Dio>(instanceName: 'apiClient')),
  );
  gh.factory<_i733.AnnouncementApi>(
    () => _i733.AnnouncementApi(gh<_i361.Dio>(instanceName: 'apiClient')),
  );
  gh.factory<_i42.AuthApi>(
    () => _i42.AuthApi(gh<_i361.Dio>(instanceName: 'apiClient')),
  );
  gh.factory<_i923.BannerApi>(
    () => _i923.BannerApi(gh<_i361.Dio>(instanceName: 'apiClient')),
  );
  gh.factory<_i692.CartApi>(
    () => _i692.CartApi(gh<_i361.Dio>(instanceName: 'apiClient')),
  );
  gh.factory<_i985.CategoriesApi>(
    () => _i985.CategoriesApi(gh<_i361.Dio>(instanceName: 'apiClient')),
  );
  gh.factory<_i256.ColorsApi>(
    () => _i256.ColorsApi(gh<_i361.Dio>(instanceName: 'apiClient')),
  );
  gh.factory<_i94.ItemsApi>(
    () => _i94.ItemsApi(gh<_i361.Dio>(instanceName: 'apiClient')),
  );
  gh.factory<_i734.LocationApi>(
    () => _i734.LocationApi(gh<_i361.Dio>(instanceName: 'apiClient')),
  );
  gh.factory<_i433.NotificationPreferencesApi>(
    () => _i433.NotificationPreferencesApi(
      gh<_i361.Dio>(instanceName: 'apiClient'),
    ),
  );
  gh.factory<_i625.NotificationsApi>(
    () => _i625.NotificationsApi(gh<_i361.Dio>(instanceName: 'apiClient')),
  );
  gh.factory<_i143.OrdersApi>(
    () => _i143.OrdersApi(gh<_i361.Dio>(instanceName: 'apiClient')),
  );
  gh.factory<_i48.ProfileApi>(
    () => _i48.ProfileApi(gh<_i361.Dio>(instanceName: 'apiClient')),
  );
  gh.factory<_i851.ReportsApi>(
    () => _i851.ReportsApi(gh<_i361.Dio>(instanceName: 'apiClient')),
  );
  gh.factory<_i464.SizeStandardsApi>(
    () => _i464.SizeStandardsApi(gh<_i361.Dio>(instanceName: 'apiClient')),
  );
  gh.factory<_i1055.WishlistApi>(
    () => _i1055.WishlistApi(gh<_i361.Dio>(instanceName: 'apiClient')),
  );
  return getIt;
}
