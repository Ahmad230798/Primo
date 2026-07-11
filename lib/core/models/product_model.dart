import 'package:json_annotation/json_annotation.dart';
import 'category_model.dart';
import 'variant_model.dart';

part 'product_model.g.dart';

@JsonSerializable(createFactory: false)
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
  final String? directLowestPrice;
  final int? directTotalStock;

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
    this.directLowestPrice,
    this.directTotalStock,
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

  String get lowestPrice {
    if (directLowestPrice != null && directLowestPrice!.trim().isNotEmpty && directLowestPrice != "null") {
      return directLowestPrice!;
    }
    if (variants == null || variants!.isEmpty) return "0";
    var prices = variants!.map((v) => double.tryParse(v.price.toString()) ?? 0.0).toList();
    prices.sort();
    return prices.first.toStringAsFixed(0);
  }

  String get displayPrice => lowestPrice;

  String? get title => name;
  String? get unit {
    if (variants != null && variants!.isNotEmpty) {
      return variants!.first.property ?? 'قطعة';
    }
    return 'قطعة';
  }
  int? get stock => totalStock;

  int get totalStock {
    if (directTotalStock != null) {
      return directTotalStock!;
    }
    if (variants == null || variants!.isEmpty) return 0;
    return variants!.fold(0, (sum, item) => sum + (int.tryParse(item.stock.toString()) ?? 0));
  }

  bool get isActiveBool =>
      isActive == true ||
      isActive == 1 ||
      isActive == '1' ||
      isActive?.toString().toLowerCase() == 'true';

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    int? parseInt(dynamic val) {
      if (val == null) return null;
      if (val is int) return val;
      if (val is num) return val.toInt();
      return int.tryParse(val.toString());
    }

    return ProductModel(
      id: parseInt(json['id']),
      categoryId: json['category_id'],
      categoryName: json['category_name']?.toString() ??
          (json['category'] is Map ? json['category']['name']?.toString() : null),
      name: json['name']?.toString(),
      image: json['image']?.toString(),
      description: json['description']?.toString(),
      price: json['price'],
      skuCode: json['sku_code']?.toString(),
      isActive: json['is_active'],
      category: json['category'] is Map
          ? CategoryModel.fromJson(Map<String, dynamic>.from(json['category'] as Map))
          : null,
      variants: json['variants'] != null 
          ? List<VariantModel>.from(json['variants'].map((x) => VariantModel.fromJson(Map<String, dynamic>.from(x)))) 
          : [],
      ratings: json['ratings'],
      ratingsCount: parseInt(json['ratings_count']),
      isFavorite: json['is_favorite'] == true || json['is_favorite'] == 1,
      directLowestPrice: json['lowest_price']?.toString(),
      directTotalStock: parseInt(json['total_stack']) ?? parseInt(json['total_stock']),
    );
  }

  Map<String, dynamic> toJson() => _$ProductModelToJson(this);
}
