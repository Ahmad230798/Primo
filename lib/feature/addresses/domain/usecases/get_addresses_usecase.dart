import 'package:dartz/dartz.dart';
import 'package:primo/core/network/api_error_handler.dart';
import '../../data/models/address_response.dart';
import '../repo/addresses_repo.dart';

class GetAddressesUseCase {
  final AddressesRepo _repo;

  GetAddressesUseCase(this._repo);

  Future<Either<Failure, AddressListResponse>> execute() async {
    return await _repo.getAddresses();
  }
}
