import 'package:dartz/dartz.dart';
import 'package:primo/core/models/order_model.dart';
import 'package:primo/core/network/api_error_handler.dart';
import 'package:primo/feature/orders/domain/repos/orders_repo.dart';

class GetOrdersUseCase {
  final OrdersRepo _repo;

  GetOrdersUseCase(this._repo);

  Future<Either<Failure, List<OrderModel>>> call({String? status}) async {
    return await _repo.getOrders(status: status);
  }
}
