import 'package:dartz/dartz.dart';
import 'package:primo/core/network/api_error_handler.dart';
import 'package:primo/feature/auth/data/models/forget_password_request_body.dart';
import 'package:primo/feature/auth/data/models/forget_password_response.dart';
import 'package:primo/feature/auth/domain/repo/auth_repo.dart';

class ForgotPasswordUsecase {
  final AuthRepo _authRepo;
  ForgotPasswordUsecase(this._authRepo);
  Future<Either<Failure, ForgetPasswordResponse>> execute(
      ForgetPasswordRequestBody forgetPasswordRequestBody) async {
    return await _authRepo.forgotPassword(forgetPasswordRequestBody);
  }
}
