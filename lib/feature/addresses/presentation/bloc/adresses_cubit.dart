import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primo/core/network/app_storage.dart';
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
      (response) async {
        addresses = response.data;
        if (addresses.isNotEmpty) {
          // 💡 جلب المعرف الافتراضي المحفوظ في ذاكرة الهاتف
          // (افترض أنك أضفت هذه الدالة في AppStorage لقراءة الرقم المحفوظ)
          final int? savedDefaultId = await AppStorage.getDefaultAddressId();
          if (savedDefaultId != null) {
            defaultAddressId = savedDefaultId;
          } else {
            if (defaultAddressId == null ||
                !addresses.any((a) => a.id == defaultAddressId)) {
              final defaultAddr = addresses.firstWhere(
                (a) => a.isDefault,
                orElse: () => addresses.first,
              );
              defaultAddressId = defaultAddr.id;
            }
          }
        } else {
          defaultAddressId = null;
        }
        emit(
          AddressesLoaded(
            addresses: addresses,
            defaultAddressId: defaultAddressId,
          ),
        );
      },
    );
  }

  Future<AddressModel?> getAddressById(int id) async {
    final result = await _getAddressByIdUseCase.execute(id);
    return result.fold((failure) => null, (response) => response.data);
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
        emit(
          AddressesLoaded(
            addresses: addresses,
            defaultAddressId: defaultAddressId,
          ),
        );
      },
      (response) async {
        // 💡 التعديل 2: ننتظر جلب القائمة الجديدة من السيرفر أولاً
        await getAddresses(showLoading: false);

        // 💡 التعديل 3: نرسل حالة النجاح لكي يستمع لها الشيت ويغلق نفسه
        emit(const AddressActionSuccess(message: "تم إضافة العنوان بنجاح"));

        // 💡 التعديل 4: نؤكد إرسال حالة الـ Loaded لكي تبني شاشة الـ Checkout القائمة الجديدة فوراً
        emit(
          AddressesLoaded(
            addresses: addresses,
            defaultAddressId: defaultAddressId,
          ),
        );

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
        emit(
          AddressesLoaded(
            addresses: addresses,
            defaultAddressId: defaultAddressId,
          ),
        );
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
        emit(
          AddressesLoaded(
            addresses: addresses,
            defaultAddressId: defaultAddressId,
          ),
        );
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

  void setDefaultAddress(int? selectedId) async {
    if (selectedId == null) return;
    defaultAddressId = selectedId;
    for (var a in addresses) {
      a.isDefault = (a.id == selectedId);
    }
    await AppStorage.saveDefaultAddressId(selectedId);
    emit(
      AddressesLoaded(addresses: addresses, defaultAddressId: defaultAddressId),
    );
  }
}
