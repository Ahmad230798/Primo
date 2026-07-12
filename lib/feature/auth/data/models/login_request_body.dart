import 'package:dio/dio.dart';

class LoginRequestBody {
  final String phoneNumber;
  final String password;
  final String? fcmToken;

  LoginRequestBody({
    required this.phoneNumber,
    required this.password,
    this.fcmToken,
  });

  FormData toFormData() {
    final formData = FormData.fromMap({
      'phone': phoneNumber,
      'password': password,
    });
    if (fcmToken != null && fcmToken!.isNotEmpty) {
      formData.fields.add(MapEntry('fcm_token', fcmToken!));
    }
    return formData;
  }
}
