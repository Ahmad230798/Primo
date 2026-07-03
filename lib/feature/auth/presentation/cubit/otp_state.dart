import 'package:equatable/equatable.dart';
import 'package:primo/feature/auth/data/models/forget_password_response.dart';
import 'package:primo/feature/auth/data/models/otp_response.dart';

sealed class OtpState extends Equatable {
  const OtpState();
  @override
  List<Object?> get props => [];
}

final class OtpInitial extends OtpState {}

final class OtpLoading extends OtpState {}

final class OtpSuccess extends OtpState {
  final OtpResponse otpResponse;
  const OtpSuccess(this.otpResponse);

  @override
  List<Object?> get props => [otpResponse];
}

final class OtpError extends OtpState {
  final String error;
  const OtpError({required this.error});

  @override
  List<Object?> get props => [error];
}

// أضف هذه الحالة في أسفل ملف otp_state.dart
final class OtpForgotPasswordSuccess extends OtpState {
  final ForgetPasswordResponse response;
  const OtpForgotPasswordSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

final class OtpTimerTick extends OtpState {
  final int countdown;
  const OtpTimerTick(this.countdown);

  @override
  List<Object?> get props => [countdown]; // ضروري لكي يعيد الـ BlocBuilder الرسم عند تغير الرقم
}

final class ResendOtpLoading extends OtpState {}

// حالة نجاح إعادة إرسال الكود من السيرفر لإظهار رسالة للمستخدم
final class ResendOtpSuccess extends OtpState {
  final String message;
  const ResendOtpSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}
