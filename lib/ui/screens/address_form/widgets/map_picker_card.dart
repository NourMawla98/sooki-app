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
            surfaceColors: c,
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
                  surfaceColors: c,
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

class _SearchField extends StatelessWidget {
  final TextEditingController controller;
  final CartSurfaceColors surfaceColors;
  final bool loading;
  final ValueChanged<String> onSubmitted;

  const _SearchField({
    required this.controller,
    required this.surfaceColors,
    required this.loading,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final c = surfaceColors;
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: c.chipFill,
        border: Border.all(color: c.chipBorder, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          FaIcon(
            FontAwesomeIcons.magnifyingGlass,
            size: 13,
            color: c.textMute,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              textAlignVertical: TextAlignVertical.center,
              onSubmitted: onSubmitted,
              cursorColor: AppColors.auroraElectricBlue,
              textInputAction: TextInputAction.search,
              style: AppTextStyles.bodyMedium.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: c.text,
              ),
              decoration: InputDecoration(
                hintText: 'Search a place, street, or area',
                hintStyle: AppTextStyles.bodyMedium.copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: c.textMute2,
                ),
                isCollapsed: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                filled: false,
                fillColor: Colors.transparent,
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
              ),
            ),
          ),
          if (loading)
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor:
                    AlwaysStoppedAnimation(AppColors.auroraElectricBlue),
              ),
            )
          else if (controller.text.isNotEmpty)
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                controller.clear();
              },
              child: FaIcon(
                FontAwesomeIcons.xmark,
                size: 12,
                color: c.textMute2,
              ),
            ),
        ],
      ),
    );
  }
}

class _UseMyLocationFab extends StatelessWidget {
  final bool loading;
  final VoidCallback onTap;
  final CartSurfaceColors surfaceColors;

  const _UseMyLocationFab({
    required this.loading,
    required this.onTap,
    required this.surfaceColors,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: loading ? null : onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: AppColors.auroraCartButtonGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.auroraPurple.withValues(alpha: 0.40),
              blurRadius: 14,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: loading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(AppColors.white),
                ),
              )
            : FaIcon(
                FontAwesomeIcons.locationCrosshairs,
                size: 16,
                color: AppColors.white,
              ),
      ),
    );
  }
}
