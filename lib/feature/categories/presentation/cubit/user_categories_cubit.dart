import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primo/core/models/category_model.dart';
import 'package:primo/core/network/app_storage.dart';
import 'package:primo/feature/categories/domain/usecases/get_user_categories_usecase.dart';
import 'package:primo/feature/categories/presentation/cubit/user_categories_state.dart';

class UserCategoriesCubit extends Cubit<UserCategoriesState> {
  final GetUserCategoriesUseCase _getUserCategoriesUseCase;
  List<CategoryModel> categories = [];

  UserCategoriesCubit(this._getUserCategoriesUseCase)
    : super(UserCategoriesInitial());

  Future<void> fetchCategories() async {
    bool hasCache = false;
    try {
      final cached = await AppStorage.getCachedData('cache_user_categories');
      if (cached != null) {
        final List<dynamic> jsonList = jsonDecode(cached);
        categories =
            jsonList.map((e) => CategoryModel.fromJson(e)).toList();
        hasCache = true;
        if (!isClosed) emit(UserCategoriesLoaded(categories));
      }
    } catch (_) {}

    if (!hasCache && !isClosed) {
      emit(UserCategoriesLoading());
    }

    final result = await _getUserCategoriesUseCase.execute();
    result.fold(
      (failure) {
        if (!hasCache && !isClosed) {
          emit(UserCategoriesError(failure.errorMessage));
        }
      },
      (list) {
        categories = list;
        try {
          final jsonString =
              jsonEncode(list.map((e) => e.toJson()).toList());
          AppStorage.cacheData('cache_user_categories', jsonString);
        } catch (_) {}
        if (!isClosed) {
          emit(UserCategoriesLoaded(list));
        }
      },
    );
  }
}
