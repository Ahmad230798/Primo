import 'package:dartz/dartz.dart';
import 'package:primo/core/network/api_error_handler.dart';
import '../../data/models/address_request_body.dart';
import '../../data/models/address_response.dart';

abstract class AddressesRepo {
  Future<Either<Failure, AddressListResponse>> getAddresses();
  Future<Either<Failure, AddressSingleResponse>> getAddressById(int id);
  Future<Either<Failure, AddressSingleResponse>> createAddress(AddressRequestBody body);
  Future<Either<Failure, AddressSingleResponse>> updateAddress(int id, AddressRequestBody body);
  Future<Either<Failure, AddressSingleResponse>> deleteAddress(int id);
}
