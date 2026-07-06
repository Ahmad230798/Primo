import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primo/feature/notifications/data/models/notification_settings_model.dart';
import 'package:primo/feature/notifications/domain/usecases/get_notification_settings_usecase.dart';
import 'package:primo/feature/notifications/domain/usecases/update_notification_settings_usecase.dart';
import 'notification_settings_state.dart';

class NotificationSettingsCubit extends Cubit<NotificationSettingsState> {
  final GetNotificationSettingsUseCase _getSettingsUseCase;
  final UpdateNotificationSettingsUseCase _updateSettingsUseCase;

  NotificationSettingsModel? currentSettings;

  NotificationSettingsCubit(
    this._getSettingsUseCase,
    this._updateSettingsUseCase,
  ) : super(NotificationSettingsInitial()) {
    getSettings();
  }

  Future<void> getSettings() async {
    emit(NotificationSettingsLoading());
    final result = await _getSettingsUseCase();
    result.fold(
      (failure) => emit(NotificationSettingsError(failure.errorMessage)),
      (settings) {
        currentSettings = settings;
        emit(NotificationSettingsLoaded(settings));
      },
    );
  }

  Future<void> updateSettings({
    bool? offerEnabled,
    bool? orderEnabled,
  }) async {
    if (currentSettings == null) return;
    final newSettings = currentSettings!.copyWith(
      notificationOffer: offerEnabled,
      notificationOrder: orderEnabled,
    );
    emit(NotificationSettingsUpdating(newSettings));
    final result = await _updateSettingsUseCase(newSettings);
    result.fold(
      (failure) {
        emit(NotificationSettingsError(failure.errorMessage));
        if (currentSettings != null) {
          emit(NotificationSettingsLoaded(currentSettings!));
        }
      },
      (settings) {
        currentSettings = settings;
        emit(NotificationSettingsUpdateSuccess(settings, "تم تحديث الإعدادات بنجاح"));
        emit(NotificationSettingsLoaded(settings));
      },
    );
  }
}
