import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:latlong2/latlong.dart';

import '../../../backend_integration/dtos/address/address_dto.dart';
import '../../../backend_integration/dtos/address/address_request_dto.dart';
import '../../../backend_integration/dtos/location/location_item_dto.dart';
import '../../../enums/address_label_type.dart';
import '../../../services/address_service.dart';
import '../../../services/location_service.dart';
import '../../../services/places_service.dart';
import '../../../services/theme_service.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_text_styles.dart';
import '../../../utils/number_localization.dart';
import '../../reusable_components/aurora/aurora_primary_button.dart';
import '../../reusable_components/input_fields/aurora_input_field.dart';
import '../../reusable_components/toggles/aurora_switch.dart';
import '../cart/widgets/_cart_surface_theme.dart';
import '../splash/widgets/aurora_glow_blob.dart';
import 'widgets/aurora_select.dart';
import 'widgets/label_chooser.dart';
import 'widgets/map_picker_card.dart';

class AddressFormScreen extends StatefulWidget {
  const AddressFormScreen({super.key, this.initialAddress});

  final AddressDto? initialAddress;

  @override
  State<AddressFormScreen> createState() => _AddressFormScreenState();
}

class _AddressFormScreenState extends State<AddressFormScreen> {
  static const LatLng _defaultCenter = LatLng(33.8892, 35.5014);

  final MapController _mapController = MapController();
  final MapSearchController _mapSearchController = MapSearchController();
  final TextEditingController _customLabelController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _buildingController = TextEditingController();
  final TextEditingController _floorController = TextEditingController();
  final TextEditingController _aptController = TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();

  final LocationService _locationService = LocationService();
  final PlacesService _placesService = GetIt.instance<PlacesService>();

  AddressLabelType _labelType = AddressLabelType.home;
  LocationItemDto? _city;
  LocationItemDto? _area;
  List<LocationItemDto> _cities = [];
  List<LocationItemDto> _areas = [];
  bool _loadingCities = false;
  bool _loadingAreas = false;
  bool _isDefault = false;
  bool _includeLocation = false;
  bool _loadingLocation = false;
  bool _saving = false;
  bool _searchLoading = false;
  String? _locationError;

  LatLng _pinnedCenter = _defaultCenter;
  double? _latitude;
  double? _longitude;
  bool _mapTouched = false;

  @override
  void initState() {
    super.initState();
    _initForm();
  }

  Future<void> _initForm() async {
    // Pre-populate from existing address before cities load
    final a = widget.initialAddress;
    if (a != null) {
      final preset = AddressLabelType.fromStorageValue(a.label);
      _labelType = preset ?? AddressLabelType.other;
      if (preset == null) _customLabelController.text = a.label ?? '';
      _fullNameController.text = a.fullName;
      _streetController.text = a.street;
      _buildingController.text = a.building ?? '';
      _floorController.text = a.floor ?? '';
      _aptController.text = a.apt ?? '';
      _instructionsController.text = a.instructions ?? '';
      _city = a.city;
      _area = a.area;
      _isDefault = a.isDefault;
      if (a.latitude != null && a.longitude != null) {
        _latitude = a.latitude;
        _longitude = a.longitude;
        _pinnedCenter = LatLng(a.latitude!, a.longitude!);
        _includeLocation = true;
        _mapTouched = true;
      }
    }

    await _loadCities();

    // Load areas for the pre-selected city
    if (_city != null) {
      await _loadAreas(_city!.id);
    }
  }

  Future<void> _loadCities() async {
    setState(() => _loadingCities = true);
    final cities = await _placesService.loadLebanonCities();
    if (!mounted) return;
    setState(() {
      _cities = cities;
      _loadingCities = false;
      // Re-match city by id in case the list returned a fresh instance
      if (_city != null) {
        final match = cities.where((c) => c.id == _city!.id);
        if (match.isNotEmpty) _city = match.first;
      }
    });
  }

  Future<void> _loadAreas(int cityId) async {
    setState(() => _loadingAreas = true);
    final areas = await _placesService.loadAreas(cityId);
    if (!mounted) return;
    setState(() {
      _areas = areas;
      _loadingAreas = false;
      // Re-match area by id
      if (_area != null) {
        final match = areas.where((ar) => ar.id == _area!.id);
        _area = match.isNotEmpty ? match.first : null;
      }
    });
  }

