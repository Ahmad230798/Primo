import 'package:dartz/dartz.dart';
import 'package:primo/core/network/api_error_handler.dart';
import 'package:primo/feature/auth/domain/repo/auth_repo.dart';

class LogoutUseCase {
  final AuthRepo _authRepo;

  LogoutUseCase(this._authRepo);

  Future<Either<Failure, String>> execute() async {
    return await _authRepo.logout();
  }
}
