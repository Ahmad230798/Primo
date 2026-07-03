import 'package:dartz/dartz.dart' show Either;
import 'package:primo/core/network/api_error_handler.dart';
import 'package:primo/feature/auth/data/models/forget_password_response.dart';
import 'package:primo/feature/auth/data/models/reset_password_request_body.dart';
import 'package:primo/feature/auth/domain/repo/auth_repo.dart';

class ResetPasswordUseCase {
  final AuthRepo _authRepo;
  ResetPasswordUseCase(this._authRepo);
  Future<Either<Failure, ForgetPasswordResponse>> execute(
    ResetPassworRequestBody resetPassworRequestBody,
  ) async {
    return await _authRepo.resetPassword(resetPassworRequestBody);
  }
}
