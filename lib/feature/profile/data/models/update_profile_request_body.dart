import 'dart:io';
import 'package:dio/dio.dart';

class UpdateProfileRequestBody {
  final String name;
  final String? phone;
  final File? avatar;

  UpdateProfileRequestBody({
    required this.name,
    this.phone,
    this.avatar,
  });

  Future<FormData> toFormData() async {
    final Map<String, dynamic> map = {
      '_method': 'PATCH',
      'name': name,
    };
  
    if (phone != null && phone!.isNotEmpty) {
      map['phone'] = phone;
    }
    if (avatar != null) {
      map['avatar'] = await MultipartFile.fromFile(
        avatar!.path,
        filename: avatar!.path.split('/').last,
      );
    }
    return FormData.fromMap(map);
  }
}
