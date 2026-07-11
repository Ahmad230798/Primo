import 'package:equatable/equatable.dart';
import 'package:primo/core/models/category_model.dart';

sealed class AdminCategoriesListState extends Equatable {
  const AdminCategoriesListState();

  @override
  List<Object?> get props => [];
}

final class AdminCategoriesListInitial extends AdminCategoriesListState {}

final class AdminCategoriesListLoading extends AdminCategoriesListState {}

final class AdminCategoriesListLoaded extends AdminCategoriesListState {
  final List<CategoryModel> categories;
  const AdminCategoriesListLoaded(this.categories);

  @override
  List<Object?> get props => [categories];
}

final class AdminCategoriesListError extends AdminCategoriesListState {
  final String message;
  const AdminCategoriesListError(this.message);

  @override
  List<Object?> get props => [message];
}

final class AdminCategoryDeleteSuccess extends AdminCategoriesListState {
  final String message;
  const AdminCategoryDeleteSuccess(this.message);

  @override
  List<Object?> get props => [message];
}
