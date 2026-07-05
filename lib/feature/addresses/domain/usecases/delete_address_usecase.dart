import 'package:dartz/dartz.dart';
import 'package:primo/core/network/api_error_handler.dart';
import '../../data/models/address_response.dart';
import '../repo/addresses_repo.dart';

class DeleteAddressUseCase {
  final AddressesRepo _repo;

  DeleteAddressUseCase(this._repo);

  Future<Either<Failure, AddressSingleResponse>> execute(int id) async {
    return await _repo.deleteAddress(id);
  }
}
