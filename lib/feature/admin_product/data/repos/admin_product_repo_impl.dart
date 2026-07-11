import 'package:flutter/foundation.dart';
import 'package:dartz/dartz.dart';
import 'package:primo/core/network/api_constant.dart';
import 'package:primo/core/network/api_consumer.dart';
import 'package:primo/core/network/api_error_handler.dart';
import 'package:primo/core/models/product_model.dart';
import '../../domain/repo/admin_product_repo.dart';
import '../models/add_product_request_body.dart';
import '../models/update_product_request_body.dart';

List<ProductModel> _parseProductsList(List<dynamic> dataList) =>
    dataList.map((e) => ProductModel.fromJson(e as Map<String, dynamic>)).toList();

class AdminProductRepoImpl implements AdminProductRepo {
  final ApiConsumer _apiConsumer;
  AdminProductRepoImpl(this._apiConsumer);

  @override
  Future<Either<Failure, List<ProductModel>>> getProducts() async {
    try {
      final response = await _apiConsumer.get(path: ApiConstant.adminProducts);
      final List<dynamic> dataList = response['data'] ?? [];
      final products = await compute(_parseProductsList, dataList);
      return Right(products);
    } on ServerFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure("حدث خطأ غير متوقع: $e"));
    }
  }

  @override
  Future<Either<Failure, ProductModel>> getProductById(int productId) async {
    try {
      final response = await _apiConsumer.get(
        path: "${ApiConstant.adminProducts}/$productId",
      );
      return Right(ProductModel.fromJson(response['data']));
    } on ServerFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure("حدث خطأ غير متوقع: $e"));
    }
  }

  @override
  Future<Either<Failure, ProductModel>> createProduct(
    AddProductRequestBody body,
  ) async {
    try {
      final formData = await body.toFormData();
      final response = await _apiConsumer.postFormData(
        path: ApiConstant.adminProducts,
        formData: formData,
      );
      return Right(ProductModel.fromJson(response['data']));
    } on ServerFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure("حدث خطأ غير متوقع: $e"));
    }
  }

  @override
  Future<Either<Failure, ProductModel>> updateProduct(
    int productId,
    UpdateProductRequestBody body,
  ) async {
    try {
      final formData = await body.toFormData();
      // كما اتفقنا، نستخدم postFormData لأننا رفعنا _method=PUT داخل الفورم
      final response = await _apiConsumer.postFormData(
        path: "${ApiConstant.adminProducts}/$productId",
        formData: formData,
      );
      return Right(ProductModel.fromJson(response['data']));
    } on ServerFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure("حدث خطأ غير متوقع: $e"));
    }
  }

  @override
  Future<Either<Failure, void>> deleteProduct(int productId) async {
    try {
      await _apiConsumer.delete(
        path: "${ApiConstant.adminProducts}/$productId",
      );
      return const Right(null);
    } on ServerFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure("حدث خطأ غير متوقع: $e"));
    }
  }

  @override
  Future<Either<Failure, void>> deleteVariant(int variantId) async {
    try {
      // بناءً على البوستمات مسار حذف النوع هو: /admin/variants/:variant/delete
      await _apiConsumer.delete(
        path: "${ApiConstant.adminVariants}/$variantId/delete",
      );
      return const Right(null);
    } on ServerFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure("حدث خطأ غير متوقع: $e"));
    }
  }

  @override
  Future<Either<Failure, ProductModel>> toggleProductStatus(
    int productId,
  ) async {
    try {
      // مسار تغيير الحالة هو POST /admin/products/toggle-active/:product
      final response = await _apiConsumer.post(
        path: "${ApiConstant.toggleProductStatus}/$productId",
      );
      return Right(ProductModel.fromJson(response['data']));
    } on ServerFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure("حدث خطأ غير متوقع: $e"));
    }
  }
}
