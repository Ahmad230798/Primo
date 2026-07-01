// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'otp_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OtpResponse _$OtpResponseFromJson(Map<String, dynamic> json) => OtpResponse(
  success: json['success'] as bool?,
  message: json['message'] as String?,
  data: json['data'] == null
      ? null
      : OtpData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$OtpResponseToJson(OtpResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
    };

OtpData _$OtpDataFromJson(Map<String, dynamic> json) => OtpData(
  user: json['user'] == null
      ? null
      : UserModel.fromJson(json['user'] as Map<String, dynamic>),
  accessToken: json['access_token'] as String?,
  refreshToken: json['refresh_token'] as String?,
  message: json['message'] as String?,
);

Map<String, dynamic> _$OtpDataToJson(OtpData instance) => <String, dynamic>{
  'user': instance.user,
  'access_token': instance.accessToken,
  'refresh_token': instance.refreshToken,
  'message': instance.message,
};
