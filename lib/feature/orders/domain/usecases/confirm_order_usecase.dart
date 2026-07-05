import 'package:dartz/dartz.dart';
import 'package:primo/core/models/order_model.dart';
import 'package:primo/core/network/api_error_handler.dart';
import 'package:primo/feature/orders/domain/repos/orders_repo.dart';

class ConfirmOrderUseCase {
  final OrdersRepo _repo;

  ConfirmOrderUseCase(this._repo);

  Future<Either<Failure, OrderModel>> call(int isDelivery, String? addressId) async {
    return await _repo.confirmOrder(isDelivery, addressId);
  }
}
