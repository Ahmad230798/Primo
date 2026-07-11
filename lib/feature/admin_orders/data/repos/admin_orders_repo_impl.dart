import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:primo/core/models/order_model.dart';
import 'package:primo/core/network/api_constant.dart';
import 'package:primo/core/network/api_consumer.dart';
import 'package:primo/core/network/api_error_handler.dart';
import '../../domain/repo/admin_orders_repo.dart';

List<OrderModel> _parseAdminOrdersList(dynamic responseData) {
  final list = responseData is List ? responseData : (responseData['data'] as List? ?? []);
  return list.map((e) => OrderModel.fromJson(e as Map<String, dynamic>)).toList();
}

class AdminOrdersRepoImpl implements AdminOrdersRepo {
  final ApiConsumer _apiConsumer;
  AdminOrdersRepoImpl(this._apiConsumer);

  @override
  Future<Either<Failure, List<OrderModel>>> getAdminOrders({String? status}) async {
    try {
      final queryParameters = <String, dynamic>{};
      if (status != null && status.isNotEmpty && status != 'all' && status != 'الكل') {
        queryParameters['status'] = status;
      }
      final response = await _apiConsumer.get(
        path: ApiConstant.adminOrders,
        queryParameters: queryParameters.isNotEmpty ? queryParameters : null,
      );

      final data = response is Map && response.containsKey('data') ? response['data'] : response;
      final orders = await compute(_parseAdminOrdersList, data);
      return Right(orders);
    } on ServerFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure("حدث خطأ في جلب طلبات الإدارة: $e"));
    }
  }

  @override
  Future<Either<Failure, OrderModel>> getAdminOrderDetails(int orderId) async {
    try {
      final response = await _apiConsumer.get(
        path: "${ApiConstant.adminOrders}/$orderId",
      );
      final data = response is Map && response.containsKey('data') ? response['data'] : response;
      return Right(OrderModel.fromJson(data as Map<String, dynamic>));
    } on ServerFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure("حدث خطأ في جلب تفاصيل الطلب: $e"));
    }
  }

  @override
  Future<Either<Failure, String>> updateOrderStatus(int orderId, String newStatus) async {
    try {
      final formData = FormData.fromMap({
        'status': newStatus,
      });
      final response = await _apiConsumer.post(
        path: "${ApiConstant.adminOrderStatus}/$orderId",
        body: formData,
      );
      final message = response is Map ? (response['message']?.toString() ?? "تم تحديث حالة الطلب بنجاح") : "تم تحديث حالة الطلب بنجاح";
      return Right(message);
    } on ServerFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure("حدث خطأ في تحديث الحالة: $e"));
    }
  }
}
