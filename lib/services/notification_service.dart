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

  final List<AppNotification> _items = [
    AppNotification(id: '1', title: 'Your order #1234 has been shipped!', time: '2m ago', isToday: true),
    AppNotification(id: '2', title: 'Flash sale starts in 1 hour', time: '15m ago', isToday: true),
    AppNotification(id: '3', title: 'New arrivals in Dresses category', time: '1h ago', isToday: true),
    AppNotification(id: '4', title: 'Your wishlist item is on sale!', time: '3h ago', isToday: false, isRead: true),
    AppNotification(id: '5', title: 'Welcome to Sooki!', time: '1d ago', isToday: false, isRead: true),
  ];

  List<AppNotification> get items => List.unmodifiable(_items);
  List<AppNotification> get todayItems => _items.where((n) => n.isToday).toList();
  List<AppNotification> get earlierItems => _items.where((n) => !n.isToday).toList();
  int get unreadCount => _items.where((n) => !n.isRead).length;

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
