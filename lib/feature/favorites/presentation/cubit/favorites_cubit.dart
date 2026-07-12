import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primo/core/models/product_model.dart';
import 'package:primo/core/network/app_storage.dart';
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

  Future<void> fetchFavorites({bool showLoading = true}) async {
    bool hasCache = false;
    if (favorites.isEmpty) {
      try {
        final cached = await AppStorage.getCachedData('cache_user_favorites');
        if (cached != null) {
          final List<dynamic> jsonList = jsonDecode(cached);
          favorites =
              jsonList.map((e) => ProductModel.fromJson(e)).toList();
          for (var prod in favorites) {
            if (prod.id != null) {
              favoriteStatusMap[prod.id!] = true;
            }
          }
          hasCache = true;
          if (!isClosed) emit(FavoritesLoaded(List.from(favorites)));
        }
      } catch (_) {}
    } else {
      hasCache = true;
    }

    if (!hasCache && showLoading && !isClosed) {
      emit(FavoritesLoading());
    }
    final result = await _getFavoritesUseCase.execute();
    result.fold(
      (failure) {
        if (!hasCache && favorites.isEmpty && !isClosed) {
          emit(FavoritesError(failure.errorMessage));
        }
      },
      (list) {
        favorites = list;
        favoriteStatusMap.clear();
        for (var prod in list) {
          if (prod.id != null) {
            favoriteStatusMap[prod.id!] = true;
          }
        }
        try {
          final jsonString =
              jsonEncode(list.map((e) => e.toJson()).toList());
          AppStorage.cacheData('cache_user_favorites', jsonString);
        } catch (_) {}
        if (!isClosed) emit(FavoritesLoaded(List.from(favorites)));
      },
    );
  }

  Future<void> toggleFavorite(int productId) async {
    final bool isCurrentlyFav = favoriteStatusMap[productId] ?? false;
    favoriteStatusMap[productId] = !isCurrentlyFav;
    if (isCurrentlyFav) {
      favorites = favorites.where((item) => item.id != productId).toList();
    }
    if (!isClosed) emit(FavoritesLoaded(List.from(favorites)));
    final result = await _toggleFavoriteUseCase.execute(productId);
    result.fold(
      (failure) {
        // التراجع عن التغيير إذا فشل السيرفر
        favoriteStatusMap[productId] = isCurrentlyFav;
        fetchFavorites(showLoading: false);
        if (!isClosed) emit(FavoritesError(failure.errorMessage));
      },
      (isFavorited) {
        favoriteStatusMap[productId] = isFavorited;

        if (!isFavorited) {
          favorites = favorites.where((item) => item.id != productId).toList();
        } else {
          // 💡 السّر هنا: عندما نضيف منتجاً، يجب جلب بياناته الكاملة (صورته واسمه) من السيرفر بصمت
          fetchFavorites(showLoading: false);
        }

        final msg = isFavorited
            ? "تم إضافة المنتج إلى المفضلة"
            : "تم حذف المنتج من المفضلة";
        if (!isClosed) emit(FavoriteToggleSuccess(productId, isFavorited, msg));

        if (!isClosed) emit(FavoritesLoaded(List.from(favorites)));
      },
    );
  }

  bool isProductFavorited(int productId, {bool? defaultVal}) {
    return favoriteStatusMap[productId] ?? defaultVal ?? false;
  }
}
