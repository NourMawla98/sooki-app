import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:latlong2/latlong.dart';

import '../../../models/delivery_address.dart';
import '../../../services/address_service.dart';
import '../../../services/location_service.dart';
import '../../../services/theme_service.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_text_styles.dart';
import '../../reusable_components/aurora/aurora_primary_button.dart';
import '../../reusable_components/input_fields/aurora_input_field.dart';
import '../../reusable_components/input_fields/aurora_phone_field.dart';
import '../../reusable_components/toggles/aurora_switch.dart';
import '../cart/widgets/_cart_surface_theme.dart';
import '../splash/widgets/aurora_glow_blob.dart';
import 'widgets/_lebanon_areas.dart';
import 'widgets/aurora_select.dart';
import 'widgets/label_chooser.dart';
import 'widgets/map_picker_card.dart';

class AddressFormScreen extends StatefulWidget {
  const AddressFormScreen({super.key});

  @override
  State<AddressFormScreen> createState() => _AddressFormScreenState();
}

class _AddressFormScreenState extends State<AddressFormScreen> {
  static const LatLng _defaultCenter = LatLng(33.8892, 35.5014); // Beirut

  final MapController _mapController = MapController();
  final MapSearchController _mapSearchController = MapSearchController();
  final TextEditingController _customLabelController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _buildingController = TextEditingController();
  final TextEditingController _floorController = TextEditingController();
  final TextEditingController _aptController = TextEditingController();
  final TextEditingController _instructionsController =
      TextEditingController();

  final LocationService _locationService = LocationService();

  AddressLabelType _labelType = AddressLabelType.home;
  String? _city;
  String? _area;
  bool _isDefault = false;
  bool _includeLocation = false;
  bool _loadingLocation = false;
  bool _searchLoading = false;
  String? _locationError;

  LatLng _pinnedCenter = _defaultCenter;
  double? _latitude;
  double? _longitude;
  bool _mapTouched = false;

