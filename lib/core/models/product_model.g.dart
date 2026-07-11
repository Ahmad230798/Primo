// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) => ProductModel(
  id: (json['id'] as num?)?.toInt(),
  categoryId: json['category_id'],
  categoryName: json['category_name'] as String?,
  name: json['name'] as String?,
  image: json['image'] as String?,
  description: json['description'] as String?,
  price: json['price'],
  skuCode: json['sku_code'] as String?,
  isActive: json['is_active'],
  category: json['category'] == null
      ? null
      : CategoryModel.fromJson(json['category'] as Map<String, dynamic>),
  variants: (json['variants'] as List<dynamic>?)
      ?.map((e) => VariantModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  ratings: json['ratings'],
  ratingsCount: (json['ratings_count'] as num?)?.toInt(),
  isFavorite: json['is_favorite'] as bool?,
);

Map<String, dynamic> _$ProductModelToJson(ProductModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'category_id': instance.categoryId,
      'category_name': instance.categoryName,
      'name': instance.name,
      'image': instance.image,
      'description': instance.description,
      'price': instance.price,
      'sku_code': instance.skuCode,
      'is_active': instance.isActive,
      'category': instance.category,
      'variants': instance.variants,
      'ratings': instance.ratings,
      'ratings_count': instance.ratingsCount,
      'is_favorite': instance.isFavorite,
    };
