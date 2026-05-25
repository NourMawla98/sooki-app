import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../dio/client/api_client.dart';
import '../dio/client/request_executor.dart';
import '../dtos/wishlist/wishlist_item_dto.dart';

typedef WishlistPage = ({
  List<WishlistItemDto> items,
  bool isLastPage,
  int totalCount,
});

@injectable
class WishlistApi {
  final Dio _dio;

  WishlistApi(@Named(apiClientKey) this._dio);

  Future<Either<ApiFailure, WishlistPage>> getWishlist({
    int skip = 0,
    int take = 20,
  }) {
    return executeRequest(
      client: _dio,
      method: HttpMethod.get,
      path: 'customer/wishlist',
      queryParameters: {'skip': skip, 'take': take},
      operationName: 'getWishlist',
      successParser: (response) {
        final body = response.data as Map<String, dynamic>;
        final isLastPage = body['isLastPage'] as bool? ?? true;
        final totalCount = body['totalCount'] as int? ?? 0;
        final rawItems = body['data'];
        final items = rawItems is List
            ? rawItems
                .whereType<Map<String, dynamic>>()
                .map(WishlistItemDto.fromJson)
                .toList()
            : <WishlistItemDto>[];
        return (items: items, isLastPage: isLastPage, totalCount: totalCount);
      },
    );
  }

  Future<Either<ApiFailure, String>> addToWishlist(int itemId) {
    return executeRequest(
      client: _dio,
      method: HttpMethod.post,
      path: 'customer/wishlist/$itemId',
      operationName: 'addToWishlist',
      successParser: (r) =>
          (r.data as Map<String, dynamic>?)?['message'] as String? ?? '',
    );
  }

  Future<Either<ApiFailure, String>> removeFromWishlist(int itemId) {
    return executeRequest(
      client: _dio,
      method: HttpMethod.delete,
      path: 'customer/wishlist/$itemId',
      operationName: 'removeFromWishlist',
      successParser: (r) =>
          (r.data as Map<String, dynamic>?)?['message'] as String? ?? '',
    );
  }
}
