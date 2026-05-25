import '../backend_integration/apis/location_api.dart';
import '../backend_integration/dtos/location/location_item_dto.dart';

class PlacesService {
  final LocationApi _api;

  PlacesService(this._api);

  // In-memory caches per session
  List<LocationItemDto>? _countries;
  final Map<int, List<LocationItemDto>> _provinces = {};
  final Map<int, List<LocationItemDto>> _cities = {};
  final Map<int, List<LocationItemDto>> _areas = {};

  Future<List<LocationItemDto>> loadCountries() async {
    if (_countries != null) return _countries!;
    final result = await _api.getCountries();
    return result.fold((_) => [], (list) {
      _countries = list;
      return list;
    });
  }

  Future<List<LocationItemDto>> loadProvinces(int countryId) async {
    if (_provinces.containsKey(countryId)) return _provinces[countryId]!;
    final result = await _api.getProvinces(countryId);
    return result.fold((_) => [], (list) {
      _provinces[countryId] = list;
      return list;
    });
  }

  Future<List<LocationItemDto>> loadCities(int provinceId) async {
    if (_cities.containsKey(provinceId)) return _cities[provinceId]!;
    final result = await _api.getCities(provinceId);
    return result.fold((_) => [], (list) {
      _cities[provinceId] = list;
      return list;
    });
  }

  Future<List<LocationItemDto>> loadAreas(int cityId) async {
    if (_areas.containsKey(cityId)) return _areas[cityId]!;
    final result = await _api.getAreas(cityId);
    return result.fold((_) => [], (list) {
      _areas[cityId] = list;
      return list;
    });
  }

  /// Loads all cities for Lebanon by traversing countries → provinces → cities.
  /// Results are cached so subsequent calls are free.
  Future<List<LocationItemDto>> loadLebanonCities() async {
    final countries = await loadCountries();
    final lebanon = countries.where(
      (c) => c.name.toLowerCase().contains('lebanon'),
    );
    if (lebanon.isEmpty) return [];

    final allCities = <LocationItemDto>[];
    for (final country in lebanon) {
      final provinces = await loadProvinces(country.id);
      for (final province in provinces) {
        final cities = await loadCities(province.id);
        allCities.addAll(cities);
      }
    }
    return allCities;
  }
}
