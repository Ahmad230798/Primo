// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_offer_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateOfferResponse _$CreateOfferResponseFromJson(Map<String, dynamic> json) =>
    CreateOfferResponse(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : OfferData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CreateOfferResponseToJson(
  CreateOfferResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
};

OfferData _$OfferDataFromJson(Map<String, dynamic> json) => OfferData(
  id: (json['id'] as num?)?.toInt(),
  variantId: json['variant_id'],
  from: json['from'] as String?,
  to: json['to'] as String?,
  discountPercentage: json['discount_percentage'] as String?,
  discountValue: json['discount_value'],
);

Map<String, dynamic> _$OfferDataToJson(OfferData instance) => <String, dynamic>{
  'id': instance.id,
  'variant_id': instance.variantId,
  'from': instance.from,
  'to': instance.to,
  'discount_percentage': instance.discountPercentage,
  'discount_value': instance.discountValue,
};