  @override
  void dispose() {
    _customLabelController.dispose();
    _phoneController.dispose();
    _streetController.dispose();
    _buildingController.dispose();
    _floorController.dispose();
    _aptController.dispose();
    _instructionsController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  String get _effectiveLabel {
    switch (_labelType) {
      case AddressLabelType.home:
        return 'Home';
      case AddressLabelType.office:
        return 'Office';
      case AddressLabelType.other:
        return _customLabelController.text.trim().isEmpty
            ? 'Other'
            : _customLabelController.text.trim();
    }
  }

  bool get _canSave =>
      _effectiveLabel.isNotEmpty &&
      _phoneController.text.trim().isNotEmpty &&
      (_city ?? '').isNotEmpty &&
      (_area ?? '').isNotEmpty &&
      _buildingController.text.trim().isNotEmpty;

  void _onCenterChanged(LatLng center) {
    setState(() {
      _pinnedCenter = center;
      _latitude = center.latitude;
      _longitude = center.longitude;
      _mapTouched = true;
    });
  }

  Future<void> _useMyLocation() async {
    setState(() {
      _loadingLocation = true;
      _locationError = null;
    });
    try {
      final result = await _locationService.getCurrentLatLng();
      if (!mounted) return;
      final latLng = LatLng(result.latitude, result.longitude);
      _mapController.move(latLng, 16);
      setState(() {
        _pinnedCenter = latLng;
        _latitude = latLng.latitude;
        _longitude = latLng.longitude;
        _loadingLocation = false;
        _mapTouched = true;
      });
    } on LocationPermissionDeniedException catch (e) {
      if (!mounted) return;
      setState(() {
        _loadingLocation = false;
        _locationError = e.reason.contains('disabled')
            ? 'Turn on location services to use this.'
            : 'Location permission denied. Drag the map to set the pin.';
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loadingLocation = false;
        _locationError = 'Could not get your location. Drag the map instead.';
      });
    }
  }

  Future<void> _onSearchSubmitted(String query) async {
    if (query.trim().isEmpty) return;
    setState(() {
      _searchLoading = true;
      _locationError = null;
    });
    final result = await _locationService.searchAddress(query);
    if (!mounted) return;
    if (result == null) {
      setState(() {
        _searchLoading = false;
        _locationError = 'No place found. Try a different search.';
      });
      return;
    }
    final latLng = LatLng(result.latitude, result.longitude);
    _mapController.move(latLng, 16);
    setState(() {
      _pinnedCenter = latLng;
      _latitude = latLng.latitude;
      _longitude = latLng.longitude;
      _searchLoading = false;
      _mapTouched = true;
    });
  }

  Future<void> _onIncludeLocationToggled(bool value) async {
    setState(() {
      _includeLocation = value;
      if (!value) {
        _locationError = null;
      }
    });
    if (!value) return;
    // Toggled on — try to center the map on the selected area so the user
    // starts near where they live, not a generic default.
    if (_mapTouched) return;
    final queryParts = <String>[
      if ((_area ?? '').isNotEmpty && _area != 'Other') _area!,
      if ((_city ?? '').isNotEmpty && _city != 'Other') _city!,
      'Lebanon',
    ];
    if (queryParts.length <= 1) return;
    final result =
        await _locationService.searchAddress(queryParts.join(', '));
    if (!mounted || result == null) return;
    final latLng = LatLng(result.latitude, result.longitude);
    _mapController.move(latLng, 14);
    setState(() {
      _pinnedCenter = latLng;
      _latitude = latLng.latitude;
      _longitude = latLng.longitude;
    });
  }

  Future<void> _save() async {
    if (!_canSave) return;
    final service = GetIt.instance<AddressService>();
    final id = 'addr-${DateTime.now().millisecondsSinceEpoch}';
    final line = DeliveryAddress.composeLine(
      building: _buildingController.text,
      street: _streetController.text,
      area: _area,
      city: _city,
    );
    final addr = DeliveryAddress(
      id: id,
      label: _effectiveLabel,
      phone: _phoneController.text.trim(),
      line: line,
      city: _city,
      area: _area,
      street: _streetController.text.trim().isEmpty
          ? null
          : _streetController.text.trim(),
      building: _buildingController.text.trim(),
      floor: _floorController.text.trim().isEmpty
          ? null
          : _floorController.text.trim(),
      apt: _aptController.text.trim().isEmpty
          ? null
          : _aptController.text.trim(),
      instructions: _instructionsController.text.trim().isEmpty
          ? null
          : _instructionsController.text.trim(),
      // Pin is only saved if the user opted in AND touched / placed it.
      latitude: (_includeLocation && _mapTouched) ? _latitude : null,
      longitude: (_includeLocation && _mapTouched) ? _longitude : null,
      isDefault: _isDefault,
    );
    await service.add(addr);
    if (!mounted) return;
    Navigator.of(context).pop(id);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService.instance,
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;
        final bgColor =
            isDark ? AppColors.auroraDeepBase : AppColors.auroraLightBase;
        final c = CartSurfaceColors.of(isDark: isDark);

        return Scaffold(
          backgroundColor: bgColor,
          resizeToAvoidBottomInset: true,
          body: Stack(
            children: [
              AuroraGlowBlob(
                top: -80,
                right: -80,
                size: 260,
                color: AppColors.auroraPurple,
                intensity: isDark ? 0.20 : 0.10,
              ),
              AuroraGlowBlob(
                bottom: -80,
                left: -80,
                size: 280,
                color: AppColors.auroraElectricBlue,
                intensity: isDark ? 0.18 : 0.08,
              ),
              SafeArea(
                child: Column(
                  children: [
                    _TopBar(isDark: isDark),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _sectionLabel('Label', isDark),
                            LabelChooser(
                              selected: _labelType,
                              onChanged: (t) =>
                                  setState(() => _labelType = t),
                            ),
                            if (_labelType == AddressLabelType.other) ...[
                              const SizedBox(height: 10),
                              AuroraInputField(
                                controller: _customLabelController,
                                hint: 'Custom label',
                                prefixIcon: FontAwesomeIcons.bookmark,
                                onChanged: (_) => setState(() {}),
                              ),
                            ],
                            const SizedBox(height: 18),
                            _sectionLabel('Phone', isDark),
                            AuroraPhoneField(
                              controller: _phoneController,
                              onChanged: (_) => setState(() {}),
                            ),
                            const SizedBox(height: 18),
                            _sectionLabel('City', isDark),
                            AuroraSelect(
                              value: _city,
                              hint: 'Pick your city',
                              sheetTitle: 'Select city',
                              options: lebanonCities,
                              prefixIcon: FontAwesomeIcons.city,
                              onChanged: (v) => setState(() {
                                _city = v;
                                _area = null;
                              }),
                            ),
                            const SizedBox(height: 14),
                            _sectionLabel('Area', isDark),
                            AuroraSelect(
                              value: _area,
                              hint: _city == null
                                  ? 'Pick a city first'
                                  : 'Pick your area',
                              sheetTitle: 'Select area',
                              options: areasFor(_city),
                              prefixIcon: FontAwesomeIcons.map,
                              enabled: _city != null,
                              onChanged: (v) => setState(() => _area = v),
                            ),
                            const SizedBox(height: 14),
                            _sectionLabel('Street', isDark),
                            AuroraInputField(
                              controller: _streetController,
                              hint: 'Street name (optional)',
                              prefixIcon: FontAwesomeIcons.road,
                              onChanged: (_) => setState(() {}),
                            ),
                            const SizedBox(height: 14),
                            _sectionLabel('Building', isDark),
                            AuroraInputField(
                              controller: _buildingController,
                              hint: 'Building name or number',
                              prefixIcon: FontAwesomeIcons.building,
                              onChanged: (_) => setState(() {}),
                            ),
                            const SizedBox(height: 14),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _sectionLabel('Floor', isDark),
                                      AuroraInputField(
                                        controller: _floorController,
                                        hint: 'e.g. 3',
                                        keyboardType: TextInputType.number,
                                        onChanged: (_) => setState(() {}),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _sectionLabel('Apartment', isDark),
                                      AuroraInputField(
                                        controller: _aptController,
                                        hint: 'e.g. 3B',
                                        onChanged: (_) => setState(() {}),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            _sectionLabel('Directions (optional)', isDark),
                            AuroraInputField(
                              controller: _instructionsController,
                              hint: 'Landmark, gate code, delivery notes…',
                              prefixIcon: FontAwesomeIcons.noteSticky,
                              maxLines: 3,
                              onChanged: (_) => setState(() {}),
                            ),
                            const SizedBox(height: 20),
                            _IncludeLocationToggle(
                              value: _includeLocation,
                              onChanged: _onIncludeLocationToggled,
                              surfaceColors: c,
                              isDark: isDark,
                            ),
                            if (_includeLocation) ...[
                              const SizedBox(height: 12),
                              MapPickerCard(
                                initialCenter: _pinnedCenter,
                                onCenterChanged: _onCenterChanged,
                                onUseMyLocation: _useMyLocation,
                                onSearchSubmitted: _onSearchSubmitted,
                                locationLoading: _loadingLocation,
                                searchLoading: _searchLoading,
                                locationError: _locationError,
                                surfaceColors: c,
                                mapController: _mapController,
                                searchController: _mapSearchController,
                              ),
                              const SizedBox(height: 8),
                              if (_mapTouched)
                                _LatLngReadout(
                                  latitude: _pinnedCenter.latitude,
                                  longitude: _pinnedCenter.longitude,
                                  surfaceColors: c,
                                )
                              else
                                Text(
                                  'Drag the pin, search a place, or tap the '
                                  'crosshair to use your current location.',
                                  style: AppTextStyles.caption.copyWith(
                                    fontSize: 11,
                                    color: c.textMute2,
                                  ),
                                ),
                            ],
                            const SizedBox(height: 18),
                            _DefaultToggle(
                              value: _isDefault,
                              onChanged: (v) =>
                                  setState(() => _isDefault = v),
                              surfaceColors: c,
                              isDark: isDark,
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                    // Sticky save CTA
                    Container(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.auroraDeepBase
                            : AppColors.white,
                        border: Border(
                          top: BorderSide(
                            color: isDark
                                ? AppColors.white.withValues(alpha: 0.06)
                                : AppColors.auroraPurple
                                    .withValues(alpha: 0.12),
                            width: 1,
                          ),
                        ),
                      ),
                      child: Opacity(
                        opacity: _canSave ? 1.0 : 0.5,
                        child: AbsorbPointer(
                          absorbing: !_canSave,
                          child: AuroraPrimaryButton(
                            text: 'SAVE ADDRESS',
                            height: 52,
                            onPressed: _save,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _sectionLabel(String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: AppTextStyles.dsFieldLabel.copyWith(
          color: isDark ? AppColors.white : AppColors.auroraPurple,
        ),
      ),
    );
  }

}

class _IncludeLocationToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final CartSurfaceColors surfaceColors;
  final bool isDark;

  const _IncludeLocationToggle({
    required this.value,
    required this.onChanged,
    required this.surfaceColors,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onChanged(!value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: surfaceColors.chipFill,
          border: Border.all(
            color: value
                ? AppColors.auroraElectricBlue.withValues(alpha: 0.40)
                : surfaceColors.chipBorder,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            FaIcon(
              FontAwesomeIcons.locationDot,
              size: 15,
              color: AppColors.auroraElectricBlue,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Pin on map',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: surfaceColors.text,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Help us find you faster. Off by default.',
                    style: AppTextStyles.bodySmall.copyWith(
                      fontSize: 11,
                      color: surfaceColors.textMute,
                    ),
                  ),
                ],
              ),
            ),
            AuroraSwitch(
              value: value,
              onChanged: onChanged,
              isDark: isDark,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Top bar ────────────────────────────────────────────────────────────
class _TopBar extends StatelessWidget {
  final bool isDark;

  const _TopBar({required this.isDark});

  @override
  Widget build(BuildContext context) {
    // Match AppHeader's glyph color convention: auroraPurple in light,
    // white in dark. Same aurora presence as every other header chrome.
    final iconColor = isDark ? AppColors.white : AppColors.auroraPurple;
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 16, 8),
      child: Row(
        children: [
          IconButton(
            icon: FaIcon(
              FontAwesomeIcons.arrowLeft,
              size: 20,
              color: iconColor,
            ),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              'Add a new address',
              style: AppTextStyles.heading3.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: iconColor,
                letterSpacing: -0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LatLngReadout extends StatelessWidget {
  final double latitude;
  final double longitude;
  final CartSurfaceColors surfaceColors;

  const _LatLngReadout({
    required this.latitude,
    required this.longitude,
    required this.surfaceColors,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        FaIcon(
          FontAwesomeIcons.locationCrosshairs,
          size: 11,
          color: surfaceColors.textMute2,
        ),
        const SizedBox(width: 6),
        Text(
          'Pinned: ${latitude.toStringAsFixed(5)}, ${longitude.toStringAsFixed(5)}',
          style: AppTextStyles.caption.copyWith(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: surfaceColors.textMute,
            letterSpacing: 0.1,
          ),
        ),
      ],
    );
  }
}

class _DefaultToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final CartSurfaceColors surfaceColors;
  final bool isDark;

  const _DefaultToggle({
    required this.value,
    required this.onChanged,
    required this.surfaceColors,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onChanged(!value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: surfaceColors.chipFill,
          border: Border.all(
            color: value
                ? AppColors.auroraPurple.withValues(alpha: 0.40)
                : surfaceColors.chipBorder,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Set as default',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: surfaceColors.text,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Use this address for every order',
                    style: AppTextStyles.bodySmall.copyWith(
                      fontSize: 11,
                      color: surfaceColors.textMute,
                    ),
                  ),
                ],
              ),
            ),
            AuroraSwitch(
              value: value,
              onChanged: onChanged,
              isDark: isDark,
            ),
          ],
        ),
      ),
    );
  }
}

