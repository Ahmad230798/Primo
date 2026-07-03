import 'package:json_annotation/json_annotation.dart';

part 'forget_password_response.g.dart';

@JsonSerializable()
class ForgetPasswordResponse {
  final bool? success;
  final String? message;
  final List<dynamic>? data; 

  ForgetPasswordResponse({this.success, this.message, this.data});

  factory ForgetPasswordResponse.fromJson(Map<String, dynamic> json) =>
      _$ForgetPasswordResponseFromJson(json);
}
