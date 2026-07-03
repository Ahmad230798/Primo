import 'package:equatable/equatable.dart';
import 'package:primo/feature/auth/data/models/forget_password_response.dart';

sealed class ResetPasswordState extends Equatable {
  const ResetPasswordState();

  @override
  List<Object?> get props => [];
}

final class ResetPasswordInitial extends ResetPasswordState {}

final class ResetPasswordLoading extends ResetPasswordState {}

final class ResetPasswordSuccess extends ResetPasswordState {
  final ForgetPasswordResponse forgetPasswordResponse;
  const ResetPasswordSuccess(this.forgetPasswordResponse);

  @override
  List<Object?> get props => [forgetPasswordResponse];
}

final class ResetPassowrdError extends ResetPasswordState {
  final String error;
  const ResetPassowrdError({required this.error});

  @override
  List<Object?> get props => [error];
}

final class ResetPasswordChangeUI extends ResetPasswordState {
  final bool isPasswordObscure;
  final bool isPasswordConfirmationObscure;
  const ResetPasswordChangeUI({
    this.isPasswordObscure = true,
    this.isPasswordConfirmationObscure = true,
  });

  @override
  List<Object?> get props => [isPasswordObscure, isPasswordConfirmationObscure];
}
