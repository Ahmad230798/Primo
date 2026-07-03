import 'package:dartz/dartz.dart';
import 'package:primo/feature/auth/domain/repo/auth_repo.dart';
import '../../../../core/network/api_error_handler.dart';
import '../../data/models/resend_otp_request_body.dart';
import '../../data/models/forget_password_response.dart'; // استخدمنا الموديل المشترك

class ResendOtpUseCase {
  final AuthRepo _authRepo;

  ResendOtpUseCase(this._authRepo);

  Future<Either<Failure, ForgetPasswordResponse>> execute(
    ResendOtpRequestBody body,
  ) async {
    return await _authRepo.resendOtp(body);
  }
}
