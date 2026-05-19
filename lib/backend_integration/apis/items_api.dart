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
  double priceMin,
  double priceMax,
  List<int> availableSizeStandardIds,
});

@injectable
class ItemsApi {
  final Dio _dio;

  ItemsApi(@Named(apiClientKey) this._dio);

  Future<Either<ApiFailure, ItemsPage>> getItems({
    int? mainCategoryId,
    int? subCategoryId,
    int? detailCategoryId,
    int sortBy = 1,
    double? minPrice,
    double? maxPrice,
    List<int> colorIds = const [],
    List<int> sizeValueIds = const [],
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
        'SortBy': sortBy,
        if (mainCategoryId != null) 'MainCategoryId': mainCategoryId,
        if (subCategoryId != null) 'SubCategoryId': subCategoryId,
        if (detailCategoryId != null) 'DetailCategoryId': detailCategoryId,
        if (minPrice != null) 'MinPrice': minPrice,
        if (maxPrice != null) 'MaxPrice': maxPrice,
        if (colorIds.isNotEmpty) 'ColorIds': colorIds,
        if (sizeValueIds.isNotEmpty) 'SizeValueIds': sizeValueIds,
      },
      operationName: 'getItems',
      successParser: (response) {
        final body = response.data as Map<String, dynamic>;
        final data = body['data'] as Map<String, dynamic>? ?? {};
        final isLastPage = data['isLastPage'] as bool? ?? true;
        final totalCount = data['totalCount'] as int? ?? 0;
        final priceMin = (data['priceMin'] as num?)?.toDouble() ?? 0.0;
        final priceMax = (data['priceMax'] as num?)?.toDouble() ?? 9999.0;
        final rawSizeIds = data['availableSizeStandardIds'] as List?;
        final availableSizeStandardIds =
            rawSizeIds?.map((e) => (e as num).toInt()).toList() ?? <int>[];
        final rawItems = data['items'];
        final items = rawItems is List
            ? rawItems
                .whereType<Map<String, dynamic>>()
                .map(ItemListItemDto.fromJson)
                .toList()
            : <ItemListItemDto>[];
        return (
          items: items,
          isLastPage: isLastPage,
          totalCount: totalCount,
          priceMin: priceMin,
          priceMax: priceMax,
          availableSizeStandardIds: availableSizeStandardIds,
        );
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
