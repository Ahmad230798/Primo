import 'package:dartz/dartz.dart';
import 'package:primo/core/network/api_constant.dart';
import 'package:primo/core/network/api_consumer.dart';
import 'package:primo/core/network/api_error_handler.dart';
import 'package:primo/core/models/category_model.dart';
import '../../domain/repo/admin_category_repo.dart';
import '../models/add_category_request_body.dart';

class AdminCategoryRepoImpl implements AdminCategoryRepo {
  final ApiConsumer _apiConsumer;
  AdminCategoryRepoImpl(this._apiConsumer);

  @override
  Future<Either<Failure, CategoryModel>> addCategory(
    AddCategoryRequestBody body,
  ) async {
    try {
      final formData = await body.toFormData();
      final response = await _apiConsumer.postFormData(
        path: ApiConstant.adminCategories,
        formData: formData,
      );
      return Right(CategoryModel.fromJson(response['data']));
    } on ServerFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure("حدث خطأ غير متوقع: $e"));
    }
  }

  // --- التنفيذ الفعلي لدالة جلب الأقسام ---
  @override
  Future<Either<Failure, List<CategoryModel>>> getAllCategories() async {
    try {
      final response = await _apiConsumer.get(
        path: ApiConstant.adminCategories,
      );

      // تحويل الاستجابة إلى مصفوفة من مودل الأقسام
      final List<dynamic> dataList = response['data'];
      final categories = dataList
          .map((e) => CategoryModel.fromJson(e))
          .toList();

      return Right(categories);
    } on ServerFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure("حدث خطأ غير متوقع: $e"));
    }
  }
}
