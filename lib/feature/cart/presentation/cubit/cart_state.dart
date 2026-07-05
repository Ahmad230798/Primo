import 'package:equatable/equatable.dart';
import 'package:primo/feature/cart/data/models/cart_item_model.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<CartItemModel> items;
  final double totalPrice;
  final String? actionMessage;

  const CartLoaded({
    required this.items,
    required this.totalPrice,
    this.actionMessage,
  });

  @override
  List<Object?> get props => [items, totalPrice, actionMessage];
}

class CartError extends CartState {
  final String errorMessage;

  const CartError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
