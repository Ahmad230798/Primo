import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primo/core/models/category_model.dart';
import 'package:primo/core/network/app_storage.dart';
import '../../domain/usecases/manage_category_usecase.dart';
import 'admin_categories_list_state.dart';

class AdminCategoriesListCubit extends Cubit<AdminCategoriesListState> {
  final ManageCategoryUseCase _useCase;
  List<CategoryModel> categories = [];

  AdminCategoriesListCubit(this._useCase) : super(AdminCategoriesListInitial());

  Future<void> getCategories() async {
    bool hasCache = false;
    try {
      final cached = await AppStorage.getCachedData('cache_admin_categories');
      if (cached != null) {
        final List<dynamic> jsonList = jsonDecode(cached);
        categories = jsonList.map((e) => CategoryModel.fromJson(e)).toList();
        hasCache = true;
        if (!isClosed) emit(AdminCategoriesListLoaded(categories));
      }
    } catch (_) {}

    if (!hasCache && !isClosed) {
      emit(AdminCategoriesListLoading());
    }

    try {
      final result = await _useCase.getAllCategories();
      result.fold(
        (failure) {
          if (!hasCache && !isClosed) {
            emit(AdminCategoriesListError(failure.errorMessage));
          }
        },
        (data) {
          categories = data;
          try {
            final jsonString = jsonEncode(data.map((e) => e.toJson()).toList());
            AppStorage.cacheData('cache_admin_categories', jsonString);
          } catch (_) {}
          if (!isClosed) emit(AdminCategoriesListLoaded(categories));
        },
      );
    } catch (e) {
      if (!hasCache && !isClosed) {
        emit(AdminCategoriesListError(e.toString()));
      }
    }
  }

  Future<void> deleteCategory(int categoryId) async {
    try {
      final result = await _useCase.deleteCategory(categoryId);
      result.fold(
        (failure) => emit(AdminCategoriesListError(failure.errorMessage)),
        (success) {
          // 1. حذف القسم من القائمة المحلية
          categories.removeWhere((c) => c.id == categoryId);

          // 💡 2. التعديل هنا: تحديث الـ Cache فوراً لكي لا يظهر القسم مجدداً عند عمل Refresh
          try {
            final jsonString = jsonEncode(
              categories.map((e) => e.toJson()).toList(),
            );
            AppStorage.cacheData('cache_admin_categories', jsonString);
          } catch (_) {}

          // 3. إرسال حالة النجاح وتحديث الشاشة
          emit(const AdminCategoryDeleteSuccess("تم حذف القسم بنجاح"));
          emit(AdminCategoriesListLoaded(categories));
        },
      );
    } catch (e) {
      if (!isClosed) emit(AdminCategoriesListError(e.toString()));
    }
  }
}
