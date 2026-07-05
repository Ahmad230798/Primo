import 'package:primo/core/models/product_model.dart';

abstract class FavoritesState {}

class FavoritesInitial extends FavoritesState {}

class FavoritesLoading extends FavoritesState {}

class FavoritesLoaded extends FavoritesState {
  final List<ProductModel> favorites;
  FavoritesLoaded(this.favorites);
}

class FavoritesError extends FavoritesState {
  final String errorMessage;
  FavoritesError(this.errorMessage);
}

class FavoriteToggleSuccess extends FavoritesState {
  final int productId;
  final bool isFavorited;
  final String message;
  FavoriteToggleSuccess(this.productId, this.isFavorited, this.message);
}
