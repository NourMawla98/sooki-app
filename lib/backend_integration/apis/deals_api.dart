import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../dio/client/api_client.dart';
import '../dio/client/request_executor.dart';
import '../dtos/deal/customer_deal_dto.dart';

@injectable
class DealsApi {
  final Dio _dio;

  DealsApi(@Named(apiClientKey) this._dio);

  /// Live deals first, ending soonest at the top, then upcoming deals by start.
  Future<Either<ApiFailure, List<CustomerDealDto>>> getDeals() {
    return executeRequest(
      client: _dio,
      method: HttpMethod.get,
      path: 'customer/deals',
      operationName: 'getDeals',
      successParser: (response) {
        final data = (response.data as Map<String, dynamic>?)?['data'];
        if (data is! List) return <CustomerDealDto>[];
        return data
            .whereType<Map<String, dynamic>>()
            .map(CustomerDealDto.fromJson)
            .toList();
      },
    );
  }
}
