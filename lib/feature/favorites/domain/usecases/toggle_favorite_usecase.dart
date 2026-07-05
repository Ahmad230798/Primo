import 'package:dartz/dartz.dart';
import 'package:primo/core/network/api_error_handler.dart';
import 'package:primo/feature/favorites/domain/repo/favorites_repo.dart';

class ToggleFavoriteUseCase {
  final FavoritesRepo _repo;

  ToggleFavoriteUseCase(this._repo);

  Future<Either<Failure, bool>> execute(int productId) async {
    return await _repo.toggleFavorite(productId);
  }
}
