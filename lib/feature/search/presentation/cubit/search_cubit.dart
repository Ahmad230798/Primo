import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primo/core/models/product_model.dart';
import 'package:primo/feature/home/domain/usecases/get_home_data_usecase.dart';
import 'package:primo/feature/search/presentation/cubit/search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final GetHomeDataUseCase _getHomeDataUseCase;
  List<ProductModel> products = [];

  SearchCubit(this._getHomeDataUseCase) : super(SearchInitial());

  String activeFilter = "الكل";

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
        applyFilter(activeFilter);
      },
    );
  }

  void applyFilter(String filter) {
    activeFilter = filter;
    if (products.isEmpty) {
      emit(SearchLoaded(products));
      return;
    }
    List<ProductModel> sorted = List.from(products);
    if (filter == "الأعلى تقييماً") {
      sorted.sort((a, b) {
        final rateA = double.tryParse(a.ratings?.toString() ?? '0') ?? 0;
        final rateB = double.tryParse(b.ratings?.toString() ?? '0') ?? 0;
        return rateB.compareTo(rateA);
      });
    } else if (filter == "الأقل سعراً") {
      sorted.sort((a, b) {
        final priceA = double.tryParse(a.displayPrice) ?? 0;
        final priceB = double.tryParse(b.displayPrice) ?? 0;
        return priceA.compareTo(priceB);
      });
    } else if (filter == "الأعلى سعراً") {
      sorted.sort((a, b) {
        final priceA = double.tryParse(a.displayPrice) ?? 0;
        final priceB = double.tryParse(b.displayPrice) ?? 0;
        return priceB.compareTo(priceA);
      });
    } else if (filter == "وصل حديثاً") {
      sorted.sort((a, b) => (b.id ?? 0).compareTo(a.id ?? 0));
    }
    emit(SearchLoaded(sorted));
  }
}
