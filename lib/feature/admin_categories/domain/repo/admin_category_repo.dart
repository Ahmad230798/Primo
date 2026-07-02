import 'package:dartz/dartz.dart';
import 'package:primo/core/network/api_error_handler.dart';
import 'package:primo/core/models/category_model.dart';
import '../../data/models/add_category_request_body.dart';

abstract class AdminCategoryRepo {
  // الدالة القديمة (الإضافة)
  Future<Either<Failure, CategoryModel>> addCategory(
    AddCategoryRequestBody body,
  );

  // الدالة الجديدة (جلب كل الأقسام)
  Future<Either<Failure, List<CategoryModel>>> getAllCategories();

  // (اختياري لاحقاً) يمكنك إضافة دوال التعديل والحذف هنا إذا احتجتها
}
