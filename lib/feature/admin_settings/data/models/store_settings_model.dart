class DeliveryPriceModel {
  final num price;

  DeliveryPriceModel({required this.price});

  factory DeliveryPriceModel.fromJson(Map<String, dynamic> json) {
    return DeliveryPriceModel(
      price: json['price'] != null ? num.tryParse(json['price'].toString()) ?? 0 : 0,
    );
  }
}

class AddStoreAddressRequest {
  final String description;
  final double locationLat;
  final double locationLng;

  AddStoreAddressRequest({
    required this.description,
    required this.locationLat,
    required this.locationLng,
  });

  Map<String, dynamic> toJson() => {
        'description': description,
        'location_lat': locationLat.toString(),
        'location_lng': locationLng.toString(),
      };
}
