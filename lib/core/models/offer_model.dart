import 'package:json_annotation/json_annotation.dart';
import 'variant_model.dart';

part 'offer_model.g.dart';

@JsonSerializable(createFactory: false)
class OfferModel {
  final int? id;
  @JsonKey(name: 'product_id')
  final int? productId;
  @JsonKey(name: 'variant_id')
  final int? variantId;
  final String? from;
  final String? to;
  @JsonKey(name: 'discount_percentage')
  final dynamic discountPercentage;
  @JsonKey(name: 'discount_value')
  final dynamic discountValue;
  @JsonKey(name: 'product_name')
  final String? productName;
  final String? image;
  final String? property;
  @JsonKey(name: 'variant_price')
  final dynamic variantPrice;
  @JsonKey(name: 'variant_stock')
  final dynamic variantStock;
  final VariantModel? variant;

  OfferModel({
    this.id,
    this.productId,
    this.variantId,
    this.from,
    this.to,
    this.discountPercentage,
    this.discountValue,
    this.productName,
    this.image,
    this.property,
    this.variantPrice,
    this.variantStock,
    this.variant,
  });

  String? get fullImageUrl {
    final img = image ?? variant?.product?.image;
    if (img == null || img.trim().isEmpty) return null;
    if (img.startsWith('http://') || img.startsWith('https://')) {
      return img;
    }
    const baseUrl = 'https://api.primo-market.cloud';
    if (img.startsWith('/')) {
      return '$baseUrl$img';
    }
    return '$baseUrl/$img';
  }

  factory OfferModel.fromJson(Map<String, dynamic> json) {
    int? parseInt(dynamic val) {
      if (val == null) return null;
      if (val is int) return val;
      if (val is num) return val.toInt();
      return int.tryParse(val.toString());
    }

    final variantMap = json['variant_product'] is Map<String, dynamic>
        ? json['variant_product'] as Map<String, dynamic>
        : (json['variant'] is Map<String, dynamic>
            ? json['variant'] as Map<String, dynamic>
            : null);
    final productMap = variantMap != null && variantMap['product'] is Map<String, dynamic>
        ? variantMap['product'] as Map<String, dynamic>
        : (json['product'] is Map<String, dynamic>
            ? json['product'] as Map<String, dynamic>
            : null);

    final String? pName = json['product_name']?.toString() ??
        productMap?['name']?.toString() ??
        json['name']?.toString();

    final String? prop = json['property']?.toString() ??
        variantMap?['property']?.toString();

    final dynamic vPrice = json['variant_price'] ??
        variantMap?['price'];

    final dynamic vStock = json['variant_stock'] ??
        variantMap?['stock'];

    final String? img = json['image']?.toString() ??
        productMap?['image']?.toString() ??
        variantMap?['image']?.toString();

    return OfferModel(
      id: parseInt(json['id']),
      productId: parseInt(json['product_id'] ??
          variantMap?['product_id'] ??
          productMap?['id']),
      variantId: parseInt(json['variant_id'] ?? variantMap?['id']),
      from: json['from']?.toString(),
      to: json['to']?.toString(),
      discountPercentage: json['discount_percentage'],
      discountValue: json['discount_value'],
      productName: pName,
      image: img,
      property: prop,
      variantPrice: vPrice,
      variantStock: vStock,
      variant: variantMap != null ? VariantModel.fromJson(variantMap) : null,
    );
  }

  Map<String, dynamic> toJson() => _$OfferModelToJson(this);
}
