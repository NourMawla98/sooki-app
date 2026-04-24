import 'dart:io';

import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';

class LocationPermissionDeniedException implements Exception {
  final String reason;
  const LocationPermissionDeniedException(this.reason);
  @override
  String toString() => 'LocationPermissionDeniedException: $reason';
}

/// Wrapper over `geolocator` for device GPS, plus OSM Nominatim HTTP
/// for forward/reverse geocoding. Nominatim is used instead of the native
/// `geocoding` package so we don't depend on Google Play Services.
class LocationService {
  LocationService({Dio? client})
      : _client = client ??
            Dio(BaseOptions(
              connectTimeout: const Duration(seconds: 8),
              receiveTimeout: const Duration(seconds: 8),
              headers: const {
                // Nominatim requires a real User-Agent identifying the app.
                // See https://operations.osmfoundation.org/policies/nominatim/
                'User-Agent': 'SookiApp/1.0 (contact@sooki.app)',
                'Accept': 'application/json',
              },
            ));

  final Dio _client;
  static const String _nominatimBase = 'https://nominatim.openstreetmap.org';

  bool get _supportedPlatform => Platform.isAndroid || Platform.isIOS;

  /// Returns the device's current (lat, lng). Prompts for runtime permission
  /// if not granted. Throws [LocationPermissionDeniedException] when denied.
  Future<({double latitude, double longitude})> getCurrentLatLng() async {
    if (!_supportedPlatform) {
      throw const LocationPermissionDeniedException('Unsupported platform');
    }

    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw const LocationPermissionDeniedException(
        'Location services are disabled.',
      );
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw const LocationPermissionDeniedException(
          'Location permission denied.',
        );
      }
    }
    if (permission == LocationPermission.deniedForever) {
      throw const LocationPermissionDeniedException(
        'Location permission permanently denied.',
      );
    }

    final pos = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );
    return (latitude: pos.latitude, longitude: pos.longitude);
  }

  /// Forward geocode via OSM Nominatim. Returns the top result or `null`.
  Future<({double latitude, double longitude})?> searchAddress(
    String query,
  ) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return null;
    try {
      final res = await _client.get<dynamic>(
        '$_nominatimBase/search',
        queryParameters: {
          'q': trimmed,
          'format': 'json',
          'limit': 1,
          'addressdetails': 0,
        },
      );
      final data = res.data;
      if (data is! List || data.isEmpty) return null;
      final first = data.first as Map<String, dynamic>;
      final lat = double.tryParse(first['lat']?.toString() ?? '');
      final lon = double.tryParse(first['lon']?.toString() ?? '');
      if (lat == null || lon == null) return null;
      return (latitude: lat, longitude: lon);
    } catch (_) {
      return null;
    }
  }

  /// Best-effort reverse geocode via Nominatim. Returns `null` on failure.
  Future<String?> reverseGeocode(double latitude, double longitude) async {
    try {
      final res = await _client.get<dynamic>(
        '$_nominatimBase/reverse',
        queryParameters: {
          'lat': latitude,
          'lon': longitude,
          'format': 'json',
          'zoom': 18,
          'addressdetails': 0,
        },
      );
      final data = res.data;
      if (data is! Map) return null;
      final display = data['display_name']?.toString();
      if (display == null || display.isEmpty) return null;
      return display;
    } catch (_) {
      return null;
    }
  }
}
