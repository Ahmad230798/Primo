import 'package:dartz/dartz.dart';
import 'package:primo/core/models/category_model.dart';
import 'package:primo/core/models/product_model.dart';
import 'package:primo/core/network/api_error_handler.dart';

abstract class UserCategoriesRepo {
  Future<Either<Failure, List<CategoryModel>>> getUserCategories();
  Future<Either<Failure, List<ProductModel>>> getCategoryProducts(int categoryId, {String? categoryName});
}
