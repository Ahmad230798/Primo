import 'package:dartz/dartz.dart';
import 'package:primo/core/network/api_error_handler.dart';
import 'package:primo/core/models/category_model.dart';
import '../../data/models/add_category_request_body.dart';
import '../repo/admin_category_repo.dart';

class AddCategoryUseCase {
  final AdminCategoryRepo _repo;
  AddCategoryUseCase(this._repo);

  Future<Either<Failure, CategoryModel>> execute(
    AddCategoryRequestBody body,
  ) async {
    return await _repo.addCategory(body);
  }
}
