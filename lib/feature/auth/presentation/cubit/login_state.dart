import 'package:equatable/equatable.dart';
import '../../data/models/login_response.dart';

sealed class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

final class LoginInitial extends LoginState {}

final class LoginLoading extends LoginState {}

final class LoginSuccess extends LoginState {
  final LoginResponse loginResponse;
  const LoginSuccess(this.loginResponse);

  @override
  List<Object?> get props => [loginResponse];
}

final class LoginError extends LoginState {
  final String error;
  const LoginError({required this.error});
  @override
  List<Object?> get props => [error];
}

// حالة خاصة لتحديث الواجهة (مثل إظهار/إخفاء كلمة المرور)
final class LoginChangeUI extends LoginState {
  final bool isPasswordObscure;
  const LoginChangeUI({this.isPasswordObscure = true});

  @override
  List<Object?> get props => [isPasswordObscure];
}

// أضف هذه الحالة مع باقي الحالات
final class LoginRequiresOtp extends LoginState {
  final String message;
  const LoginRequiresOtp(this.message);

  @override
  List<Object?> get props => [message];
}
