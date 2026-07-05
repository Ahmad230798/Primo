import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primo/feature/home/data/models/home_data_model.dart';
import 'package:primo/feature/home/domain/usecases/get_home_data_usecase.dart';
import 'package:primo/feature/home/presentation/cubit/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetHomeDataUseCase _getHomeDataUseCase;
  HomeDataModel? homeData;

  HomeCubit(this._getHomeDataUseCase) : super(HomeInitial());

  Future<void> fetchHomeData({bool isRefresh = false}) async {
    if (homeData != null && !isRefresh && state is! HomeError) {
      emit(HomeLoaded(homeData!));
      return;
    }
    emit(HomeLoading());
    final result = await _getHomeDataUseCase.execute();
    result.fold(
      (failure) => emit(HomeError(failure.errorMessage)),
      (data) {
        homeData = data;
        emit(HomeLoaded(data));
      },
    );
  }
}
