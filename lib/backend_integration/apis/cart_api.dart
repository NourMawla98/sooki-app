import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../dio/client/api_client.dart';
import '../dio/client/request_executor.dart';
import '../dtos/cart/cart_dto.dart';

@injectable
class CartApi {
  final Dio _dio;

  CartApi(@Named(apiClientKey) this._dio);

  Future<Either<ApiFailure, CartResponseDto>> getCart() {
    return executeRequest(
      client: _dio,
      method: HttpMethod.get,
      path: 'customer/cart',
      operationName: 'getCart',
      successParser: (response) {
        final data = response.data['data'] as Map<String, dynamic>? ?? {};
        return CartResponseDto.fromJson(data);
      },
    );
  }

  Future<Either<ApiFailure, String>> addToCart(int? sizeValueId, int quantity) {
    return executeRequest(
      client: _dio,
      method: HttpMethod.post,
      path: 'customer/cart',
      body: {'itemSizeId': sizeValueId, 'quantity': quantity},
      operationName: 'addToCart',
      successParser: (r) =>
          (r.data as Map<String, dynamic>?)?['message'] as String? ?? '',
    );
  }

  Future<Either<ApiFailure, String>> updateQuantity(
      int cartItemId, int quantity) {
    return executeRequest(
      client: _dio,
      method: HttpMethod.put,
      path: 'customer/cart/$cartItemId',
      body: {'quantity': quantity},
      operationName: 'updateCartQuantity',
      successParser: (r) =>
          (r.data as Map<String, dynamic>?)?['message'] as String? ?? '',
    );
  }

  Future<Either<ApiFailure, String>> removeItem(int cartItemId) {
    return executeRequest(
      client: _dio,
      method: HttpMethod.delete,
      path: 'customer/cart/$cartItemId',
      operationName: 'removeCartItem',
      successParser: (r) =>
          (r.data as Map<String, dynamic>?)?['message'] as String? ?? '',
    );
  }

  Future<Either<ApiFailure, String>> clearCart() {
    return executeRequest(
      client: _dio,
      method: HttpMethod.delete,
      path: 'customer/cart',
      operationName: 'clearCart',
      successParser: (r) =>
          (r.data as Map<String, dynamic>?)?['message'] as String? ?? '',
    );
  }
}
