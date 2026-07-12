import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:primo/core/network/api_consumer.dart';
import 'package:primo/core/network/api_constant.dart';
import 'package:primo/core/network/api_error_handler.dart';
import 'package:primo/core/network/app_storage.dart';
import 'package:primo/feature/home/data/models/home_data_model.dart';
import 'package:primo/feature/home/domain/repo/home_repo.dart';

class HomeRepoImpl implements HomeRepo {
  final ApiConsumer _apiConsumer;

  HomeRepoImpl(this._apiConsumer);

  @override
  Future<Either<Failure, HomeDataModel>> getHomeData({String? search}) async {
    try {
      final queryParameters = <String, dynamic>{};
      if (search != null && search.trim().isNotEmpty) {
        queryParameters['search'] = search.trim();
      }
      final response = await _apiConsumer.get(
        path: ApiConstant.userHome,
        queryParameters: queryParameters.isNotEmpty ? queryParameters : null,
      );
      final rawData = response['data'];
      if (search == null || search.trim().isEmpty) {
        try {
          await AppStorage.cacheData('cache_user_home', jsonEncode(rawData));
        } catch (_) {}
      }
      final data = HomeDataModel.fromJson(rawData);
      return Right(data);
    } catch (e) {
      if (search == null || search.trim().isEmpty) {
        try {
          final cached = await AppStorage.getCachedData('cache_user_home');
          if (cached != null) {
            final rawData = jsonDecode(cached);
            final data = HomeDataModel.fromJson(rawData);
            return Right(data);
          }
        } catch (_) {}
      }
      if (e is ServerFailure) return Left(e);
      return Left(ServerFailure("حدث خطأ غير متوقع: $e"));
    }
  }
}
