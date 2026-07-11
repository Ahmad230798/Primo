import 'package:flutter/foundation.dart';
import 'package:dartz/dartz.dart';
import 'package:primo/core/models/offer_model.dart';
import 'package:primo/core/network/api_constant.dart';
import 'package:primo/core/network/api_consumer.dart';
import 'package:primo/core/network/api_error_handler.dart';
import '../../data/models/create_offer_request_body.dart';
import '../../data/models/create_offer_response.dart';
import '../../data/models/update_offer_request_body.dart';
import '../../domain/repo/admin_offers_repo.dart';

List<OfferModel> _parseOffersList(List<dynamic> dataList) =>
    dataList.map((e) => OfferModel.fromJson(e as Map<String, dynamic>)).toList();

class AdminOffersRepoImpl implements AdminOffersRepo {
  final ApiConsumer _apiConsumer;
  AdminOffersRepoImpl(this._apiConsumer);

  @override
  Future<Either<Failure, CreateOfferResponse>> createOffer(
    CreateOfferRequestBody body,
  ) async {
    try {
      final response = await _apiConsumer.postFormData(
        path: ApiConstant.adminOffers,
        formData: body.toFormData(),
      );
      return Right(CreateOfferResponse.fromJson(response));
    } on ServerFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure("حدث خطأ غير متوقع: $e"));
    }
  }

  @override
  Future<Either<Failure, List<OfferModel>>> getAllOffers() async {
    try {
      final response = await _apiConsumer.get(path: ApiConstant.adminOffers);
      final List<dynamic> dataList = response['data'] ?? [];
      final offers = await compute(_parseOffersList, dataList);
      return Right(offers);
    } on ServerFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure("حدث خطأ غير متوقع: $e"));
    }
  }

  @override
  Future<Either<Failure, CreateOfferResponse>> updateOffer(
    int offerId,
    UpdateOfferRequestBody body,
  ) async {
    try {
      final formData = await body.toFormData();
      final response = await _apiConsumer.postFormData(
        path: "${ApiConstant.adminOffers}/$offerId",
        formData: formData,
      );
      return Right(CreateOfferResponse.fromJson(response));
    } on ServerFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure("حدث خطأ غير متوقع: $e"));
    }
  }

  @override
  Future<Either<Failure, void>> deleteOffer(int offerId) async {
    try {
      await _apiConsumer.delete(path: "${ApiConstant.adminOffers}/$offerId");
      return const Right(null);
    } on ServerFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure("حدث خطأ غير متوقع: $e"));
    }
  }
}
