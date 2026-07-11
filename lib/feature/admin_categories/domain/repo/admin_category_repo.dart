import 'package:dartz/dartz.dart';
import 'package:primo/core/network/api_error_handler.dart';
import 'package:primo/core/models/category_model.dart';
import '../../data/models/add_category_request_body.dart';
import '../../data/models/update_category_request_body.dart';

abstract class AdminCategoryRepo {
  // الدالة القديمة (الإضافة)
  Future<Either<Failure, CategoryModel>> addCategory(
    AddCategoryRequestBody body,
  );

  // الدالة الجديدة (جلب كل الأقسام)
  Future<Either<Failure, List<CategoryModel>>> getAllCategories();

  Future<Either<Failure, CategoryModel>> updateCategory(
    int categoryId,
    UpdateCategoryRequestBody body,
  );
  Future<Either<Failure, void>> deleteCategory(int categoryId);
}
