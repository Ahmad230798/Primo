import 'package:dartz/dartz.dart';
import 'package:primo/core/network/api_error_handler.dart';
import 'package:primo/feature/admin_settings/data/models/store_settings_model.dart';

abstract class StoreSettingsRepo {
  Future<Either<Failure, DeliveryPriceModel>> getDeliveryPrice();
  Future<Either<Failure, void>> updateDeliveryPrice(num price);
  Future<Either<Failure, void>> addStoreAddress(AddStoreAddressRequest request);
}
