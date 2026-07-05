import 'package:primo/feature/home/data/models/home_data_model.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final HomeDataModel data;
  HomeLoaded(this.data);
}

class HomeError extends HomeState {
  final String errorMessage;
  HomeError(this.errorMessage);
}
