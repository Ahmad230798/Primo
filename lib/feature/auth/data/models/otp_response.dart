import 'package:json_annotation/json_annotation.dart';
import '../../../../core/models/user_model.dart'; // مسار ملف المستخدم المشترك

part 'otp_response.g.dart';

@JsonSerializable()
class OtpResponse {
  final bool? success;
  final String? message;
  final OtpData? data;

  OtpResponse({this.success, this.message, this.data});

  factory OtpResponse.fromJson(Map<String, dynamic> json) =>
      _$OtpResponseFromJson(json);
}

@JsonSerializable()
class OtpData {
  // استخدمنا الـ UserModel المشترك هنا
  final UserModel? user; 
  
  @JsonKey(name: 'access_token')
  final String? accessToken;
  
  @JsonKey(name: 'refresh_token')
  final String? refreshToken;
  
  final String? message;

  OtpData({this.user, this.accessToken, this.refreshToken, this.message});

  factory OtpData.fromJson(Map<String, dynamic> json) => _$OtpDataFromJson(json);
}