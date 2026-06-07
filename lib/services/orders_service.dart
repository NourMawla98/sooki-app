import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';

import '../backend_integration/apis/orders_api.dart';
import '../backend_integration/dio/client/request_executor.dart';
import '../backend_integration/dtos/order/order_detail_dto.dart';
import '../backend_integration/dtos/order/order_list_item_dto.dart';
import '../backend_integration/dtos/order/place_order_request_dto.dart';

class OrdersService extends ChangeNotifier {
  final OrdersApi _api;

  OrdersService(this._api);

  final List<OrderListItemDto> _orders = [];
  bool _isLoading = false;
  bool _isLastPage = false;
  int _totalCount = 0;
  int _activeOrderCount = 0;

  List<OrderListItemDto> get orders => List.unmodifiable(_orders);
  bool get isLoading => _isLoading;
  bool get isLastPage => _isLastPage;
  int get totalCount => _totalCount;
  int get activeOrderCount => _activeOrderCount;

  static const int _take = 10;

  Future<void> loadOrders({int? statusFilter, bool reset = false}) async {
    if (_isLoading) return;
    if (reset) {
      _orders.clear();
      _isLastPage = false;
      _totalCount = 0;
    }
    _isLoading = true;
    notifyListeners();

    final result = await _api.listOrders(
      statusFilter: statusFilter,
      skip: _orders.length,
      take: _take,
    );

    result.fold(
      (_) {},
      (page) {
        _orders.addAll(page.items);
        _totalCount = page.totalCount;
        _isLastPage = page.isLastPage;
      },
    );

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadMore({int? statusFilter}) async {
    if (_isLastPage || _isLoading) return;
    await loadOrders(statusFilter: statusFilter);
  }

  Future<void> refreshActiveCount() async {
    // Fetch with a small take just to get totalCount for active statuses.
    // Active = Processing(1) + Packaged(8) + OutForDelivery(2)
    // BE doesn't support multi-status filter so we make 3 calls and sum.
    int count = 0;
    for (final status in [1, 8, 2]) {
      final result = await _api.listOrders(statusFilter: status, skip: 0, take: 1);
      result.fold((_) {}, (page) => count += page.totalCount);
    }
    _activeOrderCount = count;
    notifyListeners();
  }

  Future<Either<ApiFailure, OrderDetailDto>> getOrderDetail(int id) {
    return _api.getOrderById(id);
  }

  Future<({int orderId, String trackingNumber})?> placeOrder(
    PlaceOrderRequestDto dto,
  ) async {
    final result = await _api.placeOrder(dto);
    return result.fold(
      (_) => null,
      (data) async {
        await refreshActiveCount();
        return data;
      },
    );
  }

  Future<({bool success, String message})> cancelOrder(int id) async {
    final result = await _api.cancelOrder(id);
    return result.fold(
      (_) => (success: false, message: ''),
      (message) async {
        await refreshActiveCount();
        return (success: true, message: message);
      },
    );
  }

  Future<({bool success, String message})> confirmReceipt(int id) async {
    final result = await _api.confirmReceipt(id);
    return result.fold(
      (_) => (success: false, message: ''),
      (message) async {
        await refreshActiveCount();
        return (success: true, message: message);
      },
    );
  }
}
