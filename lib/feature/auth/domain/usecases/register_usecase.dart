import 'package:dartz/dartz.dart';
import 'package:primo/core/network/api_error_handler.dart';
import 'package:primo/feature/auth/data/models/register_response_body.dart';
import 'package:primo/feature/auth/domain/repo/auth_repo.dart';
import '../../data/models/register_request_body.dart';

class RegisterUseCase {
  final AuthRepo _authRepo;

  RegisterUseCase(this._authRepo);

  Future<Either<Failure, RegisterResponseBody>> execute(
    RegisterRequestBody registerRequestBody,
  ) async {
    return await _authRepo.register(registerRequestBody);
  }
}
