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
    if (!isClosed) emit(NotificationSettingsLoading());
    final result = await _getSettingsUseCase();
    result.fold(
      (failure) {
        if (!isClosed) emit(NotificationSettingsError(failure.errorMessage));
      },
      (settings) {
        currentSettings = settings;
        if (!isClosed) emit(NotificationSettingsLoaded(settings));
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
    if (!isClosed) emit(NotificationSettingsUpdating(newSettings));
    final result = await _updateSettingsUseCase(newSettings);
    result.fold(
      (failure) {
        if (!isClosed) emit(NotificationSettingsError(failure.errorMessage));
        if (currentSettings != null && !isClosed) {
          emit(NotificationSettingsLoaded(currentSettings!));
        }
      },
      (settings) {
        currentSettings = settings;
        if (!isClosed) {
          emit(NotificationSettingsUpdateSuccess(settings, "تم تحديث الإعدادات بنجاح"));
          emit(NotificationSettingsLoaded(settings));
        }
      },
    );
  }
}
