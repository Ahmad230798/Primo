import 'package:dartz/dartz.dart';
import 'package:primo/core/models/category_model.dart';
import 'package:primo/core/models/product_model.dart';
import 'package:primo/core/network/api_consumer.dart';
import 'package:primo/core/network/api_constant.dart';
import 'package:primo/core/network/api_error_handler.dart';
import 'package:primo/feature/categories/domain/repo/user_categories_repo.dart';

class UserCategoriesRepoImpl implements UserCategoriesRepo {
  final ApiConsumer _apiConsumer;

  UserCategoriesRepoImpl(this._apiConsumer);

  @override
  Future<Either<Failure, List<CategoryModel>>> getUserCategories() async {
    try {
      final response = await _apiConsumer.get(path: ApiConstant.userCategories);
      final list = (response['data'] as List<dynamic>?)
              ?.map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
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
  Future<Either<Failure, List<ProductModel>>> getCategoryProducts(int categoryId, {String? categoryName}) async {
    try {
      final queryParameters = <String, dynamic>{'category_id': categoryId};
      final response = await _apiConsumer.get(
        path: ApiConstant.userHome,
        queryParameters: queryParameters,
      );
      final dataMap = response['data'] as Map<String, dynamic>? ?? {};
      final productsList = (dataMap['products'] as List<dynamic>?)
              ?.map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [];

      final filtered = productsList.where((p) {
        final matchId = p.categoryId?.toString() == categoryId.toString() ||
            p.category?.id?.toString() == categoryId.toString();
        final matchName = categoryName != null && categoryName.trim().isNotEmpty &&
            (p.categoryName?.trim() == categoryName.trim() || p.category?.name?.trim() == categoryName.trim());
        return matchId || matchName;
      }).toList();

      final hasCategoryInfo = productsList.any((p) => p.categoryId != null || p.categoryName != null || p.category != null);
      if (hasCategoryInfo) {
        return Right(filtered);
      }
      return Right(productsList);
    } on ServerFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure("حدث خطأ غير متوقع: $e"));
    }
  }
}
