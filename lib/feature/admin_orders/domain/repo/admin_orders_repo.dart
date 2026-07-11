import 'package:dartz/dartz.dart';
import 'package:primo/core/models/order_model.dart';
import 'package:primo/core/network/api_error_handler.dart';

abstract class AdminOrdersRepo {
  Future<Either<Failure, List<OrderModel>>> getAdminOrders({String? status});
  Future<Either<Failure, OrderModel>> getAdminOrderDetails(int orderId);
  Future<Either<Failure, String>> updateOrderStatus(int orderId, String newStatus);
}
