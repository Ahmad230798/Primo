import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:primo/core/models/order_model.dart';
import 'package:primo/core/network/api_consumer.dart';
import 'package:primo/core/network/api_constant.dart';
import 'package:primo/core/network/api_error_handler.dart';
import 'package:primo/feature/orders/domain/repos/orders_repo.dart';

class OrdersRepoImpl implements OrdersRepo {
  final ApiConsumer _apiConsumer;

  OrdersRepoImpl(this._apiConsumer);

  @override
  Future<Either<Failure, List<OrderModel>>> getOrders({String? status}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (status != null && status.isNotEmpty && status != 'all') {
        queryParams['status'] = status;
      }
      final response = await _apiConsumer.get(
        path: ApiConstant.userOrders,
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );
      final list = (response['data'] as List<dynamic>?)
              ?.map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [];
      return Right(list);
    } on ServerFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure("حدث خطأ غير متوقع أثناء جلب الطلبات: $e"));
    }
  }

  @override
  Future<Either<Failure, OrderModel>> getOrderById(int id) async {
    try {
      final response = await _apiConsumer.get(
        path: "${ApiConstant.userOrders}/$id",
      );
      final model = OrderModel.fromJson(response['data'] as Map<String, dynamic>);
      return Right(model);
    } on ServerFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure("حدث خطأ غير متوقع أثناء جلب تفاصيل الطلب: $e"));
    }
  }

  @override
  Future<Either<Failure, OrderPriceModel>> getOrderPrice(int isDelivery, String? addressId) async {
    try {
      final map = <String, dynamic>{
        'is_delivery': isDelivery.toString(),
      };
      if (addressId != null && addressId.isNotEmpty) {
        map['address_id'] = addressId;
      }
      final formData = FormData.fromMap(map);
      final response = await _apiConsumer.postFormData(
        path: ApiConstant.orderPrice,
        formData: formData,
      );
      final model = OrderPriceModel.fromJson(response['data'] as Map<String, dynamic>);
      return Right(model);
    } on ServerFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure("حدث خطأ غير متوقع أثناء حساب السعر: $e"));
    }
  }

  @override
  Future<Either<Failure, OrderModel>> confirmOrder(int isDelivery, String? addressId) async {
    try {
      final map = <String, dynamic>{
        'is_delivery': isDelivery.toString(),
      };
      if (addressId != null && addressId.isNotEmpty) {
        map['address_id'] = addressId;
      }
      final formData = FormData.fromMap(map);
      final response = await _apiConsumer.postFormData(
        path: ApiConstant.orderConfirm,
        formData: formData,
      );
      final model = OrderModel.fromJson(response['data'] as Map<String, dynamic>);
      return Right(model);
    } on ServerFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure("حدث خطأ غير متوقع أثناء تأكيد الطلب: $e"));
    }
  }

  @override
  Future<Either<Failure, String>> rateProductInOrder(int productId, int orderId, int rating) async {
    try {
      final formData = FormData.fromMap({
        'rating': rating.toString(),
      });
      final response = await _apiConsumer.postFormData(
        path: "/user/products/$productId/rate/ordar/$orderId",
        formData: formData,
      );
      final msg = response['message']?.toString() ?? "تم التقييم بنجاح";
      return Right(msg);
    } on ServerFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure("حدث خطأ غير متوقع أثناء إرسال التقييم: $e"));
    }
  }
}
