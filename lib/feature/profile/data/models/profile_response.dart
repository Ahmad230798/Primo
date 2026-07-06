import 'package:primo/core/models/user_model.dart';

class ProfileResponse {
  final bool? success;
  final String? message;
  final UserModel? data;

  ProfileResponse({this.success, this.message, this.data});

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      success: json['success'] == true || json['status'] == 200 || json['status'] == true,
      message: json['message']?.toString(),
      data: json['data'] != null && json['data'] is Map<String, dynamic>
          ? UserModel.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}
