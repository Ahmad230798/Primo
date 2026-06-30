// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_response_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterResponseBody _$RegisterResponseBodyFromJson(
  Map<String, dynamic> json,
) => RegisterResponseBody(
  success: json['success'] as bool?,
  message: json['message'] as String?,
  data: json['data'] == null
      ? null
      : RegisterData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$RegisterResponseBodyToJson(
  RegisterResponseBody instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
};

RegisterData _$RegisterDataFromJson(Map<String, dynamic> json) => RegisterData(
  otpRequired: json['otp_required'] as bool?,
  accountExists: json['account_exists'] as bool?,
  message: json['message'] as String?,
);

Map<String, dynamic> _$RegisterDataToJson(RegisterData instance) =>
    <String, dynamic>{
      'otp_required': instance.otpRequired,
      'account_exists': instance.accountExists,
      'message': instance.message,
    };
