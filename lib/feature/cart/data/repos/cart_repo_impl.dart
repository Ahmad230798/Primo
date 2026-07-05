import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:primo/core/network/api_consumer.dart';
import 'package:primo/core/network/api_constant.dart';
import 'package:primo/core/network/api_error_handler.dart';
import 'package:primo/feature/cart/data/models/cart_item_model.dart';
import 'package:primo/feature/cart/domain/repos/cart_repo.dart';

class CartRepoImpl implements CartRepo {
  final ApiConsumer _apiConsumer;

  CartRepoImpl(this._apiConsumer);

  @override
  Future<Either<Failure, List<CartItemModel>>> getCart() async {
    try {
      final response = await _apiConsumer.get(path: ApiConstant.userCart);
      final list = (response['data'] as List<dynamic>?)
              ?.map((e) => CartItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [];
      return Right(list);
    } on ServerFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure("حدث خطأ غير متوقع أثناء جلب السلة: $e"));
    }
  }

  @override
  Future<Either<Failure, String>> addToCart(int variantId, int count) async {
    try {
      final formData = FormData.fromMap({
        'variant_id': variantId.toString(),
        'count': count.toString(),
      });
      final response = await _apiConsumer.postFormData(
        path: ApiConstant.userCart,
        formData: formData,
      );
      final msg = response['message']?.toString() ?? "تمت إضافة المنتج بنجاح";
      return Right(msg);
    } on ServerFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure("حدث خطأ غير متوقع أثناء الإضافة للسلة: $e"));
    }
  }

  @override
  Future<Either<Failure, String>> updateCartQuantity(int cartId, int count) async {
    try {
      final formData = FormData.fromMap({
        '_method': 'PATCH',
        'count': count.toString(),
      });
      final response = await _apiConsumer.postFormData(
        path: "${ApiConstant.userCart}/$cartId",
        formData: formData,
      );
      final msg = response['message']?.toString() ?? "تم تحديث الكمية بنجاح";
      return Right(msg);
    } on ServerFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure("حدث خطأ غير متوقع أثناء تحديث الكمية: $e"));
    }
  }

  @override
  Future<Either<Failure, String>> deleteFromCart(int cartId) async {
    try {
      final response = await _apiConsumer.delete(
        path: "${ApiConstant.userCart}/$cartId",
      );
      final msg = response['message']?.toString() ?? "تم حذف المنتج من السلة";
      return Right(msg);
    } on ServerFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure("حدث خطأ غير متوقع أثناء الحذف: $e"));
    }
  }
}
