import 'package:dartz/dartz.dart';
import 'package:primo/core/models/order_model.dart';
import 'package:primo/core/network/api_error_handler.dart';
import '../repo/admin_orders_repo.dart';

class GetAdminOrderDetailsUseCase {
  final AdminOrdersRepo _repo;
  GetAdminOrderDetailsUseCase(this._repo);

  Future<Either<Failure, OrderModel>> call(int orderId) async {
    return await _repo.getAdminOrderDetails(orderId);
  }
}
