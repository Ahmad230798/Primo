import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primo/core/network/api_consumer.dart';
import 'package:primo/core/network/api_constant.dart';
import 'package:primo/feature/profile/data/models/help_center_model.dart';
import 'admin_general_settings_state.dart';

class AdminGeneralSettingsCubit extends Cubit<AdminGeneralSettingsState> {
  final ApiConsumer _apiConsumer;

  AdminGeneralSettingsCubit(this._apiConsumer) : super(AdminGeneralSettingsInitial());

  Future<void> getGeneralSettings() async {
    emit(AdminGeneralSettingsLoading());
    try {
      final response = await _apiConsumer.get(path: ApiConstant.adminGeneralSettings);
      if (response is Map<String, dynamic>) {
        final model = HelpCenterModel.fromJson(response);
        emit(AdminGeneralSettingsLoaded(model));
      } else {
        emit(const AdminGeneralSettingsLoaded(HelpCenterModel(
          supportPhone: '',
          managerPhone: '',
          facebookAccount: '',
          workingHours: '',
          address: '',
        )));
      }
    } catch (e) {
      emit(const AdminGeneralSettingsLoaded(HelpCenterModel(
        supportPhone: '',
        managerPhone: '',
        facebookAccount: '',
        workingHours: '',
        address: '',
      )));
    }
  }

  Future<void> updateGeneralSettings({
    required String supportPhone,
    required String managerPhone,
    required String facebookAccount,
    required String workingHours,
    required String address,
  }) async {
    emit(AdminGeneralSettingsUpdating());
    try {
      await _apiConsumer.post(
        path: ApiConstant.adminGeneralSettings,
        body: {
          'customer_service_phone': supportPhone,
          'admin_phone': managerPhone,
          'facebook_account': facebookAccount,
          'working_hours': workingHours,
          'location': address,
        },
      );
      emit(const AdminGeneralSettingsSuccess("تم تحديث الإعدادات العامة بنجاح"));
      // reload
      final updatedModel = HelpCenterModel(
        supportPhone: supportPhone,
        managerPhone: managerPhone,
        facebookAccount: facebookAccount,
        workingHours: workingHours,
        address: address,
      );
      emit(AdminGeneralSettingsLoaded(updatedModel));
    } catch (e) {
      emit(AdminGeneralSettingsError("فشل تحديث الإعدادات: $e"));
    }
  }
}
