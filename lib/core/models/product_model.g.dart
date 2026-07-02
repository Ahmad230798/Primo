// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) => ProductModel(
  id: (json['id'] as num?)?.toInt(),
  categoryId: json['category_id'],
  name: json['name'] as String?,
  image: json['image'] as String?,
  description: json['description'] as String?,
  skuCode: json['sku_code'] as String?,
  isActive: json['is_active'],
  category: json['category'] == null
      ? null
      : CategoryModel.fromJson(json['category'] as Map<String, dynamic>),
  variants: (json['variants'] as List<dynamic>?)
      ?.map((e) => VariantModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ProductModelToJson(ProductModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'category_id': instance.categoryId,
      'name': instance.name,
      'image': instance.image,
      'description': instance.description,
      'sku_code': instance.skuCode,
      'is_active': instance.isActive,
      'category': instance.category,
      'variants': instance.variants,
    };
