import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:dartz/dartz.dart';
import 'package:primo/core/network/api_constant.dart';
import 'package:primo/core/network/api_consumer.dart';
import 'package:primo/core/network/api_error_handler.dart';
import 'package:primo/core/network/app_storage.dart';
import 'package:primo/core/models/category_model.dart';
import '../../domain/repo/admin_category_repo.dart';
import '../models/add_category_request_body.dart';
import '../models/update_category_request_body.dart';

List<CategoryModel> _parseCategoriesList(List<dynamic> dataList) =>
    dataList.map((e) => CategoryModel.fromJson(e as Map<String, dynamic>)).toList();

class AdminCategoryRepoImpl implements AdminCategoryRepo {
  final ApiConsumer _apiConsumer;
  AdminCategoryRepoImpl(this._apiConsumer);

  @override
  Future<Either<Failure, CategoryModel>> addCategory(
    AddCategoryRequestBody body,
  ) async {
    try {
      final formData = await body.toFormData();
      final response = await _apiConsumer.postFormData(
        path: ApiConstant.adminCategories,
        formData: formData,
      );
      return Right(CategoryModel.fromJson(response['data']));
    } on ServerFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure("حدث خطأ غير متوقع: $e"));
    }
  }

  @override
  Future<Either<Failure, List<CategoryModel>>> getAllCategories() async {
    try {
      final response = await _apiConsumer.get(
        path: ApiConstant.adminCategories,
      );

      final List<dynamic> dataList = response['data'] ?? [];
      try {
        await AppStorage.cacheData('cache_admin_categories', jsonEncode(dataList));
      } catch (_) {}

      final categories = await compute(_parseCategoriesList, dataList);

      return Right(categories);
    } catch (e) {
      try {
        final cached = await AppStorage.getCachedData('cache_admin_categories');
        if (cached != null) {
          final List<dynamic> dataList = jsonDecode(cached);
          final categories = await compute(_parseCategoriesList, dataList);
          return Right(categories);
        }
      } catch (_) {}
      if (e is ServerFailure) return Left(e);
      return Left(ServerFailure("حدث خطأ غير متوقع: $e"));
    }
  }

  @override
  Future<Either<Failure, CategoryModel>> updateCategory(
    int categoryId,
    UpdateCategoryRequestBody body,
  ) async {
    try {
      final formData = await body.toFormData();
      final response = await _apiConsumer.postFormData(
        path: "${ApiConstant.adminCategories}/$categoryId",
        formData: formData,
      );
      return Right(CategoryModel.fromJson(response['data']));
    } on ServerFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure("حدث خطأ غير متوقع: $e"));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCategory(int categoryId) async {
    try {
      await _apiConsumer.delete(
        path: "${ApiConstant.adminCategories}/$categoryId",
      );
      return const Right(null);
    } on ServerFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure("حدث خطأ غير متوقع: $e"));
    }
  }
}
