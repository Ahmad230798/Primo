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

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
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
// داخل كلاس البيانات في ملف LoginResponse

@JsonKey(name: 'otp_required')
final bool? otpRequired;

@JsonKey(name: 'phone_verified')
final bool? phoneVerified;

// يمكنك أيضاً إضافة رسالة الـ data الداخلية إذا أردت
@JsonKey(name: 'message')
final String? innerMessage;
  LoginData({
    this.user,
    this.accessToken,
    this.refreshToken,
    this.expiresIn, this.otpRequired, this.phoneVerified, this.innerMessage,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) => 
      _$LoginDataFromJson(json);

  Map<String, dynamic> toJson() => _$LoginDataToJson(this);
}