import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primo/core/network/app_storage.dart';
import 'package:primo/feature/home/data/models/home_data_model.dart';
import 'package:primo/feature/home/domain/usecases/get_home_data_usecase.dart';
import 'package:primo/feature/home/presentation/cubit/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetHomeDataUseCase _getHomeDataUseCase;
  HomeDataModel? homeData;

  HomeCubit(this._getHomeDataUseCase) : super(HomeInitial());

  Future<void> fetchHomeData({bool isRefresh = false}) async {
    if (homeData != null && !isRefresh && state is! HomeError) {
      if (!isClosed) emit(HomeLoaded(homeData!));
      return;
    }
    if (homeData == null) {
      try {
        final cached = await AppStorage.getCachedData('cache_user_home');
        if (cached != null) {
          final rawData = jsonDecode(cached);
          homeData = HomeDataModel.fromJson(rawData);
          if (!isClosed) emit(HomeLoaded(homeData!));
        }
      } catch (_) {}
    }
    if (homeData == null) {
      if (!isClosed) emit(HomeLoading());
    }
    final result = await _getHomeDataUseCase.execute();
    result.fold(
      (failure) {
        if (homeData == null && !isClosed) emit(HomeError(failure.errorMessage));
      },
      (data) {
        homeData = data;
        if (!isClosed) emit(HomeLoaded(data));
      },
    );
  }
}
