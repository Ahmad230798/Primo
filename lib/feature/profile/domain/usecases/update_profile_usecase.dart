import 'package:dartz/dartz.dart';
import 'package:primo/core/network/api_error_handler.dart';
import '../../data/models/profile_response.dart';
import '../../data/models/update_profile_request_body.dart';
import '../repo/profile_repo.dart';

class UpdateProfileUseCase {
  final ProfileRepo _profileRepo;
  UpdateProfileUseCase(this._profileRepo);

  Future<Either<Failure, ProfileResponse>> execute(UpdateProfileRequestBody body) async {
    return await _profileRepo.updateProfile(body);
  }
}
