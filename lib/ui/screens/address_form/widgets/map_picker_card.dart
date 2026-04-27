import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong2/latlong.dart';

import '../../../../services/theme_service.dart';
import '../../../../themes/app_colors.dart';
import '../../../../themes/app_text_styles.dart';
import '../../cart/widgets/_cart_surface_theme.dart';

class MapSearchController {
  TextEditingController? _controller;
  void _attach(TextEditingController controller) {
    _controller = controller;
  }

  void setQuery(String text) {
    _controller?.text = text;
  }
}

/// OSM-backed map picker. Fixed center pin overlay; the map moves under it.
/// Emits [onCenterChanged] when the user stops panning.
class MapPickerCard extends StatefulWidget {
  final LatLng initialCenter;
  final ValueChanged<LatLng> onCenterChanged;
  final VoidCallback onUseMyLocation;
  final ValueChanged<String>? onSearchSubmitted;
  final bool locationLoading;
  final bool searchLoading;
  final String? locationError;
  final CartSurfaceColors surfaceColors;
  final MapController mapController;
  final MapSearchController? searchController;

  const MapPickerCard({
    super.key,
    required this.initialCenter,
    required this.onCenterChanged,
    required this.onUseMyLocation,
    required this.locationLoading,
    required this.locationError,
    required this.surfaceColors,
    required this.mapController,
    this.onSearchSubmitted,
    this.searchLoading = false,
    this.searchController,
  });

  @override
  State<MapPickerCard> createState() => _MapPickerCardState();
}

class _MapPickerCardState extends State<MapPickerCard> {
  late LatLng _currentCenter;
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _currentCenter = widget.initialCenter;
    _searchController = TextEditingController();
    widget.searchController?._attach(_searchController);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handlePositionChanged(MapCamera position, bool hasGesture) {
    _currentCenter = position.center;
    if (!hasGesture) return;
    widget.onCenterChanged(_currentCenter);
  }

  void _zoomIn() {
    final z = widget.mapController.camera.zoom;
    widget.mapController.move(
      widget.mapController.camera.center,
      (z + 1).clamp(3, 19),
    );
  }

  void _zoomOut() {
    final z = widget.mapController.camera.zoom;
    widget.mapController.move(
      widget.mapController.camera.center,
      (z - 1).clamp(3, 19),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.surfaceColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.onSearchSubmitted != null) ...[
          _SearchField(
            controller: _searchController,
            loading: widget.searchLoading,
            onSubmitted: (q) => widget.onSearchSubmitted!(q),
          ),
          const SizedBox(height: 10),
        ],
        Container(
          height: 240,
          decoration: BoxDecoration(
            color: c.chipFill,
            border: Border.all(color: c.glassBorder, width: 1),
            borderRadius: BorderRadius.circular(16),
          ),
          clipBehavior: Clip.hardEdge,
          child: Stack(
            children: [
              FlutterMap(
                mapController: widget.mapController,
                options: MapOptions(
                  initialCenter: widget.initialCenter,
                  initialZoom: 15,
                  minZoom: 3,
                  maxZoom: 19,
                  onPositionChanged: _handlePositionChanged,
                  interactionOptions: const InteractionOptions(
                    flags: InteractiveFlag.pinchZoom |
                        InteractiveFlag.drag |
                        InteractiveFlag.doubleTapZoom |
                        InteractiveFlag.flingAnimation,
                  ),
                ),
                children: [
                  TileLayer(
                    // CartoDB tiles — fast Fastly-backed CDN, aurora-friendly
                    // palettes, switches with theme. Attribution must stay
                    // visible per the Nominatim/OSM + Carto usage policies.
                    urlTemplate: ThemeService.instance.isDarkMode
                        ? 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png'
                        : 'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}.png',
                    subdomains: const ['a', 'b', 'c', 'd'],
                    userAgentPackageName: 'com.sooki.app',
                    retinaMode: false,
                  ),
                  const _MapAttribution(),
                ],
              ),
              // Fixed centered pin overlay
              IgnorePointer(
                child: Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FaIcon(
                        FontAwesomeIcons.locationDot,
                        size: 32,
                        color: AppColors.auroraPink,
                        shadows: [
                          Shadow(
                            color: AppColors.auroraPink.withValues(alpha: 0.4),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
              // Zoom controls (top-right)
              Positioned(
                top: 10,
                right: 10,
                child: Column(
                  children: [
                    _ZoomButton(
                      icon: FontAwesomeIcons.plus,
                      onTap: _zoomIn,
                      surfaceColors: c,
                    ),
                    const SizedBox(height: 6),
                    _ZoomButton(
                      icon: FontAwesomeIcons.minus,
                      onTap: _zoomOut,
                      surfaceColors: c,
                    ),
                  ],
                ),
              ),
              // Use-my-location FAB (bottom-right)
              Positioned(
                right: 10,
                bottom: 10,
                child: _UseMyLocationFab(
                  loading: widget.locationLoading,
                  onTap: widget.onUseMyLocation,
                ),
              ),
            ],
          ),
        ),
        if (widget.locationError != null) ...[
          const SizedBox(height: 8),
          Text(
            widget.locationError!,
            style: AppTextStyles.caption.copyWith(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.auroraPink,
            ),
          ),
        ],
      ],
    );
  }
}

class _ZoomButton extends StatelessWidget {
  final FaIconData icon;
  final VoidCallback onTap;
  final CartSurfaceColors surfaceColors;

  const _ZoomButton({
    required this.icon,
    required this.onTap,
    required this.surfaceColors,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: surfaceColors.sheet,
          border: Border.all(color: surfaceColors.chipBorder, width: 1),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.08),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: FaIcon(icon, size: 11, color: surfaceColors.text),
      ),
    );
  }
}

