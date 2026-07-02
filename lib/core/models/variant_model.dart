import 'package:json_annotation/json_annotation.dart';

part 'variant_model.g.dart';

@JsonSerializable()
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

  VariantModel({
    this.id,
    this.productId,
    this.price,
    this.stock,
    this.property,
    this.isActive,
    this.hasActiveOffer,
    this.offerId,
  });

  factory VariantModel.fromJson(Map<String, dynamic> json) =>
      _$VariantModelFromJson(json);
}
