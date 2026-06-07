import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../dio/client/api_client.dart';
import '../dio/client/request_executor.dart';
import '../dtos/order/order_detail_dto.dart';
import '../dtos/order/order_list_item_dto.dart';
import '../dtos/order/place_order_request_dto.dart';

typedef OrdersPage = ({
  List<OrderListItemDto> items,
  int totalCount,
  bool isLastPage,
});

@injectable
class OrdersApi {
  final Dio _dio;

  OrdersApi(@Named(apiClientKey) this._dio);

  Future<Either<ApiFailure, OrdersPage>> listOrders({
    int? statusFilter,
    int skip = 0,
    int take = 10,
  }) {
    return executeRequest(
      client: _dio,
      method: HttpMethod.get,
      path: 'customer/orders',
      queryParameters: {
        'Skip': skip,
        'Take': take,
        if (statusFilter != null) 'Status': statusFilter,
      },
      operationName: 'listOrders',
      successParser: (response) {
        final body = response.data as Map<String, dynamic>;
        final isLastPage = body['isLastPage'] as bool? ?? true;
        final totalCount = body['totalCount'] as int? ?? 0;
        final rawItems = body['data'];
        final items = rawItems is List
            ? rawItems
                .whereType<Map<String, dynamic>>()
                .map(OrderListItemDto.fromJson)
                .toList()
            : <OrderListItemDto>[];
        return (items: items, totalCount: totalCount, isLastPage: isLastPage);
      },
    );
  }

  Future<Either<ApiFailure, OrderDetailDto>> getOrderById(int id) {
    return executeRequest(
      client: _dio,
      method: HttpMethod.get,
      path: 'customer/orders/$id',
      operationName: 'getOrderById',
      successParser: (response) {
        final data = response.data['data'] as Map<String, dynamic>;
        return OrderDetailDto.fromJson(data);
      },
    );
  }

  Future<Either<ApiFailure, ({int orderId, String trackingNumber})>> placeOrder(
    PlaceOrderRequestDto dto,
  ) {
    return executeRequest(
      client: _dio,
      method: HttpMethod.post,
      path: 'customer/orders',
      body: dto.toJson(),
      operationName: 'placeOrder',
      successParser: (r) {
        final data = (r.data as Map<String, dynamic>?)?['data']
            as Map<String, dynamic>? ?? {};
        return (
          orderId: data['id'] as int,
          trackingNumber: data['trackingNumber'] as String? ?? '',
        );
      },
    );
  }

  Future<Either<ApiFailure, String>> cancelOrder(int id) {
    return executeRequest(
      client: _dio,
      method: HttpMethod.post,
      path: 'customer/orders/$id/cancel',
      operationName: 'cancelOrder',
      successParser: (r) =>
          (r.data as Map<String, dynamic>?)?['message'] as String? ?? '',
    );
  }

  Future<Either<ApiFailure, String>> confirmReceipt(int id) {
    return executeRequest(
      client: _dio,
      method: HttpMethod.post,
      path: 'customer/orders/$id/confirm-receipt',
      operationName: 'confirmReceipt',
      successParser: (r) =>
          (r.data as Map<String, dynamic>?)?['message'] as String? ?? '',
    );
  }

  Future<Either<ApiFailure, double>> getDeliveryFee({
    required int addressId,
    required double cartTotal,
  }) {
    return executeRequest(
      client: _dio,
      method: HttpMethod.get,
      path: 'customer/orders/delivery-fee',
      queryParameters: {
        'addressId': addressId,
        'cartTotal': cartTotal,
      },
      operationName: 'getDeliveryFee',
      successParser: (r) {
        final data = (r.data as Map<String, dynamic>?)?['data'];
        if (data is Map<String, dynamic>) {
          return (data['fee'] as num?)?.toDouble() ?? 0.0;
        }
        return (data as num?)?.toDouble() ?? 0.0;
      },
    );
  }
}