class _MapAttribution extends StatelessWidget {
  const _MapAttribution();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        margin: const EdgeInsets.all(6),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: AppColors.black.withValues(alpha: 0.45),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          '© OSM · CARTO',
          style: AppTextStyles.caption.copyWith(
            fontSize: 9,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
            color: AppColors.white.withValues(alpha: 0.85),
          ),
        ),
      ),
    );
  }
}

class _SearchField extends StatefulWidget {
  final TextEditingController controller;
  final bool loading;
  final ValueChanged<String> onSubmitted;

  const _SearchField({
    required this.controller,
    required this.loading,
    required this.onSubmitted,
  });

  @override
  State<_SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<_SearchField> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocus);
    widget.controller.addListener(_onText);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocus);
    widget.controller.removeListener(_onText);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocus() {
    if (mounted) setState(() => _isFocused = _focusNode.hasFocus);
  }

  void _onText() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService.instance,
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;
        final iconColor = isDark ? AppColors.white : AppColors.auroraPurple;
        final hintColor =
            isDark ? AppColors.mutedOnDark : AppColors.mutedOnLight;
        final textColor =
            isDark ? AppColors.white : AppColors.auroraDeepBase;

        final textField = TextField(
          controller: widget.controller,
          focusNode: _focusNode,
          textAlignVertical: TextAlignVertical.center,
          onSubmitted: widget.onSubmitted,
          cursorColor: AppColors.auroraElectricBlue,
          textInputAction: TextInputAction.search,
          style: AppTextStyles.dsBody.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: textColor,
            height: 1.0,
          ),
          decoration: InputDecoration(
            hintText: 'Search a place, street, or area',
            hintStyle: AppTextStyles.dsBody.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: hintColor,
              height: 1.0,
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 14, right: 10),
              child: FaIcon(
                FontAwesomeIcons.magnifyingGlass,
                size: 16,
                color: iconColor,
              ),
            ),
            prefixIconConstraints:
                const BoxConstraints(minWidth: 0, minHeight: 0),
            suffixIcon: widget.loading
                ? Padding(
                    padding: const EdgeInsets.only(right: 14),
                    child: SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(
                            AppColors.auroraElectricBlue),
                      ),
                    ),
                  )
                : widget.controller.text.isNotEmpty
                    ? GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => widget.controller.clear(),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 14),
                          child: FaIcon(
                            FontAwesomeIcons.xmark,
                            size: 12,
                            color: hintColor,
                          ),
                        ),
                      )
                    : null,
            suffixIconConstraints:
                const BoxConstraints(minWidth: 0, minHeight: 0),
            filled: false,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
            isDense: true,
          ),
        );

        if (_isFocused) {
          final innerFill =
              isDark ? AppColors.auroraDeepBase : AppColors.white;
          return Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: AppColors.auroraGradient,
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: AppColors.auroraPurple
                      .withValues(alpha: isDark ? 0.55 : 0.30),
                  blurRadius: 22,
                ),
              ],
            ),
            padding: const EdgeInsets.all(2),
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: innerFill,
                borderRadius: BorderRadius.circular(12),
              ),
              child: textField,
            ),
          );
        }

        final fill = isDark
            ? AppColors.white.withValues(alpha: 0.04)
            : AppColors.white;
        final border = isDark
            ? AppColors.white.withValues(alpha: 0.12)
            : AppColors.auroraPurple.withValues(alpha: 0.28);
        return Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: fill,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: border, width: 1.5),
          ),
          child: textField,
        );
      },
    );
  }
}

class _UseMyLocationFab extends StatelessWidget {
  final bool loading;
  final VoidCallback onTap;

  const _UseMyLocationFab({
    required this.loading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: loading ? null : onTap,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: loading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor:
                      AlwaysStoppedAnimation(AppColors.auroraElectricBlue),
                ),
              )
            : const FaIcon(
                FontAwesomeIcons.locationCrosshairs,
                size: 24,
                color: AppColors.auroraElectricBlue,
              ),
      ),
    );
  }
}
