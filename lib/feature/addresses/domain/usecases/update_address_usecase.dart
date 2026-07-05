import 'package:dartz/dartz.dart';
import 'package:primo/core/network/api_error_handler.dart';
import '../../data/models/address_request_body.dart';
import '../../data/models/address_response.dart';
import '../repo/addresses_repo.dart';

class UpdateAddressUseCase {
  final AddressesRepo _repo;

  UpdateAddressUseCase(this._repo);

  Future<Either<Failure, AddressSingleResponse>> execute(int id, AddressRequestBody body) async {
    return await _repo.updateAddress(id, body);
  }
}
