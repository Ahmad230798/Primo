import 'package:equatable/equatable.dart';
import '../../data/models/address_model.dart';

sealed class AddressesState extends Equatable {
  const AddressesState();

  @override
  List<Object?> get props => [];
}

final class AddressesInitial extends AddressesState {}

final class AddressesLoading extends AddressesState {}

final class AddressesLoaded extends AddressesState {
  final List<AddressModel> addresses;
  final int? defaultAddressId;

  const AddressesLoaded({required this.addresses, this.defaultAddressId});

  @override
  List<Object?> get props => [addresses, defaultAddressId];
}

final class AddressesError extends AddressesState {
  final String message;

  const AddressesError({required this.message});

  @override
  List<Object?> get props => [message];
}

final class AddressActionLoading extends AddressesState {}

final class AddressActionSuccess extends AddressesState {
  final String message;

  const AddressActionSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

final class AddressActionError extends AddressesState {
  final String message;

  const AddressActionError({required this.message});

  @override
  List<Object?> get props => [message];
}
