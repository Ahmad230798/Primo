import 'package:equatable/equatable.dart';

sealed class AdminOffersState extends Equatable {
  const AdminOffersState();
  @override
  List<Object?> get props => [];
}

final class AdminOffersInitial extends AdminOffersState {}

final class AdminOffersLoading extends AdminOffersState {}

final class AdminOffersSuccess extends AdminOffersState {
  final String message;
  const AdminOffersSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

final class AdminOffersError extends AdminOffersState {
  final String error;
  const AdminOffersError(this.error);
  @override
  List<Object?> get props => [error];
}

final class AdminOffersUIChanged extends AdminOffersState {
  final bool isPercentage;
  final String fromDate;
  final String toDate;

  const AdminOffersUIChanged({
    required this.isPercentage,
    required this.fromDate,
    required this.toDate,
  });

  @override
  List<Object?> get props => [isPercentage, fromDate, toDate];
}
