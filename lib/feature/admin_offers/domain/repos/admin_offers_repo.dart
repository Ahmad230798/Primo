import 'package:dartz/dartz.dart';
import 'package:primo/core/network/api_error_handler.dart';
import 'package:primo/core/models/offer_model.dart';
import '../../data/models/create_offer_request_body.dart';
import '../../data/models/create_offer_response.dart';
import '../../data/models/update_offer_request_body.dart';

abstract class AdminOffersRepo {
  Future<Either<Failure, CreateOfferResponse>> createOffer(
    CreateOfferRequestBody body,
  );
  Future<Either<Failure, List<OfferModel>>> getAllOffers();
  Future<Either<Failure, CreateOfferResponse>> updateOffer(
    int offerId,
    UpdateOfferRequestBody body,
  );
  Future<Either<Failure, void>> deleteOffer(int offerId);
}
