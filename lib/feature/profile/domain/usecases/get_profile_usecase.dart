import 'package:dartz/dartz.dart';
import 'package:primo/core/network/api_error_handler.dart';
import '../../data/models/profile_response.dart';
import '../repo/profile_repo.dart';

class GetProfileUseCase {
  final ProfileRepo _profileRepo;
  GetProfileUseCase(this._profileRepo);

  Future<Either<Failure, ProfileResponse>> execute() async {
    return await _profileRepo.getProfile();
  }
}
