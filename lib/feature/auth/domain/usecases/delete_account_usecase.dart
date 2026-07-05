import 'package:dartz/dartz.dart';
import 'package:primo/core/network/api_error_handler.dart';
import 'package:primo/feature/auth/domain/repo/auth_repo.dart';

class DeleteAccountUseCase {
  final AuthRepo _authRepo;
  DeleteAccountUseCase(this._authRepo);

  Future<Either<Failure, String>> execute() async {
    return await _authRepo.deleteAccount();
  }
}
