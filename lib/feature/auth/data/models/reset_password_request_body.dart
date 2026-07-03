import 'package:dio/dio.dart';

class ResetPassworRequestBody {
  final String phone;
  final String password;
  final String passwordConfirmation;
  ResetPassworRequestBody({
    required this.phone,
    required this.password,
    required this.passwordConfirmation,
  });
  FormData toFormData() {
    return FormData.fromMap({
      'phone': phone,
      'password': password,
      'password_confirmation': passwordConfirmation,
    });
  }
}
