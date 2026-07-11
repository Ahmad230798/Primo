import 'package:json_annotation/json_annotation.dart';
part 'register_response_body.g.dart';

@JsonSerializable()
class RegisterResponseBody {
  final bool? success;
  final String? message;
  final RegisterData? data;
  RegisterResponseBody({this.success, this.message, this.data});
  factory RegisterResponseBody.fromJson(Map<String, dynamic> json) =>
      _$RegisterResponseBodyFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterResponseBodyToJson(this);
}

@JsonSerializable()
class RegisterData {
  @JsonKey(name: 'otp_required')
  final bool? otpRequired;

  @JsonKey(name: 'account_exists')
  final bool? accountExists;

  final String? message;

  RegisterData({this.otpRequired, this.accountExists, this.message});

  factory RegisterData.fromJson(Map<String, dynamic> json) =>
      _$RegisterDataFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterDataToJson(this);
}
