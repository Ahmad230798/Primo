import 'package:dio/dio.dart';

class AddressRequestBody {
  final String name;
  final String description;
  final String locationLat;
  final String locationLng;

  AddressRequestBody({
    required this.name,
    required this.description,
    required this.locationLat,
    required this.locationLng,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'location_lat': locationLat,
      'location_lng': locationLng,
    };
  }

  FormData toFormData() {
    return FormData.fromMap({
      'name': name,
      'description': description,
      'location_lat': locationLat,
      'location_lng': locationLng,
    });
  }

  FormData toUpdateFormData() {
    return FormData.fromMap({
      'name': name,
      'description': description,
      'location_lat': locationLat,
      'location_lng': locationLng,
      '_method': 'PUT',
    });
  }
}
