import 'package:dartz/dartz.dart';
import 'package:primo/core/network/api_error_handler.dart';
import '../../data/models/profile_response.dart';
import '../../data/models/update_profile_request_body.dart';
import '../../data/models/change_password_request_body.dart';

abstract class ProfileRepo {
  Future<Either<Failure, ProfileResponse>> getProfile();
  Future<Either<Failure, ProfileResponse>> updateProfile(UpdateProfileRequestBody body);
  Future<Either<Failure, String>> changePassword(ChangePasswordRequestBody body);

}
