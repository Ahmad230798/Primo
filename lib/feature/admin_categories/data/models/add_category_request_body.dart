import 'dart:io';
import 'package:dio/dio.dart';

class AddCategoryRequestBody {
  final String name;
  final File image;

  AddCategoryRequestBody({required this.name, required this.image});

  Future<FormData> toFormData() async {
    return FormData.fromMap({
      'name': name,
      // تحويل الملف إلى MultipartFile لرفعه للسيرفر
      'image': await MultipartFile.fromFile(
        image.path,
        filename: image.path.split('/').last,
      ),
    });
  }
}
