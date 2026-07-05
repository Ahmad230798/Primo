import 'package:dartz/dartz.dart';
import 'package:primo/core/models/product_model.dart';
import 'package:primo/core/network/api_error_handler.dart';

abstract class FavoritesRepo {
  Future<Either<Failure, List<ProductModel>>> getFavorites();
  Future<Either<Failure, bool>> toggleFavorite(int productId);
}
