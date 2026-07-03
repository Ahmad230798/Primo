import 'package:dio/dio.dart';

class ForgetPasswordRequestBody {
  final String phone;

  ForgetPasswordRequestBody({required this.phone});

  FormData toFormData() {
    return FormData.fromMap({
      'phone': phone,
    });
  }
}