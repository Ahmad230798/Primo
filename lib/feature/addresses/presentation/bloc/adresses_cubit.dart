import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/address_model.dart';
import '../../data/models/address_request_body.dart';
import '../../domain/usecases/create_address_usecase.dart';
import '../../domain/usecases/delete_address_usecase.dart';
import '../../domain/usecases/get_address_by_id_usecase.dart';
import '../../domain/usecases/get_addresses_usecase.dart';
import '../../domain/usecases/update_address_usecase.dart';
import 'adresses_state.dart';

class AddressesCubit extends Cubit<AddressesState> {
  final GetAddressesUseCase _getAddressesUseCase;
  final GetAddressByIdUseCase _getAddressByIdUseCase;
  final CreateAddressUseCase _createAddressUseCase;
  final UpdateAddressUseCase _updateAddressUseCase;
  final DeleteAddressUseCase _deleteAddressUseCase;

  List<AddressModel> addresses = [];
  int? defaultAddressId;

  AddressesCubit(
    this._getAddressesUseCase,
    this._getAddressByIdUseCase,
    this._createAddressUseCase,
    this._updateAddressUseCase,
    this._deleteAddressUseCase,
  ) : super(AddressesInitial()) {
    getAddresses();
  }

  Future<void> getAddresses({bool showLoading = true}) async {
    if (showLoading || addresses.isEmpty) {
      emit(AddressesLoading());
    }
    final result = await _getAddressesUseCase.execute();
    result.fold(
      (failure) => emit(AddressesError(message: failure.errorMessage)),
      (response) {
        addresses = response.data;
        if (addresses.isNotEmpty) {
          if (defaultAddressId == null || !addresses.any((a) => a.id == defaultAddressId)) {
            final defaultAddr = addresses.firstWhere(
              (a) => a.isDefault,
              orElse: () => addresses.first,
            );
            defaultAddressId = defaultAddr.id;
          }
        } else {
          defaultAddressId = null;
        }
        emit(AddressesLoaded(addresses: addresses, defaultAddressId: defaultAddressId));
      },
    );
  }

  Future<AddressModel?> getAddressById(int id) async {
    final result = await _getAddressByIdUseCase.execute(id);
    return result.fold(
      (failure) => null,
      (response) => response.data,
    );
  }

  Future<void> createAddress({
    required String name,
    required String description,
    required String locationLat,
    required String locationLng,
  }) async {
    emit(AddressActionLoading());
    final body = AddressRequestBody(
      name: name,
      description: description,
      locationLat: locationLat,
      locationLng: locationLng,
    );
    final result = await _createAddressUseCase.execute(body);
    result.fold(
      (failure) {
        emit(AddressActionError(message: failure.errorMessage));
        emit(AddressesLoaded(addresses: addresses, defaultAddressId: defaultAddressId));
      },
      (response) {
        emit(const AddressActionSuccess(message: "تم إضافة العنوان بنجاح"));
        getAddresses(showLoading: false);
      },
    );
  }

  Future<void> updateAddress({
    required int id,
    required String name,
    required String description,
    required String locationLat,
    required String locationLng,
  }) async {
    emit(AddressActionLoading());
    final body = AddressRequestBody(
      name: name,
      description: description,
      locationLat: locationLat,
      locationLng: locationLng,
    );
    final result = await _updateAddressUseCase.execute(id, body);
    result.fold(
      (failure) {
        emit(AddressActionError(message: failure.errorMessage));
        emit(AddressesLoaded(addresses: addresses, defaultAddressId: defaultAddressId));
      },
      (response) {
        emit(const AddressActionSuccess(message: "تم تعديل العنوان بنجاح"));
        getAddresses(showLoading: false);
      },
    );
  }

  Future<void> deleteAddress(int id) async {
    emit(AddressActionLoading());
    final result = await _deleteAddressUseCase.execute(id);
    result.fold(
      (failure) {
        emit(AddressActionError(message: failure.errorMessage));
        emit(AddressesLoaded(addresses: addresses, defaultAddressId: defaultAddressId));
      },
      (response) {
        if (defaultAddressId == id) {
          defaultAddressId = null;
        }
        emit(const AddressActionSuccess(message: "تم حذف العنوان بنجاح"));
        getAddresses(showLoading: false);
      },
    );
  }

  void setDefaultAddress(int? selectedId) {
    if (selectedId == null) return;
    defaultAddressId = selectedId;
    for (var a in addresses) {
      a.isDefault = (a.id == selectedId);
    }
    emit(AddressesLoaded(addresses: addresses, defaultAddressId: defaultAddressId));
  }
}
