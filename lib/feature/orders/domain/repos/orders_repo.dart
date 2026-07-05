import 'package:dartz/dartz.dart';
import 'package:primo/core/models/order_model.dart';
import 'package:primo/core/network/api_error_handler.dart';

abstract class OrdersRepo {
  Future<Either<Failure, List<OrderModel>>> getOrders({String? status});
  Future<Either<Failure, OrderModel>> getOrderById(int id);
  Future<Either<Failure, OrderPriceModel>> getOrderPrice(int isDelivery, String? addressId);
  Future<Either<Failure, OrderModel>> confirmOrder(int isDelivery, String? addressId);
  Future<Either<Failure, String>> rateProductInOrder(int productId, int orderId, int rating);
}
