import 'package:dartz/dartz.dart';
import 'package:primo/core/models/product_model.dart';
import 'package:primo/core/network/api_consumer.dart';
import 'package:primo/core/network/api_constant.dart';
import 'package:primo/core/network/api_error_handler.dart';
import 'package:primo/feature/favorites/domain/repo/favorites_repo.dart';

class FavoritesRepoImpl implements FavoritesRepo {
  final ApiConsumer _apiConsumer;

  FavoritesRepoImpl(this._apiConsumer);

  @override
  Future<Either<Failure, List<ProductModel>>> getFavorites() async {
    try {
      final response = await _apiConsumer.get(path: ApiConstant.userFavorites);
      final list = (response['data'] as List<dynamic>?)
              ?.map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [];
      return Right(list);
    } on ServerFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure("حدث خطأ غير متوقع: $e"));
    }
  }

  @override
  Future<Either<Failure, bool>> toggleFavorite(int productId) async {
    try {
      final response = await _apiConsumer.post(
        path: "${ApiConstant.toggleFavorite}/$productId",
      );
      final isFavorited = response['data']?['favorited'] ?? true;
      return Right(isFavorited as bool);
    } on ServerFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure("حدث خطأ غير متوقع: $e"));
    }
  }
}
