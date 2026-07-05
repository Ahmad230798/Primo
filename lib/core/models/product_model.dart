import 'package:json_annotation/json_annotation.dart';
import 'category_model.dart';
import 'variant_model.dart';

part 'product_model.g.dart';

@JsonSerializable()
class ProductModel {
  final int? id;
  @JsonKey(name: 'category_id')
  final dynamic categoryId;
  @JsonKey(name: 'category_name')
  final String? categoryName;
  final String? name;
  final String? image;
  final String? description;
  final dynamic price;
  @JsonKey(name: 'sku_code')
  final String? skuCode;
  @JsonKey(name: 'is_active')
  final dynamic isActive;
  final CategoryModel? category;
  final List<VariantModel>? variants;
  final dynamic ratings;
  @JsonKey(name: 'ratings_count')
  final int? ratingsCount;
  @JsonKey(name: 'is_favorite')
  final bool? isFavorite;

  ProductModel({
    this.id,
    this.categoryId,
    this.categoryName,
    this.name,
    this.image,
    this.description,
    this.price,
    this.skuCode,
    this.isActive,
    this.category,
    this.variants,
    this.ratings,
    this.ratingsCount,
    this.isFavorite,
  });

  String? get fullImageUrl {
    if (image == null || image!.trim().isEmpty) return null;
    if (image!.startsWith('http://') || image!.startsWith('https://')) {
      return image;
    }
    const baseUrl = 'https://api.primo-market.cloud';
    if (image!.startsWith('/')) {
      return '$baseUrl$image';
    }
    return '$baseUrl/$image';
  }

  String get displayPrice {
    if (price != null && price.toString().trim().isNotEmpty) {
      return price.toString();
    }
    if (variants != null && variants!.isNotEmpty) {
      final firstVar = variants!.first;
      if (firstVar.newPrice != null && firstVar.newPrice.toString().isNotEmpty) {
        return firstVar.newPrice.toString();
      }
      if (firstVar.price != null && firstVar.price!.trim().isNotEmpty) {
        return firstVar.price!;
      }
    }
    return '0';
  }

  String? get title => name;
  String? get unit {
    if (variants != null && variants!.isNotEmpty) {
      return variants!.first.property ?? 'قطعة';
    }
    return 'قطعة';
  }
  int? get stock {
    if (variants != null && variants!.isNotEmpty && variants!.first.stock != null) {
      return variants!.first.stock;
    }
    return 10;
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductModelToJson(this);
}
