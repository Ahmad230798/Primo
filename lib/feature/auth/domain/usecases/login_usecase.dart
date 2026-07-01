import 'package:dartz/dartz.dart';
import 'package:primo/core/network/api_error_handler.dart';
import 'package:primo/feature/auth/data/models/login_request_body.dart';
import 'package:primo/feature/auth/data/models/login_response.dart';
import 'package:primo/feature/auth/domain/repo/auth_repo.dart';

class LoginUseCase {
  
  final AuthRepo _authRepo;
  LoginUseCase(this._authRepo);
  Future<Either<Failure,LoginResponse>>execute(LoginRequestBody loginRequestBody)async{
    return await _authRepo.login(loginRequestBody);
  }
}