import 'package:dartz/dartz.dart';
import 'package:primo/core/network/api_error_handler.dart';
import 'package:primo/feature/admin_settings/data/models/store_settings_model.dart';
import 'package:primo/feature/admin_settings/domain/repos/store_settings_repo.dart';

class AddStoreAddressUseCase {
  final StoreSettingsRepo _repo;

  AddStoreAddressUseCase(this._repo);

  Future<Either<Failure, void>> call(AddStoreAddressRequest request) async {
    return await _repo.addStoreAddress(request);
  }
}
