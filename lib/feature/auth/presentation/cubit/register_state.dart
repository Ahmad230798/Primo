import 'package:equatable/equatable.dart';
import 'package:primo/feature/auth/data/models/register_response_body.dart';

sealed class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object> get props => [];
}

final class RegisterInitial extends RegisterState {}

final class RegisterLoading extends RegisterState {}

final class RegisterSuccess extends RegisterState {
  final RegisterResponseBody registerResponse;

  const RegisterSuccess(this.registerResponse);

  @override
  // هنا نخبر Equatable أن يقارن بناءً على محتوى الاستجابة
  List<Object> get props => [registerResponse];
}

final class RegisterError extends RegisterState {
  final String error;

  const RegisterError({required this.error});

  @override
  // هنا السحر: المقارنة ستتم بناءً على نص رسالة الخطأ فقط
  List<Object> get props => [error];
}

// أضف هذه الحالة إلى ملف register_state.dart
final class RegisterChangeUI extends RegisterState {
  final bool isPasswordObscure;
  final bool isConfirmPasswordObscure;
  final bool isTermsAccepted;

  const RegisterChangeUI({
    required this.isPasswordObscure,
    required this.isConfirmPasswordObscure,
    required this.isTermsAccepted,
  });

  @override
  // نمرر المتغيرات هنا لكي يقوم Equatable بمقارنتها والسماح بتحديث الشاشة
  List<Object> get props => [
    isPasswordObscure,
    isConfirmPasswordObscure,
    isTermsAccepted,
  ];
}
