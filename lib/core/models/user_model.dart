import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final int? id;
  final String? name;
  final String? phone;
  
  // أضفت هذه الحقول بناءً على الرد الذي أرسلته لي من السيرفر
  @JsonKey(name: 'phone_verified_at')
  final String? phoneVerifiedAt;
  
  @JsonKey(name: 'is_admin')
  final int? isAdmin;
  
  final String? avatar;

  UserModel({
    this.id,
    this.name,
    this.phone,
    this.phoneVerifiedAt,
    this.isAdmin,
    this.avatar,
  });

  String? get fullAvatarUrl {
    if (avatar == null || avatar!.isEmpty) return null;
    if (avatar!.startsWith('http://') || avatar!.startsWith('https://')) {
      return avatar;
    }
    const baseUrl = 'https://api.primo-market.cloud';
    if (avatar!.startsWith('/')) {
      return '$baseUrl$avatar';
    }
    return '$baseUrl/$avatar';
  }

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}