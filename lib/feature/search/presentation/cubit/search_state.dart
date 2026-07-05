import 'package:primo/core/models/product_model.dart';

abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final List<ProductModel> products;
  SearchLoaded(this.products);
}

class SearchError extends SearchState {
  final String errorMessage;
  SearchError(this.errorMessage);
}
