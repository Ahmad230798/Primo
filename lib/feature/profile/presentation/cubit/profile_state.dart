import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:primo/core/models/user_model.dart';
import 'package:primo/feature/profile/data/models/profile_response.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileAvatarPicked extends ProfileState {
  final File avatar;
  const ProfileAvatarPicked(this.avatar);

  @override
  List<Object?> get props => [avatar];
}

class ProfileLoaded extends ProfileState {
  final UserModel user;
  const ProfileLoaded(this.user);

  @override
  List<Object?> get props => [user];
}

class ProfileError extends ProfileState {
  final String message;
  const ProfileError(this.message);

  @override
  List<Object?> get props => [message];
}

class UpdateProfileLoading extends ProfileState {}

class UpdateProfileSuccess extends ProfileState {
  final UserModel user;
  final String message;
  const UpdateProfileSuccess(this.user, this.message);

  @override
  List<Object?> get props => [user, message];
}

class UpdateProfileError extends ProfileState {
  final String message;
  const UpdateProfileError(this.message);

  @override
  List<Object?> get props => [message];
}

class ChangePasswordLoading extends ProfileState {}

class ChangePasswordSuccess extends ProfileState {
  final String message;
  const ChangePasswordSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class ChangePasswordError extends ProfileState {
  final String message;
  const ChangePasswordError(this.message);

  @override
  List<Object?> get props => [message];
}

class DeleteAccountLoading extends ProfileState {}

class DeleteAccountSuccess extends ProfileState {
  final String message;
  const DeleteAccountSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class DeleteAccountError extends ProfileState {
  final String message;
  const DeleteAccountError(this.message);

  @override
  List<Object?> get props => [message];
}

class LogoutLoading extends ProfileState {}

class LogoutSuccess extends ProfileState {
  final String message;
  const LogoutSuccess(this.message);
}

class LogoutError extends ProfileState {
  final String message;
  const LogoutError(this.message);
}
