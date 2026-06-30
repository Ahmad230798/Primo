import 'package:dartz/dartz.dart';
import 'package:primo/core/network/api_constant.dart';
import 'package:primo/core/network/api_consumer.dart';
import 'package:primo/core/network/api_error_handler.dart';
import 'package:primo/feature/auth/data/models/register_request_body.dart';
import 'package:primo/feature/auth/data/models/register_response_body.dart';
import 'package:primo/feature/auth/data/repos/auh_repo.dart';

class AuthRepoImpl implements AuthRepo {
  final ApiConsumer _apiConsumer;
  AuthRepoImpl(this._apiConsumer);

  @override
  Future<Either<Failure, RegisterResponseBody>> register(
    RegisterRequestBody registerRequestBody,
  ) async {
    try {
      final response = await _apiConsumer.postFormData(
        path: ApiConstant.register,
        formData: registerRequestBody.toFormData(),
      );

      // إذا نجح الطلب، نعيد البيانات في جهة اليمين (Right)
      return Right(RegisterResponseBody.fromJson(response));
    } on ServerFailure catch (failure) {
      // إذا اعترض الـ ErrorHandler الطلب ورمى خطأ، نمسكه ونضعه في اليسار (Left)
      return Left(failure);
    } catch (e) {
      // حماية إضافية لأي خطأ برمجي غير متوقع
      return Left(ServerFailure("حدث خطأ غير متوقع: $e"));
    }
  }
}
