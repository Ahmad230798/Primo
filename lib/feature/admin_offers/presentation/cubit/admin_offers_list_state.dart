import 'package:equatable/equatable.dart';
import 'package:primo/core/models/offer_model.dart';

sealed class AdminOffersListState extends Equatable {
  const AdminOffersListState();

  @override
  List<Object?> get props => [];
}

final class AdminOffersListInitial extends AdminOffersListState {}

final class AdminOffersListLoading extends AdminOffersListState {}

final class AdminOffersListLoaded extends AdminOffersListState {
  final List<OfferModel> offers;
  const AdminOffersListLoaded(this.offers);

  @override
  List<Object?> get props => [offers];
}

final class AdminOffersListError extends AdminOffersListState {
  final String message;
  const AdminOffersListError(this.message);

  @override
  List<Object?> get props => [message];
}

final class AdminOfferDeleteSuccess extends AdminOffersListState {
  final String message;
  const AdminOfferDeleteSuccess(this.message);

  @override
  List<Object?> get props => [message];
}
