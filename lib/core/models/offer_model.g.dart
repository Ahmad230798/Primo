// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element

part of 'offer_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OfferModel _$OfferModelFromJson(Map<String, dynamic> json) => OfferModel(
  id: (json['id'] as num?)?.toInt(),
  from: json['from'] as String?,
  to: json['to'] as String?,
  discountValue: json['discount_value'],
  productName: json['product_name'] as String?,
  image: json['image'] as String?,
  property: json['property'] as String?,
  variantPrice: json['variant_price'],
  variantStock: json['variant_stock'],
);

Map<String, dynamic> _$OfferModelToJson(OfferModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'from': instance.from,
      'to': instance.to,
      'discount_value': instance.discountValue,
      'product_name': instance.productName,
      'image': instance.image,
      'property': instance.property,
      'variant_price': instance.variantPrice,
      'variant_stock': instance.variantStock,
    };
