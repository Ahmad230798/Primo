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
  final String discountValue; // 💡 1. أضف هذا المتغير الجديد

  const AdminOffersUIChanged({
    required this.isPercentage,
    required this.fromDate,
    required this.toDate, required this.discountValue,
  });

  @override
List<Object> get props => [isPercentage, fromDate, toDate, discountValue]; // 💡 3. هذا السطر هو السحر الذي سيجبر الشاشة على التحديث
}
