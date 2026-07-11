import 'dart:io';
import 'package:dio/dio.dart';

class UpdateOfferRequestBody {
  final String variantId;
  final String fromDate;
  final String toDate;
  final String? discountPercentage;
  final String? discountValue;
  final File? image;

  UpdateOfferRequestBody({
    required this.variantId,
    required this.fromDate,
    required this.toDate,
    this.discountPercentage,
    this.discountValue,
    this.image,
  });

  Future<FormData> toFormData() async {
    final Map<String, dynamic> map = {
      '_method': 'PUT',
      'variant_id': variantId,
      'from': fromDate,
      'to': toDate,
    };

    if (discountPercentage != null && discountPercentage!.isNotEmpty) {
      map['discount_percentage'] = discountPercentage;
    } else if (discountValue != null && discountValue!.isNotEmpty) {
      map['discount_value'] = discountValue;
    }

    if (image != null) {
      map['image'] = await MultipartFile.fromFile(
        image!.path,
        filename: image!.path.split('/').last,
      );
    }

    return FormData.fromMap(map);
  }
}
