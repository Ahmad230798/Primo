import 'dart:io';
import 'package:dio/dio.dart';
import 'variant_request_model.dart';

class AddProductRequestBody {
  final String categoryId;
  final String name;
  final String description;
  final File? image;
  final List<VariantRequestModel> variants;

  AddProductRequestBody({
    required this.categoryId,
    required this.name,
    required this.description,
    this.image,
    required this.variants,
  });

  Future<FormData> toFormData() async {
    final Map<String, dynamic> map = {
      'category_id': categoryId,
      'name': name,
      'description': description,
    };

    if (image != null) {
      map['image'] = await MultipartFile.fromFile(
        image!.path,
        filename: image!.path.split('/').last,
      );
    }

    // خدعة التعامل مع المصفوفات في الـ FormData لـ Laravel
    for (int i = 0; i < variants.length; i++) {
      map['variants[$i][property]'] = variants[i].property;
      map['variants[$i][price]'] = variants[i].price;
      map['variants[$i][stock]'] = variants[i].stock;
    }

    return FormData.fromMap(map);
  }
}
