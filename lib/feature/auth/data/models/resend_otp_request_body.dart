import 'package:dio/dio.dart';

class ResendOtpRequestBody {
  final String phone;
  final String type; // 'register' أو 'reset_password'

  ResendOtpRequestBody({
    required this.phone,
    required this.type,
  });

  FormData toFormData() {
    return FormData.fromMap({
      'phone': phone,
      'type': type,
    });
  }
}