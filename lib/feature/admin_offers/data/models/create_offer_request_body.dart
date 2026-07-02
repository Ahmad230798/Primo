import 'package:dio/dio.dart';

class CreateOfferRequestBody {
  final String variantId;
  final String fromDate;
  final String toDate;
  final String? discountPercentage;
  final String? discountValue;

  CreateOfferRequestBody({
    required this.variantId,
    required this.fromDate,
    required this.toDate,
    this.discountPercentage,
    this.discountValue,
  });

  FormData toFormData() {
    final Map<String, dynamic> map = {
      'variant_id': variantId,
      'from': fromDate,
      'to': toDate,
    };

    // نرسل الحقل المطلق فقط بناءً على خيار الأدمن لمنع أخطاء الـ Validation من لارافيل
    if (discountPercentage != null && discountPercentage!.isNotEmpty) {
      map['discount_percentage'] = discountPercentage;
    } else if (discountValue != null && discountValue!.isNotEmpty) {
      map['discount_value'] = discountValue;
    }

    return FormData.fromMap(map);
  }
}