  @override
  void dispose() {
    _customLabelController.dispose();
    _fullNameController.dispose();
    _streetController.dispose();
    _buildingController.dispose();
    _floorController.dispose();
    _aptController.dispose();
    _instructionsController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  String get _effectiveLabel {
    if (_labelType == AddressLabelType.other) {
      final custom = _customLabelController.text.trim();
      if (custom.isNotEmpty) return custom;
    }
    return _labelType.storageValue;
  }

  bool get _canSave =>
      _effectiveLabel.isNotEmpty &&
      _fullNameController.text.trim().isNotEmpty &&
      _city != null &&
      _streetController.text.trim().isNotEmpty;

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
            ? 'address_form_screen.location_services_off'.tr()
            : 'address_form_screen.location_permission_denied'.tr();
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loadingLocation = false;
        _locationError = 'address_form_screen.location_unavailable'.tr();
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
        _locationError = 'address_form_screen.no_place_found'.tr();
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
      if (!value) _locationError = null;
    });
    if (!value || _mapTouched) return;
    final queryParts = <String>[
      if (_area != null) _area!.name,
      if (_city != null) _city!.name,
      'Lebanon',
    ];
    if (queryParts.length <= 1) return;
    final result = await _locationService.searchAddress(queryParts.join(', '));
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
    if (!_canSave || _saving) return;
    setState(() => _saving = true);
    final service = GetIt.instance<AddressService>();
    final dto = AddressRequestDto(
      label: _effectiveLabel,
      fullName: _fullNameController.text.trim(),
      street: _streetController.text.trim(),
      building: _buildingController.text.trim().isEmpty
          ? null
          : _buildingController.text.trim(),
      floor: _floorController.text.trim().isEmpty
          ? null
          : _floorController.text.trim(),
      apt: _aptController.text.trim().isEmpty
          ? null
          : _aptController.text.trim(),
      instructions: _instructionsController.text.trim().isEmpty
          ? null
          : _instructionsController.text.trim(),
      cityId: _city!.id,
      areaId: _area?.id,
      latitude: (_includeLocation && _mapTouched) ? _latitude : null,
      longitude: (_includeLocation && _mapTouched) ? _longitude : null,
      isDefault: _isDefault,
    );

    if (widget.initialAddress != null) {
      await service.editAddress(widget.initialAddress!.id, dto);
    } else {
      await service.createAddress(dto);
    }

    if (!mounted) return;
    setState(() => _saving = false);
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService.instance,
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;
        final bgColor = isDark ? AppColors.auroraDeepBase : AppColors.auroraLightBase;
        final c = CartSurfaceColors.of(isDark: isDark);

        return Scaffold(
          backgroundColor: bgColor,
          resizeToAvoidBottomInset: true,
          body: Stack(
            children: [
              AuroraGlowBlob(
                top: -80, right: -80, size: 260,
                color: AppColors.auroraPurple,
                intensity: isDark ? 0.20 : 0.10,
              ),
              AuroraGlowBlob(
                bottom: -80, left: -80, size: 280,
                color: AppColors.auroraElectricBlue,
                intensity: isDark ? 0.18 : 0.08,
              ),
              SafeArea(
                child: Column(
                  children: [
                    _TopBar(
                      isDark: isDark,
                      isEdit: widget.initialAddress != null,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _sectionLabel('address_form_screen.label'.tr(), isDark),
                            LabelChooser(
                              selected: _labelType,
                              onChanged: (t) => setState(() => _labelType = t),
                            ),
                            if (_labelType == AddressLabelType.other) ...[
                              const SizedBox(height: 10),
                              AuroraInputField(
                                controller: _customLabelController,
                                hint: 'address_form_screen.custom_label'.tr(),
                                prefixIcon: FontAwesomeIcons.bookmark,
                                onChanged: (_) => setState(() {}),
                              ),
                            ],
                            const SizedBox(height: 18),
                            _sectionLabel('address_form_screen.full_name'.tr(), isDark),
                            AuroraInputField(
                              controller: _fullNameController,
                              hint: 'address_form_screen.recipient_full_name'.tr(),
                              prefixIcon: FontAwesomeIcons.user,
                              onChanged: (_) => setState(() {}),
                            ),
                            const SizedBox(height: 18),
                            _sectionLabel('address_form_screen.city'.tr(), isDark),
                            AuroraSelect(
                              value: _city?.name,
                              hint: _loadingCities
                                  ? 'address_form_screen.loading'.tr()
                                  : 'address_form_screen.pick_your_city'.tr(),
                              sheetTitle: 'address_form_screen.select_city'.tr(),
                              options: _cities.map((c) => c.name).toList(),
                              prefixIcon: FontAwesomeIcons.city,
                              enabled: !_loadingCities && _cities.isNotEmpty,
                              onChanged: (name) async {
                                final match = _cities.where((c) => c.name == name);
                                if (match.isEmpty) return;
                                setState(() {
                                  _city = match.first;
                                  _area = null;
                                  _areas = [];
                                });
                                await _loadAreas(_city!.id);
                              },
                            ),
                            const SizedBox(height: 14),
                            _sectionLabel('address_form_screen.area'.tr(), isDark),
                            AuroraSelect(
                              value: _area?.name,
                              hint: _city == null
                                  ? 'address_form_screen.pick_city_first'.tr()
                                  : _loadingAreas
                                      ? 'address_form_screen.loading'.tr()
                                      : 'address_form_screen.pick_your_area'.tr(),
                              sheetTitle: 'address_form_screen.select_area'.tr(),
                              options: _areas.map((a) => a.name).toList(),
                              prefixIcon: FontAwesomeIcons.map,
                              enabled: _city != null && !_loadingAreas && _areas.isNotEmpty,
                              onChanged: (name) {
                                final match = _areas.where((a) => a.name == name);
                                if (match.isEmpty) return;
                                setState(() => _area = match.first);
                              },
                            ),
                            const SizedBox(height: 14),
                            _sectionLabel('address_form_screen.street'.tr(), isDark),
                            AuroraInputField(
                              controller: _streetController,
                              hint: 'address_form_screen.street_name'.tr(),
                              prefixIcon: FontAwesomeIcons.road,
                              onChanged: (_) => setState(() {}),
                            ),
                            const SizedBox(height: 14),
                            _sectionLabel('address_form_screen.building'.tr(), isDark),
                            AuroraInputField(
                              controller: _buildingController,
                              hint: 'address_form_screen.building_hint'.tr(),
                              prefixIcon: FontAwesomeIcons.building,
                              onChanged: (_) => setState(() {}),
                            ),
                            const SizedBox(height: 14),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _sectionLabel('address_form_screen.floor'.tr(), isDark),
                                      AuroraInputField(
                                        controller: _floorController,
                                        hint: 'address_form_screen.floor_hint'.tr(),
                                        keyboardType: TextInputType.number,
                                        onChanged: (_) => setState(() {}),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _sectionLabel('address_form_screen.apartment'.tr(), isDark),
                                      AuroraInputField(
                                        controller: _aptController,
                                        hint: 'address_form_screen.apartment_hint'.tr(),
                                        onChanged: (_) => setState(() {}),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            _sectionLabel('address_form_screen.directions'.tr(), isDark),
                            AuroraInputField(
                              controller: _instructionsController,
                              hint: 'address_form_screen.directions_hint'.tr(),
                              prefixIcon: FontAwesomeIcons.noteSticky,
                              maxLines: 3,
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.newline,
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
                                  'address_form_screen.map_hint'.tr(),
                                  style: AppTextStyles.caption.copyWith(
                                    fontSize: 11,
                                    color: c.textMute2,
                                  ),
                                ),
                            ],
                            const SizedBox(height: 18),
                            _DefaultToggle(
                              value: _isDefault,
                              onChanged: (v) => setState(() => _isDefault = v),
                              surfaceColors: c,
                              isDark: isDark,
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 16),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.auroraDeepBase : AppColors.white,
                        border: Border(
                          top: BorderSide(
                            color: isDark
                                ? AppColors.white.withValues(alpha: 0.06)
                                : AppColors.auroraPurple.withValues(alpha: 0.12),
                            width: 1,
                          ),
                        ),
                      ),
                      child: Opacity(
                        opacity: _canSave ? 1.0 : 0.5,
                        child: AbsorbPointer(
                          absorbing: !_canSave,
                          child: AuroraPrimaryButton(
                            text: 'address_form_screen.save_address'.tr(),
                            height: 52,
                            isLoading: _saving,
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
            FaIcon(FontAwesomeIcons.locationDot, size: 15, color: AppColors.auroraElectricBlue),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'address_form_screen.pin_on_map'.tr(),
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: surfaceColors.text,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'address_form_screen.pin_on_map_subtitle'.tr(),
                    style: AppTextStyles.bodySmall.copyWith(
                      fontSize: 11,
                      color: surfaceColors.textMute,
                    ),
                  ),
                ],
              ),
            ),
            AuroraSwitch(value: value, onChanged: onChanged, isDark: isDark),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final bool isDark;
  final bool isEdit;

  const _TopBar({required this.isDark, required this.isEdit});

  @override
  Widget build(BuildContext context) {
    final iconColor = isDark ? AppColors.white : AppColors.auroraPurple;
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(4, 4, 16, 8),
      child: Row(
        children: [
          IconButton(
            icon: FaIcon(
              isRtl ? FontAwesomeIcons.arrowRight : FontAwesomeIcons.arrowLeft,
              size: 20,
              color: iconColor,
            ),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              isEdit
                  ? 'address_form_screen.edit_address'.tr()
                  : 'address_form_screen.add_new_address'.tr(),
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
        FaIcon(FontAwesomeIcons.locationCrosshairs, size: 11, color: surfaceColors.textMute2),
        const SizedBox(width: 6),
        Text(
          'address_form_screen.pinned_coords'.tr(namedArgs: {
            'lat': localizedNumber(latitude, decimals: 5),
            'lng': localizedNumber(longitude, decimals: 5),
          }),
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
                    'address_form_screen.set_as_default'.tr(),
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: surfaceColors.text,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'address_form_screen.default_subtitle'.tr(),
                    style: AppTextStyles.bodySmall.copyWith(
                      fontSize: 11,
                      color: surfaceColors.textMute,
                    ),
                  ),
                ],
              ),
            ),
            AuroraSwitch(value: value, onChanged: onChanged, isDark: isDark),
          ],
        ),
      ),
    );
  }
}
