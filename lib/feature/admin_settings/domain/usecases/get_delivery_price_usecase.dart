import 'package:dartz/dartz.dart';
import 'package:primo/core/network/api_error_handler.dart';
import 'package:primo/feature/admin_settings/data/models/store_settings_model.dart';
import 'package:primo/feature/admin_settings/domain/repos/store_settings_repo.dart';

class GetDeliveryPriceUseCase {
  final StoreSettingsRepo _repo;

  GetDeliveryPriceUseCase(this._repo);

  Future<Either<Failure, DeliveryPriceModel>> call() async {
    return await _repo.getDeliveryPrice();
  }
}
