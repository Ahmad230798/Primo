import 'package:json_annotation/json_annotation.dart';

part 'create_offer_response.g.dart';

@JsonSerializable()
class CreateOfferResponse {
  final bool? success;
  final String? message;
  final OfferData? data;

  CreateOfferResponse({this.success, this.message, this.data});

  factory CreateOfferResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateOfferResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CreateOfferResponseToJson(this);
}

@JsonSerializable()
class OfferData {
  final int? id;
  @JsonKey(name: 'variant_id')
  final dynamic variantId;
  final String? from;
  final String? to;
  @JsonKey(name: 'discount_percentage')
  final String? discountPercentage;
  @JsonKey(name: 'discount_value')
  final dynamic discountValue;

  OfferData({
    this.id,
    this.variantId,
    this.from,
    this.to,
    this.discountPercentage,
    this.discountValue,
  });

  factory OfferData.fromJson(Map<String, dynamic> json) =>
      _$OfferDataFromJson(json);

  Map<String, dynamic> toJson() => _$OfferDataToJson(this);
}
