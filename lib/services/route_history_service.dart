import 'package:flutter/widgets.dart';

/// Tracks the named routes currently on the navigator, bottom of the stack
/// first.
///
/// A language change cannot be picked up by rebuilding in place: `.tr()` is
/// context-free, so text already built keeps the old language, and screens keep
/// whatever they fetched under the old `X-Language`. The whole stack is
/// therefore pushed again, and this history is what puts the customer back on
/// the screen they were looking at.
///
/// Only named page routes are recorded. Dialogs and other popup routes are left
/// out on purpose: they are transient, and the language picker itself is one.
class RouteHistoryService extends NavigatorObserver {
  RouteHistoryService._();

  static final RouteHistoryService instance = RouteHistoryService._();

  final List<RouteSettings> _stack = [];

  /// Tab the main screen is showing. It is widget state rather than a route, so
  /// it has to be carried across the rebuild separately.
  int mainTabIndex = 0;

  /// Copy of the current stack, safe to iterate while the navigator changes.
  List<RouteSettings> get stack => List.unmodifiable(_stack);

  bool _isTracked(Route<dynamic> route) =>
      route is PageRoute && (route.settings.name?.isNotEmpty ?? false);

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (_isTracked(route)) _stack.add(route.settings);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _remove(route);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _remove(route);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (oldRoute != null) _remove(oldRoute);
    if (newRoute != null && _isTracked(newRoute)) _stack.add(newRoute.settings);
  }

  void _remove(Route<dynamic> route) {
    if (!_isTracked(route)) return;
    final index = _stack.lastIndexOf(route.settings);
    if (index != -1) _stack.removeAt(index);
  }
}
