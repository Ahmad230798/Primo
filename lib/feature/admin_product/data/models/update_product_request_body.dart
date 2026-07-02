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
    final Map<String, dynamic> map = {
      '_method': 'PUT', // ضروري جداً لـ Laravel عند رفع صور مع التعديل
      'category_id': categoryId,
      'name': name,
      'description': description,
      'is_active': isActive.toString(),
    };

    if (image != null) {
      map['image'] = await MultipartFile.fromFile(
        image!.path,
        filename: image!.path.split('/').last,
      );
    }

    // 1. إضافة الأنواع المراد تحديثها
    for (int i = 0; i < updateVariants.length; i++) {
      map['update_variants[$i][id]'] = updateVariants[i].id.toString();
      map['update_variants[$i][property]'] = updateVariants[i].property;
      map['update_variants[$i][price]'] = updateVariants[i].price;
      map['update_variants[$i][stock]'] = updateVariants[i].stock;
      map['update_variants[$i][is_active]'] = updateVariants[i].isActive
          .toString();
    }

    // 2. إضافة الأنواع الجديدة
    for (int i = 0; i < addVariants.length; i++) {
      map['add_variants[$i][property]'] = addVariants[i].property;
      map['add_variants[$i][price]'] = addVariants[i].price;
      map['add_variants[$i][stock]'] = addVariants[i].stock;
    }

    return FormData.fromMap(map);
  }
}
