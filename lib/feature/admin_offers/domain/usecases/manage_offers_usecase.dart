import 'package:dartz/dartz.dart';
import 'package:primo/core/models/offer_model.dart';
import 'package:primo/core/network/api_error_handler.dart';
import '../../data/models/create_offer_request_body.dart';
import '../../data/models/create_offer_response.dart';
import '../../data/models/update_offer_request_body.dart';
import '../repo/admin_offers_repo.dart';

class ManageOffersUseCase {
  final AdminOffersRepo _repo;
  ManageOffersUseCase(this._repo);

  Future<Either<Failure, List<OfferModel>>> getAllOffers() async =>
      await _repo.getAllOffers();

  Future<Either<Failure, CreateOfferResponse>> createOffer(
    CreateOfferRequestBody body,
  ) async => await _repo.createOffer(body);

  Future<Either<Failure, CreateOfferResponse>> updateOffer(
    int offerId,
    UpdateOfferRequestBody body,
  ) async => await _repo.updateOffer(offerId, body);

  Future<Either<Failure, void>> deleteOffer(int offerId) async =>
      await _repo.deleteOffer(offerId);
}
