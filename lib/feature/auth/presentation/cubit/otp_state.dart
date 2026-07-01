import 'package:equatable/equatable.dart';
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
