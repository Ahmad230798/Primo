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
    final map = <String, dynamic>{
      'phone': phoneNumber,
      'password': password,
    };
    if (fcmToken != null && fcmToken!.isNotEmpty) {
      map['fcm_token'] = fcmToken;
    }
    return FormData.fromMap(map);
  }
}
