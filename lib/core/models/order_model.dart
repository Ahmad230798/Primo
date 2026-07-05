import 'package:primo/feature/addresses/data/models/address_model.dart';

class OrderItemModel {
  final int id;
  final String name;
  final String? image;
  final int quantity;
  final String? property;
  final num price;
  final bool hasActiveOffer;
  final num? newPrice;

  OrderItemModel({
    required this.id,
    required this.name,
    this.image,
    required this.quantity,
    this.property,
    required this.price,
    required this.hasActiveOffer,
    this.newPrice,
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

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? 'منتج',
      image: json['image'] as String?,
      quantity: json['quantity'] as int? ?? 1,
      property: json['property'] as String?,
      price: json['price'] != null ? num.tryParse(json['price'].toString()) ?? 0 : 0,
      hasActiveOffer: json['has_active_offer'] == true || json['has_active_offer'] == 1,
      newPrice: json['new_price'] != null ? num.tryParse(json['new_price'].toString()) : null,
    );
  }
}

class OrderPriceModel {
  final num itemPrice;
  final num deliveryPrice;
  final num totalPrice;

  OrderPriceModel({
    required this.itemPrice,
    required this.deliveryPrice,
    required this.totalPrice,
  });

  factory OrderPriceModel.fromJson(Map<String, dynamic> json) {
    return OrderPriceModel(
      itemPrice: json['item_price'] as num? ?? 0,
      deliveryPrice: json['delivery_price'] as num? ?? 0,
      totalPrice: json['total_price'] as num? ?? 0,
    );
  }
}

class OrderModel {
  final int id;
  final int userId;
  final int? addressId;
  final String status;
  final bool isDelivery;
  final num amount;
  final num deliveryAmount;
  final num totalAmount;
  final String? createdAt;
  final String? updatedAt;
  final AddressModel? address;
  final List<OrderItemModel> items;

  OrderModel({
    required this.id,
    required this.userId,
    this.addressId,
    required this.status,
    required this.isDelivery,
    required this.amount,
    required this.deliveryAmount,
    required this.totalAmount,
    this.createdAt,
    this.updatedAt,
    this.address,
    required this.items,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as int? ?? 0,
      userId: json['user_id'] as int? ?? 0,
      addressId: json['address_id'] is int
          ? json['address_id']
          : int.tryParse(json['address_id']?.toString() ?? ''),
      status: json['status']?.toString() ?? 'pending',
      // التعامل مع الأخطاء الإملائية في السيرفر: is_delivere أو is_delivery
      isDelivery: json['is_delivere'] == true ||
          json['is_delivery'] == true ||
          json['is_delivere'] == 1 ||
          json['is_delivery'] == 1 ||
          json['is_delivere'] == "1" ||
          json['is_delivery'] == "1",
      amount: json['amount'] as num? ?? 0,
      // التعامل مع الأخطاء الإملائية: delivere_amount أو delivery_amount
      deliveryAmount: json['delivere_amount'] as num? ??
          json['delivery_amount'] as num? ??
          0,
      totalAmount: json['total_amount'] as num? ?? 0,
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
      address: json['address'] != null && json['address'] is Map
          ? AddressModel.fromJson(json['address'] as Map<String, dynamic>)
          : null,
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  String get formattedDate {
    if (createdAt == null || createdAt!.isEmpty) return "";
    try {
      final dt = DateTime.parse(createdAt!).toLocal();
      return "${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} • ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}";
    } catch (_) {
      return createdAt!;
    }
  }

  String get statusArabic {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'delivered':
        return 'تم التسليم';
      case 'pending':
        return 'قيد الانتظار';
      case 'processing':
        return 'قيد التجهيز';
      case 'cancelled':
        return 'ملغي';
      default:
        return status;
    }
  }
}
