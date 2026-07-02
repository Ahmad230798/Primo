import 'package:dartz/dartz.dart';
import 'package:primo/core/models/category_model.dart';
import 'package:primo/core/network/api_error_handler.dart';
import 'package:primo/feature/admin_categories/domain/repo/admin_category_repo.dart';

class GetCategoriesUseCase {
  final AdminCategoryRepo _repo;
  GetCategoriesUseCase(this._repo);

  Future<Either<Failure, List<CategoryModel>>> execute() async {
    return await _repo.getAllCategories();
  }
}
