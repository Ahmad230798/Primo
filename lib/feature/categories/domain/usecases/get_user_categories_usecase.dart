import 'package:dartz/dartz.dart';
import 'package:primo/core/models/category_model.dart';
import 'package:primo/core/network/api_error_handler.dart';
import 'package:primo/feature/categories/domain/repo/user_categories_repo.dart';

class GetUserCategoriesUseCase {
  final UserCategoriesRepo _repo;

  GetUserCategoriesUseCase(this._repo);

  Future<Either<Failure, List<CategoryModel>>> execute() async {
    return await _repo.getUserCategories();
  }
}
