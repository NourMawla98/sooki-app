import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sooki_app/backend_integration/apis/orders_api.dart';
import 'package:sooki_app/backend_integration/dio/client/request_executor.dart';
import 'package:sooki_app/backend_integration/dtos/order/place_order_request_dto.dart';
import 'package:sooki_app/services/orders_service.dart';

/// An order once went through at a higher total than checkout showed. The
/// shown total now travels with the order, and a backend refusal for changed
/// prices is reported so checkout reloads instead of leaving.

ApiFailure _failure(int status) {
  final options = RequestOptions(path: 'customer/orders');
  return (
    message: 'Prices changed',
    error: DioException(
      requestOptions: options,
      response: Response(requestOptions: options, statusCode: status),
    ),
  );
}

class _FakeOrdersApi extends OrdersApi {
  _FakeOrdersApi() : super(Dio());

  Either<ApiFailure, ({int orderId, String trackingNumber})> answer =
      const Right((orderId: 1, trackingNumber: 'SK-1'));
  PlaceOrderRequestDto? sent;

  @override
  Future<Either<ApiFailure, ({int orderId, String trackingNumber})>> placeOrder(
    PlaceOrderRequestDto dto,
  ) async {
    sent = dto;
    return answer;
  }

  @override
  Future<Either<ApiFailure, OrdersPage>> listOrders({
    int? statusFilter,
    int skip = 0,
    int take = 10,
  }) async => const Right((items: [], totalCount: 0, isLastPage: true));
}

void main() {
  test('the request carries the total the shopper saw', () {
    const dto = PlaceOrderRequestDto(customerAddressId: 4, expectedTotal: 39.0);
    expect(dto.toJson(), {'customerAddressId': 4, 'expectedTotal': 39.0});
    expect(
      const PlaceOrderRequestDto(customerAddressId: 4).toJson(),
      {'customerAddressId': 4},
    );
  });

  test('a 409 is a conflict; other statuses are not', () {
    expect(isConflictFailure(_failure(409)), isTrue);
    expect(isConflictFailure(_failure(400)), isFalse);
    expect(failureStatus(_failure(500)), 500);
  });

  test('a refused order for changed prices is reported as such', () async {
    final api = _FakeOrdersApi()..answer = Left(_failure(409));
    final outcome = await OrdersService(api).placeOrder(
      const PlaceOrderRequestDto(customerAddressId: 4, expectedTotal: 39.0),
    );

    expect(api.sent?.expectedTotal, 39.0);
    expect(outcome.order, isNull);
    expect(outcome.pricesChanged, isTrue);
  });

  test('a placed order comes back with its number', () async {
    final outcome = await OrdersService(_FakeOrdersApi()).placeOrder(
      const PlaceOrderRequestDto(customerAddressId: 4, expectedTotal: 39.0),
    );

    expect(outcome.order?.trackingNumber, 'SK-1');
    expect(outcome.pricesChanged, isFalse);
  });

  test('any other failure is not a price change', () async {
    final api = _FakeOrdersApi()..answer = Left(_failure(500));
    final outcome = await OrdersService(api).placeOrder(
      const PlaceOrderRequestDto(customerAddressId: 4),
    );
    expect(outcome.order, isNull);
    expect(outcome.pricesChanged, isFalse);
  });
}
