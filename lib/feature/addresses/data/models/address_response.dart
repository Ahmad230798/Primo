import 'address_model.dart';

class AddressListResponse {
  final bool success;
  final String? message;
  final List<AddressModel> data;

  AddressListResponse({
    required this.success,
    this.message,
    required this.data,
  });

  factory AddressListResponse.fromJson(Map<String, dynamic> json) {
    var list = <AddressModel>[];
    if (json['data'] != null && json['data'] is List) {
      list = (json['data'] as List)
          .map((item) => AddressModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    return AddressListResponse(
      success: json['success'] == true || json['status'] == 200 || json['status'] == true,
      message: json['message']?.toString(),
      data: list,
    );
  }
}

class AddressSingleResponse {
  final bool success;
  final String? message;
  final AddressModel? data;

  AddressSingleResponse({
    required this.success,
    this.message,
    this.data,
  });

  factory AddressSingleResponse.fromJson(Map<String, dynamic> json) {
    return AddressSingleResponse(
      success: json['success'] == true || json['status'] == 200 || json['status'] == true,
      message: json['message']?.toString(),
      data: json['data'] != null && json['data'] is Map<String, dynamic>
          ? AddressModel.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}
