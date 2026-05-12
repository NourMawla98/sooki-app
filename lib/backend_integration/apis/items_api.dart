import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../dio/client/api_client.dart';
import '../dio/client/request_executor.dart';
import '../dtos/item/item_list_item_dto.dart';
import '../dtos/item/trending_item_dto.dart';

typedef ItemsPage = ({
  List<ItemListItemDto> items,
  bool isLastPage,
  int totalCount,
});

@injectable
class ItemsApi {
  final Dio _dio;

  ItemsApi(@Named(apiClientKey) this._dio);

  Future<Either<ApiFailure, ItemsPage>> getItems({
    int? mainCategoryId,
    int skip = 0,
    int take = 20,
  }) {
    return executeRequest(
      client: _dio,
      method: HttpMethod.get,
      path: 'customer/items',
      queryParameters: {
        'Skip': skip,
        'Take': take,
        'SortBy': 1, // Newest
        if (mainCategoryId != null) 'MainCategoryId': mainCategoryId,
      },
      operationName: 'getItems',
      successParser: (response) {
        final body = response.data as Map<String, dynamic>;
        final isLastPage = body['isLastPage'] as bool? ?? true;
        final totalCount = body['totalCount'] as int? ?? 0;
        final data = body['data'];
        final items = data is List
            ? data
                .whereType<Map<String, dynamic>>()
                .map(ItemListItemDto.fromJson)
                .toList()
            : <ItemListItemDto>[];
        return (items: items, isLastPage: isLastPage, totalCount: totalCount);
      },
    );
  }

  Future<Either<ApiFailure, List<TrendingItemDto>>> getTrendingItems() {
    return executeRequest(
      client: _dio,
      method: HttpMethod.get,
      path: 'customer/items/trending',
      operationName: 'getTrendingItems',
      successParser: (response) {
        final data = response.data['data'];
        if (data == null) return <TrendingItemDto>[];
        if (data is List) {
          return data
              .whereType<Map<String, dynamic>>()
              .map(TrendingItemDto.fromJson)
              .toList();
        }
        return <TrendingItemDto>[];
      },
    );
  }
}
