import 'package:dio/dio.dart';

class OtpRequestBody {
  final String phone;
  final String otpCode;
  OtpRequestBody({required this.phone, required this.otpCode});
  FormData toFormData() {
    return FormData.fromMap({'phone': phone, 'otp_code': otpCode});
  }
}
