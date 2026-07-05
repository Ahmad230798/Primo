import 'package:dartz/dartz.dart';
import 'package:primo/core/network/api_error_handler.dart';
import 'package:primo/feature/cart/domain/repos/cart_repo.dart';

class AddToCartUseCase {
  final CartRepo _repo;

  AddToCartUseCase(this._repo);

  Future<Either<Failure, String>> call(int variantId, int count) async {
    return await _repo.addToCart(variantId, count);
  }
}
