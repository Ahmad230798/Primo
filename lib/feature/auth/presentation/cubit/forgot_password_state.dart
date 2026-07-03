import 'package:equatable/equatable.dart';
import 'package:primo/feature/auth/data/models/forget_password_response.dart';

sealed class ForgotPasswordState extends Equatable {
  const ForgotPasswordState();

  @override
  List<Object?> get props => [];
}

final class ForgotPasswordInitial extends ForgotPasswordState {}

final class ForgotPasswordLoading extends ForgotPasswordState {}

final class ForgotPasswordSuccess extends ForgotPasswordState {
  final ForgetPasswordResponse response;
  const ForgotPasswordSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

final class ForgotPasswordError extends ForgotPasswordState {
  final String error;
  const ForgotPasswordError({required this.error});

  @override
  List<Object?> get props => [error];
}
