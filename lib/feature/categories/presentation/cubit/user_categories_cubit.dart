import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primo/core/models/category_model.dart';
import 'package:primo/feature/categories/domain/usecases/get_user_categories_usecase.dart';
import 'package:primo/feature/categories/presentation/cubit/user_categories_state.dart';

class UserCategoriesCubit extends Cubit<UserCategoriesState> {
  final GetUserCategoriesUseCase _getUserCategoriesUseCase;
  List<CategoryModel> categories = [];

  UserCategoriesCubit(this._getUserCategoriesUseCase)
    : super(UserCategoriesInitial());

  Future<void> fetchCategories() async {
    if (categories.isNotEmpty) {
      if (!isClosed) {
        emit(UserCategoriesLoaded(categories));
        return;
      }
    }
    emit(UserCategoriesLoading());
    final result = await _getUserCategoriesUseCase.execute();
    result.fold(
      (failure) {
        // 💡 حماية الكيوبت في حال تم إغلاقه قبل وصول رسالة الخطأ
        if (!isClosed) {
          emit(UserCategoriesError(failure.errorMessage));
        }
      },
      (list) {
        categories = list;
        if (!isClosed) {
          emit(UserCategoriesLoaded(list));
        }
      },
    );
  }
}
