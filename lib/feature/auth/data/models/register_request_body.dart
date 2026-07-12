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
    final formData = FormData.fromMap({
      'name': name,
      'phone': phone,
      'password': password,
      'password_confirmation': passwordConfirmation,
    });
    if (fcmToken != null && fcmToken!.isNotEmpty) {
      formData.fields.add(MapEntry('fcm_token', fcmToken!));
    }
    return formData;
  }
}
