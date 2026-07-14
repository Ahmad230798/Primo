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
    if (directLowestPrice != null &&
        directLowestPrice!.trim().isNotEmpty &&
        directLowestPrice != "null") {
      return directLowestPrice!;
    }
    if (variants == null || variants!.isEmpty) return "0";
    var prices = variants!
        .map((v) => double.tryParse(v.price.toString()) ?? 0.0)
        .toList();
    prices.sort();
    return prices.first.toStringAsFixed(0);
  }

  String get displayPrice {
    // 1. إذا كان السعر موجوداً مباشرة في المنتج، استخدمه فوراً!
    if (price != null && price.toString() != "0") {
      return price.toString();
    }
    // 2. إذا لم يكن موجوداً، ابحث في الـ variants (المنطق القديم)
    if (variants == null || variants!.isEmpty) return "0";
    var prices = variants!
        .map((v) => double.tryParse(v.price.toString()) ?? 0.0)
        .toList();
    prices.sort();
    return prices.first.toStringAsFixed(0);
  }

  String? get title => name;
  String? get unit {
    if (variants != null && variants!.isNotEmpty) {
      return variants!.first.property ?? 'قطعة';
    }
    return 'قطعة';
  }

  int? get stock => totalStock;

  int get totalStock {
    // إذا أرسل السيرفر قيمة مباشرة استخدمها
    if (directTotalStock != null && directTotalStock! > 0) {
      return directTotalStock!;
    }
    // إذا لم تكن هناك variants، لا تعيد 0 وتتسبب في "نفد الكمية"
    // افترض أن المنتج متاح (مثلاً 1) أو تعامل معها كقيمة غير معروفة
    if (variants == null || variants!.isEmpty) {
      return 999; // 💡 تعني: متاح (أو يمكنك وضع قيمة افتراضية)
    }
    return variants!.fold(
      0,
      (sum, item) => sum + (int.tryParse(item.stock.toString()) ?? 0),
    );
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

    // Penetrate 'product' relation wrapper if it exists (e.g., in favorites list response)
    final Map<String, dynamic> target = (json.containsKey('product') && json['product'] is Map<String, dynamic>)
        ? json['product'] as Map<String, dynamic>
        : json;

    return ProductModel(
      id: parseInt(target['id']),
      categoryId: target['category_id'],
      categoryName:
          target['category_name']?.toString() ??
          (target['category'] is Map
              ? target['category']['name']?.toString()
              : null),
      name: target['name']?.toString(),
      image: target['image']?.toString(),
      description: target['description']?.toString(),
      price: target['price'],
      skuCode: target['sku_code']?.toString(),
      isActive: target['is_active'],
      category: target['category'] is Map
          ? CategoryModel.fromJson(
              Map<String, dynamic>.from(target['category'] as Map),
            )
          : null,
      variants: target['variants'] != null
          ? List<VariantModel>.from(
              target['variants'].map(
                (x) => VariantModel.fromJson(Map<String, dynamic>.from(x)),
              ),
            )
          : [],
      ratings: target['ratings'],
      ratingsCount: parseInt(target['ratings_count']),
      isFavorite: target['is_favorite'] == true || target['is_favorite'] == 1 || json['is_favorite'] == true || json['is_favorite'] == 1,
      directLowestPrice: target['lowest_price']?.toString(),
      directTotalStock:
          parseInt(target['total_stack']) ?? parseInt(target['total_stock']),
    );
  }

  Map<String, dynamic> toJson() => _$ProductModelToJson(this);
}
