import 'package:dartz/dartz.dart';
import 'package:primo/core/network/api_error_handler.dart';
import 'package:primo/feature/home/data/models/home_data_model.dart';

abstract class HomeRepo {
  Future<Either<Failure, HomeDataModel>> getHomeData({String? search});
}
