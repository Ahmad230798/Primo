import 'package:equatable/equatable.dart';
import 'package:primo/core/models/product_model.dart';

abstract class AdminProductsListState extends Equatable {
  const AdminProductsListState();

  @override
  List<Object?> get props => [];
}

class AdminProductsListInitial extends AdminProductsListState {}

class AdminProductsListLoading extends AdminProductsListState {}

class AdminProductsListLoaded extends AdminProductsListState {
  final List<ProductModel> products;
  const AdminProductsListLoaded(this.products);

  @override
  List<Object?> get props => [products];
}

class AdminProductsListActionSuccess extends AdminProductsListState {
  final String message;
  const AdminProductsListActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class AdminProductsListError extends AdminProductsListState {
  final String message;
  const AdminProductsListError(this.message);

  @override
  List<Object?> get props => [message];
}
