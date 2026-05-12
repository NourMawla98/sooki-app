import 'package:flutter/foundation.dart';

/// Holds a set of async refresh callbacks registered by data-fetching widgets.
/// Call [refresh] to re-run all of them in parallel and await completion.
class RefreshNotifier extends ChangeNotifier {
  final List<Future<void> Function()> _callbacks = [];

  void register(Future<void> Function() callback) {
    _callbacks.add(callback);
  }

  void unregister(Future<void> Function() callback) {
    _callbacks.remove(callback);
  }

  Future<void> refresh() => Future.wait(_callbacks.map((cb) => cb()));
}
