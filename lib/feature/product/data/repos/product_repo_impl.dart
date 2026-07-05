import 'package:dartz/dartz.dart';
import 'package:primo/core/models/product_model.dart';
import 'package:primo/core/network/api_consumer.dart';
import 'package:primo/core/network/api_constant.dart';
import 'package:primo/core/network/api_error_handler.dart';
import 'package:primo/feature/product/domain/repo/product_repo.dart';

class ProductRepoImpl implements ProductRepo {
  final ApiConsumer _apiConsumer;

  ProductRepoImpl(this._apiConsumer);

  @override
  Future<Either<Failure, ProductModel>> getProductDetails(int productId) async {
    try {
      final response = await _apiConsumer.get(
        path: "${ApiConstant.userProducts}/$productId",
      );
      final data = ProductModel.fromJson(response['data']);
      return Right(data);
    } on ServerFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure("حدث خطأ غير متوقع: $e"));
    }
  }
}
