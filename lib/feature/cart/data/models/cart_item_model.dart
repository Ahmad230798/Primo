class CartItemModel {
  final int id;
  final int variantId;
  final String productName;
  final String? productImage;
  final String variantProperty;
  final num variantPrice;
  final int quantity;
  final bool hasActiveOffer;
  final num discountAmount;
  final num newPrice;
  final num totalPrice;
  final bool isAvailable;
  final int stockInStore;

  CartItemModel({
    required this.id,
    required this.variantId,
    required this.productName,
    this.productImage,
    required this.variantProperty,
    required this.variantPrice,
    required this.quantity,
    required this.hasActiveOffer,
    required this.discountAmount,
    required this.newPrice,
    required this.totalPrice,
    required this.isAvailable,
    required this.stockInStore,
  });

  String? get fullImageUrl {
    if (productImage == null || productImage!.trim().isEmpty) return null;
    if (productImage!.startsWith('http://') || productImage!.startsWith('https://')) {
      return productImage;
    }
    const baseUrl = 'https://api.primo-market.cloud';
    if (productImage!.startsWith('/')) {
      return '$baseUrl$productImage';
    }
    return '$baseUrl/$productImage';
  }

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'] as int? ?? 0,
      variantId: json['variant_id'] as int? ?? 0,
      productName: json['product_name'] as String? ?? '',
      productImage: json['product_image'] as String?,
      variantProperty: json['variant_property'] as String? ?? '',
      variantPrice: json['variant_price'] as num? ?? 0,
      quantity: json['quantity'] as int? ?? 1,
      hasActiveOffer: json['has_active_offer'] as bool? ?? false,
      discountAmount: json['discount_amount'] as num? ?? 0,
      newPrice: json['new_price'] as num? ?? (json['variant_price'] as num? ?? 0),
      totalPrice: json['total_price'] as num? ?? 0,
      isAvailable: json['is_available'] as bool? ?? true,
      stockInStore: json['stock_in_store'] as int? ?? 10,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'variant_id': variantId,
      'product_name': productName,
      'product_image': productImage,
      'variant_property': variantProperty,
      'variant_price': variantPrice,
      'quantity': quantity,
      'has_active_offer': hasActiveOffer,
      'discount_amount': discountAmount,
      'new_price': newPrice,
      'total_price': totalPrice,
      'is_available': isAvailable,
      'stock_in_store': stockInStore,
    };
  }

  CartItemModel copyWith({
    int? id,
    int? variantId,
    String? productName,
    String? productImage,
    String? variantProperty,
    num? variantPrice,
    int? quantity,
    bool? hasActiveOffer,
    num? discountAmount,
    num? newPrice,
    num? totalPrice,
    bool? isAvailable,
    int? stockInStore,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      variantId: variantId ?? this.variantId,
      productName: productName ?? this.productName,
      productImage: productImage ?? this.productImage,
      variantProperty: variantProperty ?? this.variantProperty,
      variantPrice: variantPrice ?? this.variantPrice,
      quantity: quantity ?? this.quantity,
      hasActiveOffer: hasActiveOffer ?? this.hasActiveOffer,
      discountAmount: discountAmount ?? this.discountAmount,
      newPrice: newPrice ?? this.newPrice,
      totalPrice: totalPrice ?? this.totalPrice,
      isAvailable: isAvailable ?? this.isAvailable,
      stockInStore: stockInStore ?? this.stockInStore,
    );
  }
}
