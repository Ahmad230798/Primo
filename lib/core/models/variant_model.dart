import 'package:json_annotation/json_annotation.dart';
import 'product_model.dart';

part 'variant_model.g.dart';

@JsonSerializable(createFactory: false)
class VariantModel {
  final int? id;
  @JsonKey(name: 'product_id')
  final int? productId;
  final String? price;
  final int? stock;
  final String? property;
  @JsonKey(name: 'is_active')
  final int? isActive;
  @JsonKey(name: 'has_active_offer')
  final bool? hasActiveOffer;
  @JsonKey(name: 'offer_id')
  final int? offerId;
  @JsonKey(name: 'discount_amount')
  final dynamic discountAmount;
  @JsonKey(name: 'new_price')
  final dynamic newPrice;
  final ProductModel? product;
  @JsonKey(name: 'is_dollar')
  final bool isDollar;

  VariantModel({
    this.id,
    this.productId,
    this.price,
    this.stock,
    this.property,
    this.isActive,
    this.hasActiveOffer,
    this.offerId,
    this.discountAmount,
    this.newPrice,
    this.product,
    this.isDollar = false,
  });

  bool get isActiveBool =>
      isActive == 1 || isActive.toString().toLowerCase() == 'true';

  String formatPrice(dynamic priceValue) {
    if (isDollar) {
      return "\$ $priceValue";
    }
    return "$priceValue ل.س";
  }

  factory VariantModel.fromJson(Map<String, dynamic> json) {
    int? parseInt(dynamic val) {
      if (val == null) return null;
      if (val is int) return val;
      if (val is num) return val.toInt();
      return int.tryParse(val.toString());
    }

    bool? parseBool(dynamic val) {
      if (val == null) return null;
      if (val is bool) return val;
      if (val is num) return val != 0;
      final s = val.toString().toLowerCase();
      return s == 'true' || s == '1';
    }

    return VariantModel(
      id: parseInt(json['id']),
      productId: parseInt(json['product_id']),
      price: json['price']?.toString(),
      stock: parseInt(json['stock']),
      property: json['property']?.toString(),
      isActive: parseInt(json['is_active']),
      hasActiveOffer: parseBool(json['has_active_offer']),
      offerId: parseInt(json['offer_id']),
      discountAmount: json['discount_amount'],
      newPrice: json['new_price'],
      product: json['product'] is Map
          ? ProductModel.fromJson(Map<String, dynamic>.from(json['product'] as Map))
          : null,
      isDollar: parseBool(json['is_dollar']) ?? false,
    );
  }

  Map<String, dynamic> toJson() => _$VariantModelToJson(this);
}
