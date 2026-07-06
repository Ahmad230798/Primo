import 'package:equatable/equatable.dart';
import 'package:primo/feature/notifications/data/models/notification_settings_model.dart';

abstract class NotificationSettingsState extends Equatable {
  const NotificationSettingsState();

  @override
  List<Object?> get props => [];
}

class NotificationSettingsInitial extends NotificationSettingsState {}

class NotificationSettingsLoading extends NotificationSettingsState {}

class NotificationSettingsLoaded extends NotificationSettingsState {
  final NotificationSettingsModel settings;

  const NotificationSettingsLoaded(this.settings);

  @override
  List<Object?> get props => [settings];
}

class NotificationSettingsUpdating extends NotificationSettingsState {
  final NotificationSettingsModel currentSettings;

  const NotificationSettingsUpdating(this.currentSettings);

  @override
  List<Object?> get props => [currentSettings];
}

class NotificationSettingsUpdateSuccess extends NotificationSettingsState {
  final NotificationSettingsModel settings;
  final String message;

  const NotificationSettingsUpdateSuccess(this.settings, this.message);

  @override
  List<Object?> get props => [settings, message];
}

class NotificationSettingsError extends NotificationSettingsState {
  final String message;

  const NotificationSettingsError(this.message);

  @override
  List<Object?> get props => [message];
}
