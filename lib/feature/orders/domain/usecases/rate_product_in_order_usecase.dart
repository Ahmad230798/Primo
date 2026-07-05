import 'package:dartz/dartz.dart';
import 'package:primo/core/network/api_error_handler.dart';
import 'package:primo/feature/orders/domain/repos/orders_repo.dart';

class RateProductInOrderUseCase {
  final OrdersRepo _repo;

  RateProductInOrderUseCase(this._repo);

  Future<Either<Failure, String>> call(int productId, int orderId, int rating) async {
    return await _repo.rateProductInOrder(productId, orderId, rating);
  }
}
