import 'package:dartz/dartz.dart';
import 'package:primo/core/network/api_error_handler.dart';
import '../../data/models/change_password_request_body.dart';
import '../repo/profile_repo.dart';

class ChangePasswordUseCase {
  final ProfileRepo _profileRepo;
  ChangePasswordUseCase(this._profileRepo);

  Future<Either<Failure, String>> execute(ChangePasswordRequestBody body) async {
    return await _profileRepo.changePassword(body);
  }
}
