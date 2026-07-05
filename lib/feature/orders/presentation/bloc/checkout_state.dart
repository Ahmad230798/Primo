import 'package:equatable/equatable.dart';
import 'package:primo/core/models/order_model.dart';

sealed class CheckoutState extends Equatable {
  const CheckoutState();

  @override
  List<Object?> get props => [];
}

final class CheckoutInitial extends CheckoutState {}

final class CheckoutPriceLoading extends CheckoutState {}

final class CheckoutUpdated extends CheckoutState {
  final int selectedDeliveryMethod;
  final String? selectedAddressId;
  final OrderPriceModel? priceModel;

  const CheckoutUpdated({
    required this.selectedDeliveryMethod,
    this.selectedAddressId,
    this.priceModel,
  });

  @override
  List<Object?> get props => [selectedDeliveryMethod, selectedAddressId, priceModel];
}

final class CheckoutLoading extends CheckoutState {}

final class CheckoutSuccess extends CheckoutState {
  final OrderModel? order;
  const CheckoutSuccess({this.order});
  @override
  List<Object?> get props => [order];
}

final class CheckoutError extends CheckoutState {
  final String message;

  const CheckoutError(this.message);

  @override
  List<Object?> get props => [message];
}