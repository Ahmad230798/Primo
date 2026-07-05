import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primo/feature/categories/domain/usecases/get_category_products_usecase.dart';
import 'category_products_state.dart';

class CategoryProductsCubit extends Cubit<CategoryProductsState> {
  final GetCategoryProductsUseCase _getCategoryProductsUseCase;

  CategoryProductsCubit(this._getCategoryProductsUseCase) : super(CategoryProductsInitial());

  Future<void> fetchCategoryProducts(int categoryId, {String? categoryName}) async {
    emit(CategoryProductsLoading());
    final result = await _getCategoryProductsUseCase.execute(categoryId, categoryName: categoryName);
    result.fold(
      (failure) => emit(CategoryProductsError(failure.errorMessage)),
      (products) => emit(CategoryProductsLoaded(products)),
    );
  }
}
