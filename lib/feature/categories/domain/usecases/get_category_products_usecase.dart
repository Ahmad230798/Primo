import 'package:dartz/dartz.dart';
import 'package:primo/core/models/product_model.dart';
import 'package:primo/core/network/api_error_handler.dart';
import 'package:primo/feature/categories/domain/repo/user_categories_repo.dart';

class GetCategoryProductsUseCase {
  final UserCategoriesRepo _repo;
  GetCategoryProductsUseCase(this._repo);

  Future<Either<Failure, List<ProductModel>>> execute(int categoryId, {String? categoryName}) {
    return _repo.getCategoryProducts(categoryId, categoryName: categoryName);
  }
}
