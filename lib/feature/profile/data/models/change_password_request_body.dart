import 'package:dio/dio.dart';

class ChangePasswordRequestBody {
  final String currentPassword;
  final String newPassword;
  final String newPasswordConfirmation;

  ChangePasswordRequestBody({
    required this.currentPassword,
    required this.newPassword,
    required this.newPasswordConfirmation,
  });

  FormData toFormData() {
    return FormData.fromMap({
      'current_password': currentPassword,
      'new_password': newPassword,
      'new_password_confirmation': newPasswordConfirmation,
    });
  }
}
