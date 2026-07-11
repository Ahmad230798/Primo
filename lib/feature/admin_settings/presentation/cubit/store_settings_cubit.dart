import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primo/feature/admin_settings/domain/usecases/get_delivery_price_usecase.dart';
import 'package:primo/feature/admin_settings/domain/usecases/update_delivery_price_usecase.dart';
import 'package:primo/feature/admin_settings/presentation/cubit/store_settings_state.dart';

class StoreSettingsCubit extends Cubit<StoreSettingsState> {
  final GetDeliveryPriceUseCase _getDeliveryPriceUseCase;
  final UpdateDeliveryPriceUseCase _updateDeliveryPriceUseCase;

  StoreSettingsCubit(
    this._getDeliveryPriceUseCase,
    this._updateDeliveryPriceUseCase,
  ) : super(StoreSettingsInitial());

  Future<void> getDeliveryPrice() async {
    emit(StoreSettingsLoading());
    final result = await _getDeliveryPriceUseCase();
    result.fold(
      (failure) => emit(StoreSettingsError(failure.errorMessage)),
      (model) => emit(StoreSettingsLoaded(model)),
    );
  }

  Future<void> updateDeliveryPrice(num price) async {
    emit(StoreSettingsUpdating());
    final result = await _updateDeliveryPriceUseCase(price);
    result.fold(
      (failure) => emit(StoreSettingsError(failure.errorMessage)),
      (_) {
        emit(const StoreSettingsUpdateSuccess("تم تحديث الإعدادات بنجاح"));
        getDeliveryPrice();
      },
    );
  }
}
