import 'package:dartz/dartz.dart';
import 'package:primo/core/network/api_error_handler.dart';
import 'package:primo/core/models/category_model.dart';
import '../../data/models/add_category_request_body.dart';
import '../../data/models/update_category_request_body.dart';
import '../repo/admin_category_repo.dart';

class ManageCategoryUseCase {
  final AdminCategoryRepo _repo;
  ManageCategoryUseCase(this._repo);

  Future<Either<Failure, List<CategoryModel>>> getAllCategories() async =>
      await _repo.getAllCategories();

  Future<Either<Failure, CategoryModel>> addCategory(
    AddCategoryRequestBody body,
  ) async => await _repo.addCategory(body);

  Future<Either<Failure, CategoryModel>> updateCategory(
    int categoryId,
    UpdateCategoryRequestBody body,
  ) async => await _repo.updateCategory(categoryId, body);

  Future<Either<Failure, void>> deleteCategory(int categoryId) async =>
      await _repo.deleteCategory(categoryId);
}
