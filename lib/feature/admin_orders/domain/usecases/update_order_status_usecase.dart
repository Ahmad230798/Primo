import 'package:dartz/dartz.dart';
import 'package:primo/core/network/api_error_handler.dart';
import '../repo/admin_orders_repo.dart';

class UpdateOrderStatusUseCase {
  final AdminOrdersRepo _repo;
  UpdateOrderStatusUseCase(this._repo);

  Future<Either<Failure, String>> call(int orderId, String newStatus) async {
    return await _repo.updateOrderStatus(orderId, newStatus);
  }
}
