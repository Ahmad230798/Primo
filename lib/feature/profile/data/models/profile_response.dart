import 'package:json_annotation/json_annotation.dart';
part 'profile_response.g.dart';

@JsonSerializable()
class ProfileResponse {
  final bool? success;
  final String? message;
  final ProfileData? data;

  ProfileResponse({this.success, this.message, this.data});
  factory ProfileResponse.fromJson(Map<String, dynamic> json) =>
      _$ProfileResponseFromJson(json);
}

@JsonSerializable()
class ProfileData {
  final String? name;
  final String? phone;
  final String? avatar;
  ProfileData({this.name, this.phone, this.avatar});
  factory ProfileData.fromJson(Map<String, dynamic> json) =>
      _$ProfileDataFromJson(json);

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
}
 
  
  // factory ProfileResponse.fromJson(Map<String, dynamic> json) {
  //   return ProfileResponse(
  //     success: json['success'] == true || json['status'] == 200 || json['status'] == true,
  //     message: json['message']?.toString(),
  //     data: json['data'] != null && json['data'] is Map<String, dynamic>
  //         ? UserModel.fromJson(json['data'] as Map<String, dynamic>)
  //         : null,
  //   );
  

