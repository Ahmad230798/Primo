import 'package:dartz/dartz.dart';
import 'package:primo/core/network/api_error_handler.dart';
import '../../data/models/create_offer_request_body.dart';
import '../../data/models/create_offer_response.dart';
import '../repo/admin_offers_repo.dart';

class CreateOfferUseCase {
  final AdminOffersRepo _repo;
  CreateOfferUseCase(this._repo);

  Future<Either<Failure, CreateOfferResponse>> execute(
    CreateOfferRequestBody body,
  ) async {
    return await _repo.createOffer(body);
  }
}
