import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

import '../backend_integration/apis/notifications_api.dart';
import '../backend_integration/dtos/notification/notification_dto.dart';

/// Backs the bell badge, the header dropdown panel, and the full notifications
/// screen. Reads the real paginated inbox + unread-count endpoints.
class NotificationService extends ChangeNotifier {
  static final instance = NotificationService._();
  NotificationService._();

  NotificationsApi get _api => GetIt.instance<NotificationsApi>();

  static const int _pageSize = 20;

  final List<NotificationDto> _items = [];
  int _page = 1;
  bool _isLastPage = false;
  bool _isLoading = false;
  int _unreadCount = 0;

  List<NotificationDto> get items => List.unmodifiable(_items);
  List<NotificationDto> get todayItems =>
      _items.where((n) => n.isToday).toList();
  List<NotificationDto> get earlierItems =>
      _items.where((n) => !n.isToday).toList();
  int get unreadCount => _unreadCount;
  bool get isLoading => _isLoading;
  bool get isLastPage => _isLastPage;

  /// Initial load / pull-to-refresh: resets to the first page and refreshes
  /// the unread count.
  Future<void> fetchNotifications() async {
    _page = 1;
    _isLastPage = false;
    await _loadPage(reset: true);
    await fetchUnreadCount();
  }

  /// Infinite-scroll: append the next page.
  Future<void> loadMore() async {
    if (_isLastPage || _isLoading) return;
    _page += 1;
    await _loadPage(reset: false);
  }

  Future<void> _loadPage({required bool reset}) async {
    if (_isLoading) return;
    _isLoading = true;
    notifyListeners();

    final result = await _api.getInbox(page: _page, pageSize: _pageSize);

    result.fold(
      (_) {
        // ErrorInterceptor is silenced for this endpoint; keep current list.
        if (reset && _items.isEmpty) _isLastPage = true;
      },
      (page) {
        if (reset) _items.clear();
        _items.addAll(page.items);
        _isLastPage = page.isLastPage;
      },
    );

    _isLoading = false;
    notifyListeners();
  }

  /// Refresh the unread badge count from the dedicated endpoint.
  Future<void> fetchUnreadCount() async {
    final result = await _api.getUnreadCount();
    result.fold((_) {}, (count) {
      _unreadCount = count;
      notifyListeners();
    });
  }

  Future<void> markRead(int id) async {
    final index = _items.indexWhere((n) => n.id == id);
    if (index == -1 || _items[index].isRead) return;

    // Optimistic update.
    _items[index] = _items[index].copyWith(isRead: true);
    if (_unreadCount > 0) _unreadCount -= 1;
    notifyListeners();

    final result = await _api.markRead(id);
    result.fold((_) => fetchUnreadCount(), (_) {});
  }

  Future<void> markAllRead() async {
    if (_items.every((n) => n.isRead) && _unreadCount == 0) return;

    final readAll = _items.map((n) => n.copyWith(isRead: true)).toList();
    _items
      ..clear()
      ..addAll(readAll);
    _unreadCount = 0;
    notifyListeners();

    final result = await _api.markAllRead();
    result.fold((_) => fetchUnreadCount(), (_) {});
  }
}
