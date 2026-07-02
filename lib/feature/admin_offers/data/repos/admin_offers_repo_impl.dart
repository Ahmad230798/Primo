import 'package:dartz/dartz.dart';
import 'package:primo/core/network/api_constant.dart';
import 'package:primo/core/network/api_consumer.dart';
import 'package:primo/core/network/api_error_handler.dart';
import '../../data/models/create_offer_request_body.dart';
import '../../data/models/create_offer_response.dart';
import '../../domain/repo/admin_offers_repo.dart';

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
}
