import 'package:flutter/foundation.dart';

class AppNotification {
  final String id;
  final String title;
  final String time;
  final bool isToday;
  bool isRead;

  AppNotification({
    required this.id,
    required this.title,
    required this.time,
    required this.isToday,
    this.isRead = false,
  });
}

class NotificationService extends ChangeNotifier {
  static final instance = NotificationService._();
  NotificationService._();

  final List<AppNotification> _items = [];

  bool _isLoading = false;

  List<AppNotification> get items => List.unmodifiable(_items);
  List<AppNotification> get todayItems => _items.where((n) => n.isToday).toList();
  List<AppNotification> get earlierItems => _items.where((n) => !n.isToday).toList();
  int get unreadCount => _items.where((n) => !n.isRead).length;
  bool get isLoading => _isLoading;

  // TODO(BE): replace stub with real API call when GET /customer/notifications is ready
  Future<void> fetchNotifications() async {
    _isLoading = true;
    notifyListeners();
    // no-op until BE is ready
    _isLoading = false;
    notifyListeners();
  }

  void markRead(String id) {
    final index = _items.indexWhere((n) => n.id == id);
    if (index != -1 && !_items[index].isRead) {
      _items[index].isRead = true;
      notifyListeners();
    }
  }

  void markAllRead() {
    for (final n in _items) {
      n.isRead = true;
    }
    notifyListeners();
  }

  void delete(String id) {
    _items.removeWhere((n) => n.id == id);
    notifyListeners();
  }
}
