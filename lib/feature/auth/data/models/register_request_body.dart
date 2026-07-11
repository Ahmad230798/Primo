import 'package:dio/dio.dart';

class RegisterRequestBody {
  final String name;
  final String phone;
  final String password;
  final String passwordConfirmation;
  final String? fcmToken;

  RegisterRequestBody({
    required this.name,
    required this.phone,
    required this.password,
    required this.passwordConfirmation,
    this.fcmToken,
  });

  FormData toFormData() {
    final map = <String, dynamic>{
      'name': name,
      'phone': phone,
      'password': password,
      'password_confirmation': passwordConfirmation,
    };
    if (fcmToken != null && fcmToken!.isNotEmpty) {
      map['fcm_token'] = fcmToken;
    }
    return FormData.fromMap(map);
  }
}
