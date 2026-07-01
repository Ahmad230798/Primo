import 'package:dio/dio.dart';

class LoginRequestBody {
  final String phoneNumber;
  final String password;

  LoginRequestBody({required this.phoneNumber, required this.password});
  FormData toFormData() {
    return FormData.fromMap({'phone': phoneNumber, 'password': password});
  }
}
