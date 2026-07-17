import 'package:primo/feature/addresses/data/models/address_model.dart';
import 'package:primo/core/models/user_model.dart';

class OrderItemModel {
  final int id;
  final int productId;
  final int productRatings;
  final String name;
  final String? image;
  final int quantity;
  final String? property;
  final num price;
  final bool hasActiveOffer;
  final num? newPrice;
  final bool isDollar;

  OrderItemModel({
    required this.id,
    required this.name,
    this.image,
    required this.quantity,
    this.property,
    required this.price,
    required this.hasActiveOffer,
    this.newPrice,
    required this.productId,
    required this.productRatings,
    this.isDollar = false,
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

  String formatPrice(dynamic priceVal) {
    if (isDollar) {
      return "\$ $priceVal";
    }
    return "$priceVal ل.س";
  }

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    // 💡 1. حماية الكمية: تحويل آمن يضمن قراءة الرقم سواء جاء كنص "3" أو رقم 3
    final int parsedQuantity = json['quantity'] != null
        ? int.tryParse(json['quantity'].toString().trim()) ?? 1
        : 1;

    // 💡 2. حماية السعر: تحويل آمن يضمن قراءة النص "30000.00" إلى رقم فعلي
    final num parsedPrice = json['price'] != null
        ? num.tryParse(json['price'].toString().trim()) ?? 0
        : 0;

    // 💡 3. حماية السعر الجديد (في حال وجود عرض)
    final num? parsedNewPrice = json['new_price'] != null
        ? num.tryParse(json['new_price'].toString().trim())
        : null;

    // 💡 4. التعديل الذهبي لحل المشكلة: ترتيب فحص المعرفات لضمان التقاط variant_id أولاً
    final int parsedId = json['variant_id'] != null
        ? (int.tryParse(json['variant_id'].toString()) ?? 0)
        : (json['id'] != null
              ? (int.tryParse(json['id'].toString()) ?? 0)
              : (json['product_id'] != null
                    ? (int.tryParse(json['product_id'].toString()) ?? 0)
                    : 0));
    final int parsedProductId = json['product_id'] != null
        ? (int.tryParse(json['product_id'].toString()) ?? 0)
        : parsedId; // كخطة بديلة نأخذ الـ id العادي
    final int parsedRatings = json['product_ratings'] != null
        ? (int.tryParse(json['product_ratings'].toString()) ?? 0)
        : 0;
    return OrderItemModel(
      id: parsedId, // سيحمل الآن قيمة variant_id الصحيحة
      productId: parsedProductId, // 💡 تمريره هنا
      productRatings: parsedRatings,
      name: json['name']?.toString() ?? 'منتج',
      image: json['image']?.toString(),
      quantity: parsedQuantity,
      property:
          json['property']?.toString() ??
          (json['variant'] is Map
              ? json['variant']['property']?.toString()
              : null),
      price: parsedPrice,
      hasActiveOffer:
          json['has_active_offer'] == true ||
          json['has_active_offer'] == 1 ||
          json['has_active_offer'] == "1" ||
          parsedNewPrice != null,
      newPrice: parsedNewPrice,
      isDollar: json['is_dollar'] == 1 || json['is_dollar'] == true || json['is_dollar'] == '1' || json['is_dollar'] == 'true',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'variant_id': id,
    'product_id': productId,
    'product_ratings': productRatings,
    'name': name,
    'image': image,
    'quantity': quantity,
    'property': property,
    'price': price,
    'has_active_offer': hasActiveOffer,
    'new_price': newPrice,
  };
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
  final UserModel? user;
  final int? itemCount;
  final List<OrderItemModel> items;
  final bool isDollar;

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
    this.user,
    required this.items,
    this.itemCount,
    this.isDollar = false,
  });

  bool get isDollarBool {
    if (isDollar) return true;
    if (items.isNotEmpty) {
      return items.any((item) => item.isDollar);
    }
    return false;
  }

  String formatPrice(dynamic priceVal) {
    if (isDollarBool) {
      return "\$ $priceVal";
    }
    return "$priceVal ل.س";
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] != null ? (int.tryParse(json['id'].toString()) ?? 0) : 0,
      userId: json['user_id'] != null
          ? (int.tryParse(json['user_id'].toString()) ?? 0)
          : 0,
      itemCount: json['item_count'],
      addressId: json['address_id'] != null
          ? int.tryParse(json['address_id'].toString())
          : null,
      status: json['status']?.toString() ?? 'pending',
      isDelivery:
          json['is_delivere'] == true ||
          json['is_delivery'] == true ||
          json['is_delivere'] == 1 ||
          json['is_delivery'] == 1 ||
          json['is_delivere'] == "1" ||
          json['is_delivery'] == "1",
      amount: json['amount'] != null
          ? (num.tryParse(json['amount'].toString()) ?? 0)
          : 0,
      deliveryAmount: json['delivere_amount'] != null
          ? (num.tryParse(json['delivere_amount'].toString()) ?? 0)
          : (json['delivery_amount'] != null
                ? (num.tryParse(json['delivery_amount'].toString()) ?? 0)
                : 0),
      totalAmount: json['total_amount'] != null
          ? (num.tryParse(json['total_amount'].toString()) ?? 0)
          : 0,
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
      address: json['address'] != null && json['address'] is Map
          ? AddressModel.fromJson(json['address'] as Map<String, dynamic>)
          : null,
      user: json['user'] != null && json['user'] is Map
          ? UserModel.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      isDollar: json['is_dollar'] == 1 || json['is_dollar'] == true || json['is_dollar'] == '1' || json['is_dollar'] == 'true',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'address_id': addressId,
    'status': status,
    'is_delivery': isDelivery ? 1 : 0,
    'amount': amount,
    'delivery_amount': deliveryAmount,
    'total_amount': totalAmount,
    'created_at': createdAt,
    'updated_at': updatedAt,
    'address': address?.toJson(),
    'user': user?.toJson(),
    'items': items.map((e) => e.toJson()).toList(),
  };

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
      case 'canceled':
        return 'ملغي';
      default:
        return status;
    }
  }

  OrderModel copyWith({
    int? id,
    int? userId,
    int? addressId,
    String? status,
    bool? isDelivery,
    num? amount,
    num? deliveryAmount,
    num? totalAmount,
    String? createdAt,
    String? updatedAt,
    AddressModel? address,
    UserModel? user,
    List<OrderItemModel>? items,
  }) {
    return OrderModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      addressId: addressId ?? this.addressId,
      status: status ?? this.status,
      isDelivery: isDelivery ?? this.isDelivery,
      amount: amount ?? this.amount,
      deliveryAmount: deliveryAmount ?? this.deliveryAmount,
      totalAmount: totalAmount ?? this.totalAmount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      address: address ?? this.address,
      user: user ?? this.user,

      items: items ?? this.items,
    );
  }
}
