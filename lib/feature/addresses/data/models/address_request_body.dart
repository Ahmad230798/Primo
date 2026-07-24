import 'package:dio/dio.dart';

class AddressRequestBody {
  final String name;
  final String description;
  final String locationLat;
  final String locationLng;
  final String? phone;
  final num? distance;

  AddressRequestBody({
    required this.name,
    required this.description,
    required this.locationLat,
    required this.locationLng,
    this.phone,
    this.distance,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'location_lat': locationLat,
      'location_lng': locationLng,
      if (phone != null && phone!.isNotEmpty) 'phone': phone,
      if (distance != null) 'distance': distance,
    };
  }

  FormData toFormData() {
    return FormData.fromMap({
      'name': name,
      'description': description,
      'location_lat': locationLat,
      'location_lng': locationLng,
      if (phone != null && phone!.isNotEmpty) 'phone': phone,
      if (distance != null) 'distance': distance,
    });
  }

  FormData toUpdateFormData() {
    return FormData.fromMap({
      'name': name,
      'description': description,
      'location_lat': locationLat,
      'location_lng': locationLng,
      if (phone != null && phone!.isNotEmpty) 'phone': phone,
      if (distance != null) 'distance': distance,
      '_method': 'PUT',
    });
  }
}
