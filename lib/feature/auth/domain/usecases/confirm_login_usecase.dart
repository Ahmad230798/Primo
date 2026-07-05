import 'package:dartz/dartz.dart';
import 'package:primo/core/network/api_error_handler.dart';
import 'package:primo/feature/auth/data/models/otp_request_body.dart';
import 'package:primo/feature/auth/data/models/otp_response.dart';
import 'package:primo/feature/auth/domain/repo/auth_repo.dart';

class ConfirmLoginUseCase {
  final AuthRepo _authRepo;
  ConfirmLoginUseCase(this._authRepo);

  Future<Either<Failure, OtpResponse>> execute(
    OtpRequestBody otpRequestBody,
  ) async {
    return await _authRepo.confirmLogin(otpRequestBody);
  }
}
