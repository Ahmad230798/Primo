import 'package:primo/core/models/product_model.dart';
import 'package:primo/core/models/variant_model.dart';

abstract class ProductState {}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final ProductModel product;
  final VariantModel? selectedVariant;
  final int quantity;
  ProductLoaded(this.product, {this.selectedVariant, this.quantity = 1});
}

class ProductError extends ProductState {
  final String errorMessage;
  ProductError(this.errorMessage);
}
