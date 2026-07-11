import 'package:dartz/dartz.dart';
import 'package:primo/core/models/order_model.dart';
import 'package:primo/core/network/api_error_handler.dart';
import '../repo/admin_orders_repo.dart';

class GetAdminOrdersUseCase {
  final AdminOrdersRepo _repo;
  GetAdminOrdersUseCase(this._repo);

  Future<Either<Failure, List<OrderModel>>> call({String? status}) async {
    return await _repo.getAdminOrders(status: status);
  }
}
