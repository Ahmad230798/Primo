import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primo/core/models/category_model.dart';
import '../../domain/usecases/manage_category_usecase.dart';
import 'admin_categories_list_state.dart';

class AdminCategoriesListCubit extends Cubit<AdminCategoriesListState> {
  final ManageCategoryUseCase _useCase;
  List<CategoryModel> categories = [];

  AdminCategoriesListCubit(this._useCase)
      : super(AdminCategoriesListInitial());

  Future<void> getCategories() async {
    emit(AdminCategoriesListLoading());
    final result = await _useCase.getAllCategories();
    result.fold(
      (failure) => emit(AdminCategoriesListError(failure.errorMessage)),
      (data) {
        categories = data;
        emit(AdminCategoriesListLoaded(categories));
      },
    );
  }

  Future<void> deleteCategory(int categoryId) async {
    final result = await _useCase.deleteCategory(categoryId);
    result.fold(
      (failure) => emit(AdminCategoriesListError(failure.errorMessage)),
      (success) {
        categories.removeWhere((c) => c.id == categoryId);
        emit(const AdminCategoryDeleteSuccess("تم حذف القسم بنجاح"));
        emit(AdminCategoriesListLoaded(categories));
      },
    );
  }
}
