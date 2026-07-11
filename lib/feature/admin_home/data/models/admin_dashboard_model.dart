import 'package:primo/core/models/order_model.dart';

class SuggestionModel {
  final int id;
  final String? name;
  final String? description;
  final String? createdAt;
  final String? status;

  SuggestionModel({
    required this.id,
    this.name,
    this.description,
    this.createdAt,
    this.status,
  });

  factory SuggestionModel.fromJson(Map<String, dynamic> json) {
    return SuggestionModel(
      id: json['id'] != null ? (int.tryParse(json['id'].toString()) ?? 0) : 0,
      name: json['name']?.toString(),
      description: json['description']?.toString() ?? json['text']?.toString() ?? '',
      createdAt: json['created_at']?.toString(),
      status: json['status']?.toString() ?? 'pending',
    );
  }
}

class AdminDashboardModel {
  final num totalAmount;
  final int pendingOrdersCount;
  final int productsCount;
  final List<OrderModel> pendingOrders;
  final List<SuggestionModel> pendingSuggestions;

  AdminDashboardModel({
    required this.totalAmount,
    required this.pendingOrdersCount,
    required this.productsCount,
    required this.pendingOrders,
    required this.pendingSuggestions,
  });

  factory AdminDashboardModel.fromJson(Map<String, dynamic> json) {
    return AdminDashboardModel(
      totalAmount: json['total_amount'] != null
          ? (num.tryParse(json['total_amount'].toString()) ?? 0)
          : 0,
      pendingOrdersCount: json['pending_orders_count'] != null
          ? (int.tryParse(json['pending_orders_count'].toString()) ?? 0)
          : 0,
      productsCount: json['products_count'] != null
          ? (int.tryParse(json['products_count'].toString()) ?? 0)
          : 0,
      pendingOrders: (json['pending_orders'] as List<dynamic>?)
              ?.whereType<Map<String, dynamic>>()
              .map((e) => OrderModel.fromJson(e))
              .toList() ??
          [],
      pendingSuggestions: (json['pending_suggestions'] as List<dynamic>?)
              ?.whereType<Map<String, dynamic>>()
              .map((e) => SuggestionModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}
