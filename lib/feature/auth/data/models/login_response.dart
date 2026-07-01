import 'package:json_annotation/json_annotation.dart';
// تأكد من مسار الـ UserModel المشترك الذي أنشأناه سابقاً
import '../../../../core/models/user_model.dart'; 

part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse {
  final bool? success;
  final String? message;
  final LoginData? data;

  LoginResponse({this.success, this.message, this.data});

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
}

@JsonSerializable()
class LoginData {
  // جلبنا كائن المستخدم الجاهز بكل تفاصيله 
  final UserModel? user;
  
  @JsonKey(name: 'access_token')
  final String? accessToken;
  
  @JsonKey(name: 'refresh_token')
  final String? refreshToken;
  
  @JsonKey(name: 'expires_in')
  final int? expiresIn;

  LoginData({
    this.user,
    this.accessToken,
    this.refreshToken,
    this.expiresIn,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) => 
      _$LoginDataFromJson(json);
}