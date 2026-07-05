import 'package:primo/core/models/product_model.dart';

abstract class CategoryProductsState {}

class CategoryProductsInitial extends CategoryProductsState {}

class CategoryProductsLoading extends CategoryProductsState {}

class CategoryProductsLoaded extends CategoryProductsState {
  final List<ProductModel> products;
  CategoryProductsLoaded(this.products);
}

class CategoryProductsError extends CategoryProductsState {
  final String errorMessage;
  CategoryProductsError(this.errorMessage);
}
