import 'package:flutter/widgets.dart';

import '../../../services/refresh_notifier.dart';

/// Provides a [RefreshNotifier] to the widget subtree.
/// Wrap a screen's body with this, then call [RefreshScope.of(context).refresh()]
/// from the screen's [RefreshIndicator.onRefresh].
class RefreshScope extends InheritedWidget {
  final RefreshNotifier notifier;

  const RefreshScope({
    super.key,
    required this.notifier,
    required super.child,
  });

  static RefreshNotifier? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<RefreshScope>()
        ?.notifier;
  }

  @override
  bool updateShouldNotify(RefreshScope oldWidget) =>
      notifier != oldWidget.notifier;
}

/// Mix into any [State] that fetches data on [initState].
/// Override [onRefresh] to re-run the fetch. The mixin auto-registers and
/// auto-unregisters with the nearest [RefreshScope].
mixin AutoRefreshMixin<T extends StatefulWidget> on State<T> {
  RefreshNotifier? _refreshNotifier;

  Future<void> onRefresh();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final notifier = RefreshScope.of(context);
    if (notifier != _refreshNotifier) {
      _refreshNotifier?.unregister(onRefresh);
      _refreshNotifier = notifier;
      _refreshNotifier?.register(onRefresh);
    }
  }

  @override
  void dispose() {
    _refreshNotifier?.unregister(onRefresh);
    super.dispose();
  }
}
