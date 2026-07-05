import 'package:primo/core/models/category_model.dart';

abstract class UserCategoriesState {}

class UserCategoriesInitial extends UserCategoriesState {}

class UserCategoriesLoading extends UserCategoriesState {}

class UserCategoriesLoaded extends UserCategoriesState {
  final List<CategoryModel> categories;
  UserCategoriesLoaded(this.categories);
}

class UserCategoriesError extends UserCategoriesState {
  final String errorMessage;
  UserCategoriesError(this.errorMessage);
}
