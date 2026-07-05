import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primo/core/models/product_model.dart';
import 'package:primo/feature/favorites/domain/usecases/get_favorites_usecase.dart';
import 'package:primo/feature/favorites/domain/usecases/toggle_favorite_usecase.dart';
import 'package:primo/feature/favorites/presentation/cubit/favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final GetFavoritesUseCase _getFavoritesUseCase;
  final ToggleFavoriteUseCase _toggleFavoriteUseCase;
  List<ProductModel> favorites = [];
  final Map<int, bool> favoriteStatusMap = {};

  FavoritesCubit(this._getFavoritesUseCase, this._toggleFavoriteUseCase)
      : super(FavoritesInitial());

  Future<void> fetchFavorites() async {
    emit(FavoritesLoading());
    final result = await _getFavoritesUseCase.execute();
    result.fold(
      (failure) => emit(FavoritesError(failure.errorMessage)),
      (list) {
        favorites = list;
        for (var prod in list) {
          if (prod.id != null) {
            favoriteStatusMap[prod.id!] = true;
          }
        }
        emit(FavoritesLoaded(list));
      },
    );
  }

  Future<void> toggleFavorite(int productId) async {
    final result = await _toggleFavoriteUseCase.execute(productId);
    result.fold(
      (failure) => emit(FavoritesError(failure.errorMessage)),
      (isFavorited) {
        favoriteStatusMap[productId] = isFavorited;
        if (!isFavorited) {
          favorites.removeWhere((item) => item.id == productId);
        }
        final msg = isFavorited ? "تم إضافة المنتج إلى المفضلة" : "تم حذف المنتج من المفضلة";
        emit(FavoriteToggleSuccess(productId, isFavorited, msg));
        emit(FavoritesLoaded(favorites));
      },
    );
  }

  bool isProductFavorited(int productId, {bool? defaultVal}) {
    return favoriteStatusMap[productId] ?? defaultVal ?? false;
  }
}
