import 'package:dartz/dartz.dart';
import 'package:primo/core/network/api_consumer.dart';
import 'package:primo/core/network/api_constant.dart';
import 'package:primo/core/network/api_error_handler.dart';
import 'package:primo/feature/admin_settings/data/models/store_settings_model.dart';
import 'package:primo/feature/admin_settings/domain/repos/store_settings_repo.dart';

class StoreSettingsRepoImpl implements StoreSettingsRepo {
  final ApiConsumer _apiConsumer;

  StoreSettingsRepoImpl(this._apiConsumer);

  @override
  Future<Either<Failure, DeliveryPriceModel>> getDeliveryPrice() async {
    try {
      final response = await _apiConsumer.get(path: ApiConstant.adminDeliveryPrice);
      final data = response['data'] ?? response;
      if (data is Map<String, dynamic>) {
        return Right(DeliveryPriceModel.fromJson(data));
      }
      return Right(DeliveryPriceModel(price: 0));
    } on ServerFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure("حدث خطأ غير متوقع: $e"));
    }
  }

  @override
  Future<Either<Failure, void>> updateDeliveryPrice(num price) async {
    try {
      await _apiConsumer.post(
        path: ApiConstant.adminDeliveryPrice,
        body: {
          '_method': 'PATCH',
          'price': price.toString(),
        },
      );
      return const Right(null);
    } on ServerFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure("حدث خطأ غير متوقع: $e"));
    }
  }

  @override
  Future<Either<Failure, void>> addStoreAddress(AddStoreAddressRequest request) async {
    try {
      await _apiConsumer.post(
        path: ApiConstant.adminAddress,
        body: request.toJson(),
      );
      return const Right(null);
    } on ServerFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure("حدث خطأ غير متوقع: $e"));
    }
  }
}
