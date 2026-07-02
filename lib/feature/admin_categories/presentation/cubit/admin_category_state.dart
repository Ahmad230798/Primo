import 'dart:io';
import 'package:equatable/equatable.dart';

sealed class AdminCategoryState extends Equatable {
  const AdminCategoryState();
  @override
  List<Object?> get props => [];
}

final class AdminCategoryInitial extends AdminCategoryState {}

final class AdminCategoryLoading extends AdminCategoryState {}

final class AdminCategorySuccess extends AdminCategoryState {}

final class AdminCategoryError extends AdminCategoryState {
  final String error;
  const AdminCategoryError(this.error);
  @override
  List<Object?> get props => [error];
}

final class AdminCategoryImagePicked extends AdminCategoryState {
  final File image;
  const AdminCategoryImagePicked(this.image);
  @override
  List<Object?> get props => [image];
}
