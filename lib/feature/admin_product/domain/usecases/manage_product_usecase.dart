import 'package:dartz/dartz.dart';
import 'package:primo/core/network/api_error_handler.dart';
import 'package:primo/core/models/product_model.dart';
import '../../data/models/add_product_request_body.dart';
import '../../data/models/update_product_request_body.dart';
import '../repo/admin_product_repo.dart';

class ManageProductUseCase {
  final AdminProductRepo _repo;
  ManageProductUseCase(this._repo);

  Future<Either<Failure, ProductModel>> create(
    AddProductRequestBody body,
  ) async => await _repo.createProduct(body);
  Future<Either<Failure, ProductModel>> update(
    int productId,
    UpdateProductRequestBody body,
  ) async => await _repo.updateProduct(productId, body);
  Future<Either<Failure, void>> deleteProduct(int productId) async =>
      await _repo.deleteProduct(productId);
  Future<Either<Failure, void>> deleteVariant(int variantId) async =>
      await _repo.deleteVariant(variantId);
  Future<Either<Failure, ProductModel>> toggleStatus(int productId) async =>
      await _repo.toggleProductStatus(productId);
}
