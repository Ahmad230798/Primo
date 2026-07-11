import 'package:equatable/equatable.dart';

abstract class AddStoreAddressState extends Equatable {
  const AddStoreAddressState();

  @override
  List<Object?> get props => [];
}

class AddStoreAddressInitial extends AddStoreAddressState {}

class AddStoreAddressLoading extends AddStoreAddressState {}

class AddStoreAddressSuccess extends AddStoreAddressState {
  final String message;

  const AddStoreAddressSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class AddStoreAddressError extends AddStoreAddressState {
  final String message;

  const AddStoreAddressError(this.message);

  @override
  List<Object?> get props => [message];
}
