// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forget_password_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ForgetPasswordResponse _$ForgetPasswordResponseFromJson(
  Map<String, dynamic> json,
) => ForgetPasswordResponse(
  success: json['success'] as bool?,
  message: json['message'] as String?,
  data: json['data'] as List<dynamic>?,
);

Map<String, dynamic> _$ForgetPasswordResponseToJson(
  ForgetPasswordResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
};
