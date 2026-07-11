import 'dart:io';
import 'package:dio/dio.dart';

class UpdateCategoryRequestBody {
  final String name;
  final File? image;

  UpdateCategoryRequestBody({required this.name, this.image});

  Future<FormData> toFormData() async {
    final map = <String, dynamic>{
      '_method': 'PUT',
      'name': name,
    };
    if (image != null) {
      map['image'] = await MultipartFile.fromFile(
        image!.path,
        filename: image!.path.split('/').last,
      );
    }
    return FormData.fromMap(map);
  }
}
