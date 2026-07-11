import 'package:equatable/equatable.dart';
import 'package:primo/feature/admin_settings/data/models/store_settings_model.dart';

abstract class StoreSettingsState extends Equatable {
  const StoreSettingsState();

  @override
  List<Object?> get props => [];
}

class StoreSettingsInitial extends StoreSettingsState {}

class StoreSettingsLoading extends StoreSettingsState {}

class StoreSettingsLoaded extends StoreSettingsState {
  final DeliveryPriceModel deliveryPriceModel;

  const StoreSettingsLoaded(this.deliveryPriceModel);

  @override
  List<Object?> get props => [deliveryPriceModel];
}

class StoreSettingsUpdating extends StoreSettingsState {}

class StoreSettingsUpdateSuccess extends StoreSettingsState {
  final String message;

  const StoreSettingsUpdateSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class StoreSettingsError extends StoreSettingsState {
  final String message;

  const StoreSettingsError(this.message);

  @override
  List<Object?> get props => [message];
}
