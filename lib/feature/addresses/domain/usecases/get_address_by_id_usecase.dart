import 'package:dartz/dartz.dart';
import 'package:primo/core/network/api_error_handler.dart';
import '../../data/models/address_response.dart';
import '../repo/addresses_repo.dart';

class GetAddressByIdUseCase {
  final AddressesRepo _repo;

  GetAddressByIdUseCase(this._repo);

  Future<Either<Failure, AddressSingleResponse>> execute(int id) async {
    return await _repo.getAddressById(id);
  }
}
