import 'package:dartz/dartz.dart';
import 'package:primo/core/network/api_error_handler.dart';
import 'package:primo/feature/cart/domain/repos/cart_repo.dart';

class UpdateCartQuantityUseCase {
  final CartRepo _repo;

  UpdateCartQuantityUseCase(this._repo);

  Future<Either<Failure, String>> call(int cartId, int count) async {
    return await _repo.updateCartQuantity(cartId, count);
  }
}
