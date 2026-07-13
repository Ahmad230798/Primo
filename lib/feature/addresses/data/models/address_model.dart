import 'package:flutter/material.dart';

class AddressModel {
  final int? id;
  final int? userId;
  final String? name;
  final String? description;
  final String? locationLat;
  final String? locationLng;
  final String? phone;
  final String? createdAt;
  final String? updatedAt;
  bool isDefault;

  AddressModel({
    this.id,
    this.userId,
    this.name,
    this.description,
    this.locationLat,
    this.locationLng,
    this.phone,
    this.createdAt,
    this.updatedAt,
    this.isDefault = false,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()),
      userId: json['user_id'] is int ? json['user_id'] : int.tryParse(json['user_id'].toString()),
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      locationLat: json['location_lat']?.toString() ?? '',
      locationLng: json['location_lng']?.toString() ?? '',
      phone: json['phone']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
      isDefault: json['is_default'] == true || json['is_default'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'description': description,
      'location_lat': locationLat,
      'location_lng': locationLng,
      'phone': phone,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'is_default': isDefault ? 1 : 0,
    };
  }

  IconData get icon {
    final lowerName = (name ?? '').toLowerCase();
    if (lowerName.contains('منزل') || lowerName.contains('home') || lowerName.contains('بيت')) {
      return Icons.home_filled;
    } else if (lowerName.contains('عمل') || lowerName.contains('work') || lowerName.contains('مكتب') || lowerName.contains('شركة')) {
      return Icons.business_center_rounded;
    }
    return Icons.location_on_rounded;
  }
}
