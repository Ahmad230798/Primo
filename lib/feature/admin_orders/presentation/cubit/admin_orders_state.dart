import 'package:equatable/equatable.dart';
import 'package:primo/core/models/order_model.dart';

abstract class AdminOrdersState extends Equatable {
  const AdminOrdersState();

  @override
  List<Object?> get props => [];
}

class AdminOrdersInitial extends AdminOrdersState {}

class AdminOrdersLoading extends AdminOrdersState {}

class AdminOrdersLoaded extends AdminOrdersState {
  final List<OrderModel> orders;
  final String activeFilter;

  const AdminOrdersLoaded(this.orders, {this.activeFilter = 'all'});

  @override
  List<Object?> get props => [orders, activeFilter];
}

class AdminOrderDetailsLoaded extends AdminOrdersState {
  final OrderModel order;

  const AdminOrderDetailsLoaded(this.order);

  @override
  List<Object?> get props => [order];
}

class AdminOrdersError extends AdminOrdersState {
  final String errorMessage;

  const AdminOrdersError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

class AdminOrderStatusUpdating extends AdminOrdersState {
  final int orderId;

  const AdminOrderStatusUpdating(this.orderId);

  @override
  List<Object?> get props => [orderId];
}

class AdminOrderStatusSuccess extends AdminOrdersState {
  final String message;

  const AdminOrderStatusSuccess(this.message);

  @override
  List<Object?> get props => [message];
}
