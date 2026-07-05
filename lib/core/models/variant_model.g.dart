// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'variant_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VariantModel _$VariantModelFromJson(Map<String, dynamic> json) => VariantModel(
  id: (json['id'] as num?)?.toInt(),
  productId: (json['product_id'] as num?)?.toInt(),
  price: json['price'] as String?,
  stock: (json['stock'] as num?)?.toInt(),
  property: json['property'] as String?,
  isActive: (json['is_active'] as num?)?.toInt(),
  hasActiveOffer: json['has_active_offer'] as bool?,
  offerId: (json['offer_id'] as num?)?.toInt(),
  discountAmount: json['discount_amount'],
  newPrice: json['new_price'],
);

Map<String, dynamic> _$VariantModelToJson(VariantModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'product_id': instance.productId,
      'price': instance.price,
      'stock': instance.stock,
      'property': instance.property,
      'is_active': instance.isActive,
      'has_active_offer': instance.hasActiveOffer,
      'offer_id': instance.offerId,
      'discount_amount': instance.discountAmount,
      'new_price': instance.newPrice,
    };
