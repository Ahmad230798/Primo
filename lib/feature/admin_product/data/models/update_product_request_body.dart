import 'dart:io';
import 'package:dio/dio.dart';
import 'variant_request_model.dart';

class UpdateProductRequestBody {
  final String categoryId;
  final String name;
  final String description;
  final int isActive; // 0 أو 1
  final File? image;
  final List<VariantRequestModel>
  updateVariants; // الأنواع الموجودة مسبقاً (تم تعديلها)
  final List<VariantRequestModel> addVariants; // الأنواع الجديدة كلياً

  UpdateProductRequestBody({
    required this.categoryId,
    required this.name,
    required this.description,
    required this.isActive,
    this.image,
    required this.updateVariants,
    required this.addVariants,
  });

  Future<FormData> toFormData() async {
    final formData = FormData();

    formData.fields.add(const MapEntry('_method', 'PUT'));
    formData.fields.add(MapEntry('category_id', categoryId));
    formData.fields.add(MapEntry('name', name));
    formData.fields.add(MapEntry('description', description));
    formData.fields.add(MapEntry('is_active', isActive.toString()));

    if (image != null) {
      formData.files.add(MapEntry(
        'image',
        await MultipartFile.fromFile(
          image!.path,
          filename: image!.path.split('/').last,
        ),
      ));
    }

    for (int i = 0; i < updateVariants.length; i++) {
      if (updateVariants[i].id != null) {
        formData.fields.add(MapEntry('update_variants[$i][id]', updateVariants[i].id.toString()));
      }
      formData.fields.add(MapEntry('update_variants[$i][property]', updateVariants[i].property));
      formData.fields.add(MapEntry('update_variants[$i][price]', updateVariants[i].price));
      formData.fields.add(MapEntry('update_variants[$i][stock]', updateVariants[i].stock.toString()));
      formData.fields.add(MapEntry('update_variants[$i][is_active]', updateVariants[i].isActive.toString()));
      formData.fields.add(MapEntry('update_variants[$i][is_dollar]', updateVariants[i].isDollar.toString()));
    }

    for (int i = 0; i < addVariants.length; i++) {
      formData.fields.add(MapEntry('add_variants[$i][property]', addVariants[i].property));
      formData.fields.add(MapEntry('add_variants[$i][price]', addVariants[i].price));
      formData.fields.add(MapEntry('add_variants[$i][stock]', addVariants[i].stock.toString()));
      formData.fields.add(MapEntry('add_variants[$i][is_dollar]', addVariants[i].isDollar.toString()));
    }

    return formData;
  }
}
