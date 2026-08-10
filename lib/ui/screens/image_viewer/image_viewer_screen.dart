import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../themes/themes.dart';
import '../../../utils/number_localization.dart';

class ImageViewerArgs {
  const ImageViewerArgs({
    required this.imageUrls,
    this.initialIndex = 0,
    this.heroTag,
  });

  final List<String> imageUrls;
  final int initialIndex;
  final String? heroTag;
}

class ImageViewerScreen extends StatefulWidget {
  const ImageViewerScreen({super.key, required this.args});

  final ImageViewerArgs args;

  @override
  State<ImageViewerScreen> createState() => _ImageViewerScreenState();
}

class _ImageViewerScreenState extends State<ImageViewerScreen>
    with SingleTickerProviderStateMixin {
  static const double _minScale = 1.0;
  static const double _maxScale = 4.0;
  static const double _doubleTapScale = 2.0;
  static const Duration _chromeFadeAfter = Duration(seconds: 2);
  static const Duration _zoomAnimDuration = Duration(milliseconds: 220);
  static const double _swipeDismissVelocity = 700;

  late final PageController _pageCtrl;
  late int _currentIndex;

  final Map<int, TransformationController> _transformCtrls = {};
  final Map<int, AnimationController> _zoomAnimCtrls = {};
  Offset? _lastDoubleTapPosition;

  bool _chromeVisible = true;
  Timer? _chromeTimer;
  double _currentScale = 1.0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.args.initialIndex.clamp(
      0,
      widget.args.imageUrls.length - 1,
    );
    _pageCtrl = PageController(initialPage: _currentIndex);
    _scheduleChromeFade();
  }

  @override
  void dispose() {
    _chromeTimer?.cancel();
    _pageCtrl.dispose();
    for (final c in _transformCtrls.values) {
      c.dispose();
    }
    for (final c in _zoomAnimCtrls.values) {
      c.dispose();
    }
    super.dispose();
  }

  TransformationController _transformCtrlFor(int index) {
    return _transformCtrls.putIfAbsent(index, () {
      final c = TransformationController();
      c.addListener(() => _onTransformChanged(index));
      return c;
    });
  }

  AnimationController _zoomAnimCtrlFor(int index) {
    return _zoomAnimCtrls.putIfAbsent(index, () {
      return AnimationController(vsync: this, duration: _zoomAnimDuration);
    });
  }

  void _onTransformChanged(int index) {
    if (index != _currentIndex) return;
    final scale = _transformCtrlFor(index).value.getMaxScaleOnAxis();
    if ((scale - _currentScale).abs() < 0.01) return;
    setState(() => _currentScale = scale);
  }

  void _scheduleChromeFade() {
    _chromeTimer?.cancel();
    _chromeTimer = Timer(_chromeFadeAfter, () {
      if (!mounted) return;
      setState(() => _chromeVisible = false);
    });
  }

  void _toggleChrome() {
    setState(() => _chromeVisible = !_chromeVisible);
    if (_chromeVisible) _scheduleChromeFade();
  }

  void _handleDoubleTap() {
    final index = _currentIndex;
    final transform = _transformCtrlFor(index);
    final anim = _zoomAnimCtrlFor(index);

    final currentScale = transform.value.getMaxScaleOnAxis();
    final shouldZoomIn = currentScale < _doubleTapScale - 0.05;

    Matrix4 targetMatrix;
    if (shouldZoomIn && _lastDoubleTapPosition != null) {
      final pos = _lastDoubleTapPosition!;
      final offset = _doubleTapScale - 1;
      targetMatrix = Matrix4.identity()
        ..translateByDouble(-pos.dx * offset, -pos.dy * offset, 0, 1)
        ..scaleByDouble(_doubleTapScale, _doubleTapScale, 1, 1);
    } else {
      targetMatrix = Matrix4.identity();
    }

    final tween = Matrix4Tween(begin: transform.value, end: targetMatrix);
    anim
      ..removeListener(() {})
      ..reset();

    void listener() {
      transform.value = tween.evaluate(
        CurvedAnimation(parent: anim, curve: Curves.easeOutCubic),
      );
    }

    anim.addListener(listener);
    anim.forward().whenComplete(() => anim.removeListener(listener));
  }

  void _handleVerticalDrag(DragEndDetails details) {
    if (_currentScale > 1.01) return;
    final vy = details.primaryVelocity ?? 0;
    if (vy.abs() > _swipeDismissVelocity) {
      Navigator.of(context).maybePop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.args.imageUrls.length;
    final isZoomed = _currentScale > 1.01;
    final chromeOpacity = _chromeVisible ? 1.0 : 0.0;

    return Scaffold(
      backgroundColor: AppColors.black,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _toggleChrome,
        onVerticalDragEnd: _handleVerticalDrag,
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageCtrl,
              physics: isZoomed
                  ? const NeverScrollableScrollPhysics()
                  : const ClampingScrollPhysics(),
              itemCount: total,
              onPageChanged: (i) {
                setState(() {
                  _currentIndex = i;
                  _currentScale =
                      _transformCtrlFor(i).value.getMaxScaleOnAxis();
                });
                _scheduleChromeFade();
              },
              itemBuilder: (context, i) {
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onDoubleTapDown: (d) =>
                      _lastDoubleTapPosition = d.localPosition,
                  onDoubleTap: _handleDoubleTap,
                  child: InteractiveViewer(
                    transformationController: _transformCtrlFor(i),
                    minScale: _minScale,
                    maxScale: _maxScale,
                    panEnabled: true,
                    child: Center(
                      child: _buildImage(widget.args.imageUrls[i]),
                    ),
                  ),
                );
              },
            ),
            PositionedDirectional(
              top: 0,
              start: 0,
              end: 0,
              child: SafeArea(
                child: IgnorePointer(
                  ignoring: !_chromeVisible,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 220),
                    opacity: chromeOpacity,
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(12, 12, 12, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _GlassPill(
                            onTap: () => Navigator.of(context).maybePop(),
                            child: const FaIcon(
                              FontAwesomeIcons.xmark,
                              size: 16,
                              color: AppColors.white,
                            ),
                          ),
                          if (total > 1)
                            _GlassPill(
                              onTap: null,
                              child: Text(
                                'image_viewer_screen.counter'.tr(
                                  namedArgs: {
                                    'current': localizedNumber(_currentIndex + 1),
                                    'total': localizedNumber(total),
                                  },
                                ),
                                style: AppFonts.primary(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.white,
                                  height: 1.1,
                                  letterSpacing: 0.4,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (total > 1)
              PositionedDirectional(
                bottom: 0,
                start: 0,
                end: 0,
                child: SafeArea(
                  child: IgnorePointer(
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 220),
                      opacity: isZoomed ? 0.0 : 1.0,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 18),
                        child: Center(
                          child: _AuroraDotIndicator(
                            count: total,
                            activeIndex: _currentIndex,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(String url) {
    if (url.startsWith('http')) {
      return Image.network(
        url,
        fit: BoxFit.contain,
        errorBuilder: (_, _, _) => _errorPlaceholder(),
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return const Center(
            child: SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.auroraElectricBlue,
              ),
            ),
          );
        },
      );
    }
    return Image.asset(
      url,
      fit: BoxFit.contain,
      errorBuilder: (_, _, _) => _errorPlaceholder(),
    );
  }

  Widget _errorPlaceholder() {
    return Center(
      child: FaIcon(
        FontAwesomeIcons.image,
        size: 56,
        color: AppColors.white.withValues(alpha: 0.35),
      ),
    );
  }
}

class _GlassPill extends StatelessWidget {
  const _GlassPill({required this.child, required this.onTap});

  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final content = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.10),
        border: Border.all(
          color: AppColors.white.withValues(alpha: 0.18),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
    if (onTap == null) return content;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: content,
    );
  }
}

class _AuroraDotIndicator extends StatelessWidget {
  const _AuroraDotIndicator({
    required this.count,
    required this.activeIndex,
  });

  final int count;
  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    final inactive = AppColors.white.withValues(alpha: 0.45);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (i) {
        final isActive = i == activeIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: isActive ? 20 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: isActive ? AppColors.auroraElectricBlue : inactive,
            borderRadius: BorderRadius.circular(3),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: AppColors.auroraElectricBlue.withValues(alpha: 0.45),
                      blurRadius: 8,
                    ),
                  ]
                : null,
          ),
        );
      }),
    );
  }
}
