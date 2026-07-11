import 'package:dartz/dartz.dart';
import 'package:primo/core/di/service_locator.dart';
import 'package:primo/core/services/firebase_messaging_service.dart';
import 'package:primo/core/network/api_constant.dart';
import 'package:primo/core/network/api_consumer.dart';
import 'package:primo/core/network/api_error_handler.dart';
import 'package:primo/feature/auth/data/models/forget_password_request_body.dart';
import 'package:primo/feature/auth/data/models/forget_password_response.dart';
import 'package:primo/feature/auth/data/models/login_request_body.dart';
import 'package:primo/feature/auth/data/models/login_response.dart';
import 'package:primo/feature/auth/data/models/otp_request_body.dart';
import 'package:primo/feature/auth/data/models/otp_response.dart';
import 'package:primo/feature/auth/data/models/register_request_body.dart';
import 'package:primo/feature/auth/data/models/register_response_body.dart';
import 'package:primo/feature/auth/data/models/resend_otp_request_body.dart';
import 'package:primo/feature/auth/data/models/reset_password_request_body.dart';
import 'package:primo/feature/auth/domain/repo/auth_repo.dart';

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

  @override
  Future<Either<Failure, OtpResponse>> verifyOtp(
    OtpRequestBody otpRequestBody,
  ) async {
    try {
      final response = await _apiConsumer.postFormData(
        path: ApiConstant.verifyRegister,
        formData: otpRequestBody.toFormData(),
      );

      // إذا نجح الطلب، نعيد البيانات في جهة اليمين (Right)
      return Right(OtpResponse.fromJson(response));
    } on ServerFailure catch (failure) {
      // إذا اعترض الـ ErrorHandler الطلب ورمى خطأ، نمسكه ونضعه في اليسار (Left)
      return Left(failure);
    } catch (e) {
      // حماية إضافية لأي خطأ برمجي غير متوقع
      return Left(ServerFailure("حدث خطأ غير متوقع: $e"));
    }
  }

  @override
  Future<Either<Failure, LoginResponse>> login(
    LoginRequestBody loginRequestBody,
  ) async {
    try {
      final response = await _apiConsumer.postFormData(
        path: ApiConstant.login,
        formData: loginRequestBody.toFormData(),
      );
      return Right(LoginResponse.fromJson(response));
    } on ServerFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure("حدث خطأ غير متوقع: $e"));
    }
  }

  @override
  Future<Either<Failure, ForgetPasswordResponse>> forgotPassword(
    ForgetPasswordRequestBody forgetPasswordRequestBody,
  ) async {
    try {
      final response = await _apiConsumer.postFormData(
        path: ApiConstant.forgotPassword,
        formData: forgetPasswordRequestBody.toFormData(),
      );
      return Right(ForgetPasswordResponse.fromJson(response));
    } on ServerFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure("حدث خطأ غير متوقع: $e"));
    }
  }

  @override
  Future<Either<Failure, ForgetPasswordResponse>> verifyForgotPasswordOtp(
    OtpRequestBody otpRequestBody,
  ) async {
    try {
      final response = await _apiConsumer.postFormData(
        path: ApiConstant.confirmForgotPassword,
        formData: otpRequestBody.toFormData(),
      );
      return Right(ForgetPasswordResponse.fromJson(response));
    } on ServerFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure("حدث خطأ غير متوقع: $e"));
    }
  }

  @override
  Future<Either<Failure, ForgetPasswordResponse>> resetPassword(
    ResetPassworRequestBody resetPassworRequestBody,
  ) async {
    try {
      final response = await _apiConsumer.postFormData(
        path: ApiConstant.resetPassword,
        formData: resetPassworRequestBody.toFormData(),
      );
      return Right(ForgetPasswordResponse.fromJson(response));
    } on ServerFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure("حدث خطأ غير متوقع: $e"));
    }
  }

  @override
  Future<Either<Failure, ForgetPasswordResponse>> resendOtp(
    ResendOtpRequestBody body,
  ) async {
    try {
      final response = await _apiConsumer.postFormData(
        path: ApiConstant.resendOtp,
        formData: body.toFormData(),
      );
      return Right(ForgetPasswordResponse.fromJson(response));
    } on ServerFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure("حدث خطأ غير متوقع: $e"));
    }
  }
  @override
  Future<Either<Failure, OtpResponse>> confirmLogin(
    OtpRequestBody otpRequestBody,
  ) async {
    try {
      final response = await _apiConsumer.postFormData(
        path: ApiConstant.confirmLogin,
        formData: otpRequestBody.toFormData(),
      );
      return Right(OtpResponse.fromJson(response));
    } on ServerFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure("حدث خطأ غير متوقع: $e"));
    }
  }

  @override
  Future<Either<Failure, String>> deleteAccount() async {
    try {
      final response = await _apiConsumer.delete(
        path: ApiConstant.deleteAccount,
      );
      final message = (response is Map && response['message'] != null)
          ? response['message'].toString()
          : "تم حذف الحساب بنجاح";
      return Right(message);
    } on ServerFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure("حدث خطأ غير متوقع: $e"));
    }
  }
  
  @override
  Future<Either<Failure, String>> logout() async {
    try {
      String? fcmToken;
      try {
        fcmToken = await getIt<FirebaseCloudMessagingService>().getDeviceToken();
      } catch (_) {}
      final response = await _apiConsumer.post(
        path: ApiConstant.logOut,
        body: fcmToken != null ? {'fcm_token': fcmToken} : null,
      );
      final message = response['data']?['message']?.toString() ?? "تم تسجيل الخروج بنجاح";
      return Right(message);
    } on ServerFailure catch (error) {
      return Left(error);
    } catch (e) {
      return Left(ServerFailure("حدث خطأ  غير  متوقع $e"));
    }
  }
}
