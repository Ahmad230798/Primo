import 'package:json_annotation/json_annotation.dart';

part 'offer_model.g.dart';

@JsonSerializable()
class OfferModel {
  final int? id;
  final String? from;
  final String? to;
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

  OfferModel({
    this.id,
    this.from,
    this.to,
    this.discountValue,
    this.productName,
    this.image,
    this.property,
    this.variantPrice,
    this.variantStock,
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

  factory OfferModel.fromJson(Map<String, dynamic> json) =>
      _$OfferModelFromJson(json);

  Map<String, dynamic> toJson() => _$OfferModelToJson(this);
}
