import '../repo/addresses_repo.dart';

class SaveDefaultAddressUseCase {
  final AddressesRepo _repo;
  SaveDefaultAddressUseCase(this._repo);

  Future<void> call(int id) async {
    return await _repo.saveDefaultAddressId(id);
  }
}