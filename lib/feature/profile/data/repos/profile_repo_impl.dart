import 'package:dartz/dartz.dart';
import 'package:primo/core/network/api_constant.dart';
import 'package:primo/core/network/api_consumer.dart';
import 'package:primo/core/network/api_error_handler.dart';
import '../../domain/repo/profile_repo.dart';
import '../models/profile_response.dart';
import '../models/update_profile_request_body.dart';
import '../models/change_password_request_body.dart';

class ProfileRepoImpl implements ProfileRepo {
  final ApiConsumer _apiConsumer;
  ProfileRepoImpl(this._apiConsumer);

  @override
  Future<Either<Failure, ProfileResponse>> getProfile() async {
    try {
      final response = await _apiConsumer.get(path: ApiConstant.profile);
      return Right(ProfileResponse.fromJson(response));
    } on ServerFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure("حدث خطأ غير متوقع: $e"));
    }
  }

  @override
  Future<Either<Failure, ProfileResponse>> updateProfile(
    UpdateProfileRequestBody body,
  ) async {
    try {
      final formData = await body.toFormData();
      final response = await _apiConsumer.postFormData(
        path: ApiConstant.profile,
        formData: formData,
      );
      return Right(ProfileResponse.fromJson(response));
    } on ServerFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure("حدث خطأ غير متوقع: $e"));
    }
  }

  @override
  Future<Either<Failure, String>> changePassword(
    ChangePasswordRequestBody body,
  ) async {
    try {
      final response = await _apiConsumer.postFormData(
        path: ApiConstant.changePassword,
        formData: body.toFormData(),
      );
      final message = (response is Map && response['message'] != null)
          ? response['message'].toString()
          : "تم تغيير كلمة المرور بنجاح";
      return Right(message);
    } on ServerFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure("حدث خطأ غير متوقع: $e"));
    }
  }
}
