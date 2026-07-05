import 'package:equatable/equatable.dart';
import 'package:primo/core/models/order_model.dart';

abstract class OrdersState extends Equatable {
  const OrdersState();

  @override
  List<Object?> get props => [];
}

class OrdersInitial extends OrdersState {}

class OrdersLoading extends OrdersState {}

class OrdersLoaded extends OrdersState {
  final List<OrderModel> orders;
  const OrdersLoaded(this.orders);
  @override
  List<Object?> get props => [orders];
}

class SingleOrderLoaded extends OrdersState {
  final OrderModel order;
  const SingleOrderLoaded(this.order);
  @override
  List<Object?> get props => [order];
}

class OrderRatingSuccess extends OrdersState {
  final String message;
  const OrderRatingSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

class OrdersError extends OrdersState {
  final String errorMessage;
  const OrdersError(this.errorMessage);
  @override
  List<Object?> get props => [errorMessage];
}
