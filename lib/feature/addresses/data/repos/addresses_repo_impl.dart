import 'package:dartz/dartz.dart';
import 'package:primo/core/network/api_consumer.dart';
import 'package:primo/core/network/api_error_handler.dart';
import 'package:primo/core/network/api_constant.dart';
import '../../domain/repo/addresses_repo.dart';
import '../models/address_request_body.dart';
import '../models/address_response.dart';

class AddressesRepoImpl implements AddressesRepo {
  final ApiConsumer _apiConsumer;

  AddressesRepoImpl(this._apiConsumer);

  @override
  Future<Either<Failure, AddressListResponse>> getAddresses() async {
    try {
      final response = await _apiConsumer.get(path: ApiConstant.addresses);
      return Right(AddressListResponse.fromJson(response));
    } on ServerFailure catch (failure) {
      return Left(failure);
    } catch (error) {
      return Left(ServerFailure("حدث خطأ غير متوقع: $error"));
    }
  }

  @override
  Future<Either<Failure, AddressSingleResponse>> getAddressById(int id) async {
    try {
      final response = await _apiConsumer.get(path: '${ApiConstant.addresses}/$id');
      return Right(AddressSingleResponse.fromJson(response));
    } on ServerFailure catch (failure) {
      return Left(failure);
    } catch (error) {
      return Left(ServerFailure("حدث خطأ غير متوقع: $error"));
    }
  }

  @override
  Future<Either<Failure, AddressSingleResponse>> createAddress(AddressRequestBody body) async {
    try {
      final response = await _apiConsumer.post(
        path: ApiConstant.addresses,
        body: body.toJson(),
      );
      return Right(AddressSingleResponse.fromJson(response));
    } on ServerFailure catch (failure) {
      return Left(failure);
    } catch (error) {
      return Left(ServerFailure("حدث خطأ غير متوقع: $error"));
    }
  }

  @override
  Future<Either<Failure, AddressSingleResponse>> updateAddress(int id, AddressRequestBody body) async {
    try {
      final response = await _apiConsumer.post(
        path: '${ApiConstant.addresses}/$id',
        body: {
          ...body.toJson(),
          '_method': 'PUT',
        },
      );
      return Right(AddressSingleResponse.fromJson(response));
    } on ServerFailure catch (failure) {
      return Left(failure);
    } catch (error) {
      return Left(ServerFailure("حدث خطأ غير متوقع: $error"));
    }
  }

  @override
  Future<Either<Failure, AddressSingleResponse>> deleteAddress(int id) async {
    try {
      final response = await _apiConsumer.delete(path: '${ApiConstant.addresses}/$id');
      return Right(AddressSingleResponse.fromJson(response));
    } on ServerFailure catch (failure) {
      return Left(failure);
    } catch (error) {
      return Left(ServerFailure("حدث خطأ غير متوقع: $error"));
    }
  }
}
