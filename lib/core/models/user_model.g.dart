// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String?,
  phone: json['phone'] as String?,
  phoneVerifiedAt: json['phone_verified_at'] as String?,
  isAdmin: (json['is_admin'] as num?)?.toInt(),
  avatar: json['avatar'] as String?,
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'phone': instance.phone,
  'phone_verified_at': instance.phoneVerifiedAt,
  'is_admin': instance.isAdmin,
  'avatar': instance.avatar,
};
