import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../dio/client/api_client.dart';
import '../dio/client/request_executor.dart';
import '../dtos/category/category_dto.dart';

@injectable
class CategoriesApi {
  final Dio _dio;

  CategoriesApi(@Named(apiClientKey) this._dio);

  Future<Either<ApiFailure, List<CategoryDto>>> getCategories() {
    return executeRequest(
      client: _dio,
      method: HttpMethod.get,
      path: 'customer/categories',
      operationName: 'getCategories',
      successParser: (response) {
        final data = response.data['data'];
        if (data == null) return <CategoryDto>[];
        if (data is List) {
          return data
              .whereType<Map<String, dynamic>>()
              .map(CategoryDto.fromJson)
              .toList();
        }
        return <CategoryDto>[];
      },
    );
  }
}
