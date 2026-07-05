import 'package:dartz/dartz.dart';
import 'package:primo/core/network/api_error_handler.dart';
import 'package:primo/feature/cart/domain/repos/cart_repo.dart';

class DeleteFromCartUseCase {
  final CartRepo _repo;

  DeleteFromCartUseCase(this._repo);

  Future<Either<Failure, String>> call(int cartId) async {
    return await _repo.deleteFromCart(cartId);
  }
}
