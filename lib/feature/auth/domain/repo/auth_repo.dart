import 'package:dartz/dartz.dart';
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

abstract class AuthRepo {
  // الدالة الآن تعد بإرجاع "إما خطأ أو نجاح"
  Future<Either<Failure, RegisterResponseBody>> register(
    RegisterRequestBody registerRequestBody,
  );
  Future<Either<Failure, OtpResponse>> verifyOtp(OtpRequestBody otpRequestBody);
  Future<Either<Failure, LoginResponse>> login(
    LoginRequestBody loginRequestBody,
  );
  Future<Either<Failure, ForgetPasswordResponse>> forgotPassword(
    ForgetPasswordRequestBody forgetPasswordRequestBody,
  ); // داخل domain/repos/auth_repo.dart
  Future<Either<Failure, ForgetPasswordResponse>> verifyForgotPasswordOtp(
    OtpRequestBody otpRequestBody,
  );
  Future<Either<Failure, ForgetPasswordResponse>> resetPassword(
    ResetPassworRequestBody resetPassworRequestBody,
  );
  Future<Either<Failure, ForgetPasswordResponse>> resendOtp(ResendOtpRequestBody body);
  Future<Either<Failure, OtpResponse>> confirmLogin(OtpRequestBody otpRequestBody);
  Future<Either<Failure, String>> deleteAccount();
}
