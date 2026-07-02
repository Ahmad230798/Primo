import 'package:dartz/dartz.dart';
import 'package:primo/core/network/api_error_handler.dart';
import '../../data/models/create_offer_request_body.dart';
import '../../data/models/create_offer_response.dart';

abstract class AdminOffersRepo {
  Future<Either<Failure, CreateOfferResponse>> createOffer(
    CreateOfferRequestBody body,
  );
}
