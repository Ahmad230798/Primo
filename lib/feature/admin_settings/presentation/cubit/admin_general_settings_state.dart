import 'package:primo/feature/profile/data/models/help_center_model.dart';

abstract class AdminGeneralSettingsState {
  const AdminGeneralSettingsState();
}

class AdminGeneralSettingsInitial extends AdminGeneralSettingsState {}

class AdminGeneralSettingsLoading extends AdminGeneralSettingsState {}

class AdminGeneralSettingsLoaded extends AdminGeneralSettingsState {
  final HelpCenterModel model;
  const AdminGeneralSettingsLoaded(this.model);
}

class AdminGeneralSettingsUpdating extends AdminGeneralSettingsState {}

class AdminGeneralSettingsSuccess extends AdminGeneralSettingsState {
  final String message;
  const AdminGeneralSettingsSuccess(this.message);
}

class AdminGeneralSettingsError extends AdminGeneralSettingsState {
  final String message;
  const AdminGeneralSettingsError(this.message);
}
