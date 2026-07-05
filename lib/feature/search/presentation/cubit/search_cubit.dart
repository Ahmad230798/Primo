import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primo/core/models/product_model.dart';
import 'package:primo/feature/home/domain/usecases/get_home_data_usecase.dart';
import 'package:primo/feature/search/presentation/cubit/search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final GetHomeDataUseCase _getHomeDataUseCase;
  List<ProductModel> products = [];

  SearchCubit(this._getHomeDataUseCase) : super(SearchInitial());

  Future<void> searchProducts(String query) async {
    if (query.trim().isEmpty) {
      emit(SearchInitial());
      return;
    }
    emit(SearchLoading());
    final result = await _getHomeDataUseCase.execute(search: query);
    result.fold(
      (failure) => emit(SearchError(failure.errorMessage)),
      (data) {
        products = data.products;
        emit(SearchLoaded(products));
      },
    );
  }
}
