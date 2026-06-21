import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../dio/client/api_client.dart';
import '../dio/client/request_executor.dart';
import '../../../models/review.dart';
import '../dtos/item/for_you_item_dto.dart';
import '../dtos/item/item_detail_dto.dart';
import '../dtos/item/item_list_item_dto.dart';
import '../dtos/item/trending_item_dto.dart';

typedef ReviewsPage = ({
  List<Review> reviews,
  bool isLastPage,
  int totalCount,
});

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
    String? searchQuery,
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
        'MainCategoryId': ?mainCategoryId,
        'SubCategoryId': ?subCategoryId,
        'DetailCategoryId': ?detailCategoryId,
        if (searchQuery != null && searchQuery.isNotEmpty) 'Search': searchQuery,
        'MinPrice': ?minPrice,
        'MaxPrice': ?maxPrice,
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

  Future<Either<ApiFailure, List<ForYouItemDto>>> getForYouItems({
    List<int> viewedItemIds = const [],
    List<String> searchKeywords = const [],
  }) {
    return executeRequest(
      client: _dio,
      method: HttpMethod.post,
      path: 'customer/items/for-you',
      body: {
        'viewedItemIds': viewedItemIds,
        'searchKeywords': searchKeywords,
      },
      operationName: 'getForYouItems',
      successParser: (response) {
        final data = response.data['data'] as Map<String, dynamic>? ?? {};
        final rawItems = data['items'];
        return rawItems is List
            ? rawItems
                .whereType<Map<String, dynamic>>()
                .map(ForYouItemDto.fromJson)
                .toList()
            : <ForYouItemDto>[];
      },
    );
  }

  Future<Either<ApiFailure, ItemDetailDto>> getItemById(int id) {
    return executeRequest(
      client: _dio,
      method: HttpMethod.get,
      path: 'customer/items/$id',
      operationName: 'getItemById',
      successParser: (response) {
        final data = response.data['data'] as Map<String, dynamic>;
        return ItemDetailDto.fromJson(data);
      },
    );
  }

  Future<Either<ApiFailure, ReviewsPage>> getReviews(
    int itemId, {
    int skip = 0,
    int take = 10,
  }) {
    return executeRequest(
      client: _dio,
      method: HttpMethod.get,
      path: 'customer/items/$itemId/reviews',
      operationName: 'getReviews',
      queryParameters: {'Skip': skip, 'Take': take},
      successParser: (response) {
        final body = response.data as Map<String, dynamic>;
        final list = (body['data'] as List).cast<Map<String, dynamic>>();
        final reviews = list.map((j) {
          final dt = DateTime.tryParse(j['createdAt'] as String? ?? '') ?? DateTime.now();
          final months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
          return Review(
            userName: j['reviewerDisplayName'] as String? ?? '',
            rating: ((j['rating'] as num?) ?? 0).toDouble(),
            text: j['body'] as String? ?? '',
            date: '${dt.day} ${months[dt.month - 1]} ${dt.year}',
          );
        }).toList();
        return (
          reviews: reviews,
          isLastPage: body['isLastPage'] as bool? ?? true,
          totalCount: body['totalCount'] as int? ?? 0,
        );
      },
    );
  }

  Future<Either<ApiFailure, String>> submitReview(
    int itemId, {
    required int rating,
    required String body,
  }) {
    return executeRequest(
      client: _dio,
      method: HttpMethod.post,
      path: 'customer/items/$itemId/reviews',
      operationName: 'submitReview',
      body: {'rating': rating, 'body': body},
      successParser: (response) => (response.data['message'] as String?) ?? '',
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
