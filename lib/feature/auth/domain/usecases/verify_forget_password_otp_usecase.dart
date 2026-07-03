import 'package:dartz/dartz.dart';
import 'package:primo/core/network/api_error_handler.dart';
import 'package:primo/feature/auth/data/models/forget_password_response.dart';
import 'package:primo/feature/auth/data/models/otp_request_body.dart';
import 'package:primo/feature/auth/domain/repo/auth_repo.dart';

class VerifyForgetPasswordOtpUsecase {
  final AuthRepo _authRepo;

  VerifyForgetPasswordOtpUsecase(this._authRepo);

  Future<Either<Failure, ForgetPasswordResponse>> execute(OtpRequestBody otpRequestBody) async {
    return await _authRepo.verifyForgotPasswordOtp(otpRequestBody);
  }
}