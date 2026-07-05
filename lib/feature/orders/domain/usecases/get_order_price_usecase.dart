import 'package:dartz/dartz.dart';
import 'package:primo/core/models/order_model.dart';
import 'package:primo/core/network/api_error_handler.dart';
import 'package:primo/feature/orders/domain/repos/orders_repo.dart';

class GetOrderPriceUseCase {
  final OrdersRepo _repo;

  GetOrderPriceUseCase(this._repo);

  Future<Either<Failure, OrderPriceModel>> call(int isDelivery, String? addressId) async {
    return await _repo.getOrderPrice(isDelivery, addressId);
  }
}
