import 'package:dartz/dartz.dart';
import 'package:primo/core/network/api_error_handler.dart';
import 'package:primo/feature/cart/data/models/cart_item_model.dart';

abstract class CartRepo {
  Future<Either<Failure, List<CartItemModel>>> getCart();
  Future<Either<Failure, String>> addToCart(int variantId, int count);
  Future<Either<Failure, String>> updateCartQuantity(int cartId, int count);
  Future<Either<Failure, String>> deleteFromCart(int cartId);
}
