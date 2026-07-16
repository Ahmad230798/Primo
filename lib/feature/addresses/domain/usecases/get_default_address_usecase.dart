import '../repo/addresses_repo.dart';

class GetDefaultAddressUseCase {
  final AddressesRepo _repo;
  GetDefaultAddressUseCase(this._repo);

  Future<int?> call() async {
    return await _repo.getDefaultAddressId();
  }
}