import 'package:dartz/dartz.dart';
import 'package:primo/core/models/product_model.dart';
import 'package:primo/core/network/api_error_handler.dart';
import 'package:primo/feature/favorites/domain/repo/favorites_repo.dart';

class GetFavoritesUseCase {
  final FavoritesRepo _repo;

  GetFavoritesUseCase(this._repo);

  Future<Either<Failure, List<ProductModel>>> execute() async {
    return await _repo.getFavorites();
  }
}
