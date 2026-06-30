import 'package:dio/dio.dart';

class RegisterRequestBody {
  final String name;
  final String phone;
  final String password;
  final String passwordConfirmation;
  RegisterRequestBody({
    required this.name,
    required this.phone,
    required this.password,
    required this.passwordConfirmation,
  });
  FormData toFormData() {
    return FormData.fromMap({
      'name': name,
      'phone': phone,
      'password': password,
      'password_confirmation': passwordConfirmation,
    });
  }
}
