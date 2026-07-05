import 'package:dartz/dartz.dart';
import 'package:primo/core/network/api_error_handler.dart';
import 'package:primo/feature/cart/data/models/cart_item_model.dart';
import 'package:primo/feature/cart/domain/repos/cart_repo.dart';

class GetCartUseCase {
  final CartRepo _repo;

  GetCartUseCase(this._repo);

  Future<Either<Failure, List<CartItemModel>>> call() async {
    return await _repo.getCart();
  }
}
