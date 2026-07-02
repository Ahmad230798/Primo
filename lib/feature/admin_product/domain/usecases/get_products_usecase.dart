import 'package:dartz/dartz.dart';
import 'package:primo/core/network/api_error_handler.dart';
import 'package:primo/core/models/product_model.dart';
import '../repo/admin_product_repo.dart';

class GetProductsUseCase {
  final AdminProductRepo _repo;
  GetProductsUseCase(this._repo);

  Future<Either<Failure, List<ProductModel>>> getAll() async {
    return await _repo.getProducts();
  }

  Future<Either<Failure, ProductModel>> getById(int productId) async {
    return await _repo.getProductById(productId);
  }
}
