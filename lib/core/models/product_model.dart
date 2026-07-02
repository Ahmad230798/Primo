import 'package:json_annotation/json_annotation.dart';
import 'category_model.dart';
import 'variant_model.dart';

part 'product_model.g.dart';

@JsonSerializable()
class ProductModel {
  final int? id;
  @JsonKey(name: 'category_id')
  final dynamic categoryId;
  final String? name;
  final String? image;
  final String? description;
  @JsonKey(name: 'sku_code')
  final String? skuCode;
  @JsonKey(name: 'is_active')
  final dynamic isActive; // السيرفر قد يرجعه كـ int أو bool
  final CategoryModel? category;
  final List<VariantModel>? variants;

  ProductModel({
    this.id,
    this.categoryId,
    this.name,
    this.image,
    this.description,
    this.skuCode,
    this.isActive,
    this.category,
    this.variants,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);
}
