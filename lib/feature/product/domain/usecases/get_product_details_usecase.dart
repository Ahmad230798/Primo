import 'package:dartz/dartz.dart';
import 'package:primo/core/models/product_model.dart';
import 'package:primo/core/network/api_error_handler.dart';
import 'package:primo/feature/product/domain/repo/product_repo.dart';

class GetProductDetailsUseCase {
  final ProductRepo _repo;

  GetProductDetailsUseCase(this._repo);

  Future<Either<Failure, ProductModel>> execute(int productId) async {
    return await _repo.getProductDetails(productId);
  }
}
