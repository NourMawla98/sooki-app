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

import '../apis/announcement_api.dart' as _i733;
import '../apis/auth_api.dart' as _i42;
import '../apis/banner_api.dart' as _i923;
import '../apis/categories_api.dart' as _i985;
import '../apis/colors_api.dart' as _i311;
import '../apis/items_api.dart' as _i94;
import '../apis/profile_api.dart' as _i48;
import '../apis/size_standards_api.dart' as _i577;

// initializes the registration of main-scope dependencies inside of GetIt
_i174.GetIt $initGetIt(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i526.GetItHelper(getIt, environment, environmentFilter);
  gh.factory<_i733.AnnouncementApi>(
    () => _i733.AnnouncementApi(gh<_i361.Dio>(instanceName: 'apiClient')),
  );
  gh.factory<_i42.AuthApi>(
    () => _i42.AuthApi(gh<_i361.Dio>(instanceName: 'apiClient')),
  );
  gh.factory<_i923.BannerApi>(
    () => _i923.BannerApi(gh<_i361.Dio>(instanceName: 'apiClient')),
  );
  gh.factory<_i985.CategoriesApi>(
    () => _i985.CategoriesApi(gh<_i361.Dio>(instanceName: 'apiClient')),
  );
  gh.factory<_i311.ColorsApi>(
    () => _i311.ColorsApi(gh<_i361.Dio>(instanceName: 'apiClient')),
  );
  gh.factory<_i94.ItemsApi>(
    () => _i94.ItemsApi(gh<_i361.Dio>(instanceName: 'apiClient')),
  );
  gh.factory<_i48.ProfileApi>(
    () => _i48.ProfileApi(gh<_i361.Dio>(instanceName: 'apiClient')),
  );
  gh.factory<_i577.SizeStandardsApi>(
    () => _i577.SizeStandardsApi(gh<_i361.Dio>(instanceName: 'apiClient')),
  );
  return getIt;
}
