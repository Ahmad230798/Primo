import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:primo/core/network/api_constant.dart';
import 'package:primo/core/network/api_consumer.dart';
import 'package:primo/core/network/api_error_handler.dart';
import 'package:primo/feature/admin_home/data/models/admin_dashboard_model.dart';
import '../../domain/repo/admin_suggestions_repo.dart';

List<SuggestionModel> _parseSuggestionsList(dynamic responseData) {
  final list = responseData is List ? responseData : (responseData['data'] as List? ?? []);
  return list.map((e) => SuggestionModel.fromJson(e as Map<String, dynamic>)).toList();
}

class AdminSuggestionsRepoImpl implements AdminSuggestionsRepo {
  final ApiConsumer _apiConsumer;
  AdminSuggestionsRepoImpl(this._apiConsumer);

  @override
  Future<Either<Failure, List<SuggestionModel>>> getSuggestions() async {
    try {
      final response = await _apiConsumer.get(path: ApiConstant.adminHome);
      final data = response is Map && response.containsKey('data') ? response['data'] : response;
      if (data is Map && data['pending_suggestions'] != null) {
        final list = await compute(_parseSuggestionsList, data['pending_suggestions']);
        return Right(list);
      }
      return const Right([]);
    } on ServerFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure("حدث خطأ في جلب المقترحات: $e"));
    }
  }

  @override
  Future<Either<Failure, String>> updateSuggestionStatus(int suggestionId, String status) async {
    try {
      final formData = FormData.fromMap({
        'status': status,
      });
      final response = await _apiConsumer.post(
        path: "${ApiConstant.adminSuggestions}/$suggestionId/status",
        body: formData,
      );
      final msg = response is Map ? (response['message']?.toString() ?? "تم تحديث حالة المقترح بنجاح") : "تم تحديث حالة المقترح بنجاح";
      return Right(msg);
    } on ServerFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure("حدث خطأ في تحديث المقترح: $e"));
    }
  }
}
