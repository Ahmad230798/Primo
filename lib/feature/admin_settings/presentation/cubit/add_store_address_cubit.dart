import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primo/feature/admin_settings/data/models/store_settings_model.dart';
import 'package:primo/feature/admin_settings/domain/usecases/add_store_address_usecase.dart';
import 'package:primo/feature/admin_settings/presentation/cubit/add_store_address_state.dart';

class AddStoreAddressCubit extends Cubit<AddStoreAddressState> {
  final AddStoreAddressUseCase _addStoreAddressUseCase;

  AddStoreAddressCubit(this._addStoreAddressUseCase) : super(AddStoreAddressInitial());

  Future<void> addStoreAddress({
    required String description,
    required double locationLat,
    required double locationLng,
  }) async {
    emit(AddStoreAddressLoading());
    final request = AddStoreAddressRequest(
      description: description,
      locationLat: locationLat,
      locationLng: locationLng,
    );
    final result = await _addStoreAddressUseCase(request);
    result.fold(
      (failure) => emit(AddStoreAddressError(failure.errorMessage)),
      (_) => emit(const AddStoreAddressSuccess("تم تحديث الإعدادات بنجاح")),
    );
  }
}
