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
    final formData = FormData();

    formData.fields.add(MapEntry('category_id', categoryId));
    formData.fields.add(MapEntry('name', name));
    formData.fields.add(MapEntry('description', description));

    if (image != null) {
      formData.files.add(MapEntry(
        'image',
        await MultipartFile.fromFile(
          image!.path,
          filename: image!.path.split('/').last,
        ),
      ));
    }

    for (int i = 0; i < variants.length; i++) {
      formData.fields.add(MapEntry('variants[$i][property]', variants[i].property));
      formData.fields.add(MapEntry('variants[$i][price]', variants[i].price));
      formData.fields.add(MapEntry('variants[$i][stock]', variants[i].stock.toString()));
    }

    return formData;
  }
}
