import 'package:dartz/dartz.dart';
import 'package:primo/core/network/api_error_handler.dart';
import 'package:primo/feature/admin_settings/domain/repos/store_settings_repo.dart';

class UpdateDeliveryPriceUseCase {
  final StoreSettingsRepo _repo;

  UpdateDeliveryPriceUseCase(this._repo);

  Future<Either<Failure, void>> call(num price) async {
    return await _repo.updateDeliveryPrice(price);
  }
}
