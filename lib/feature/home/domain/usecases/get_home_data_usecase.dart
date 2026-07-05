import 'package:dartz/dartz.dart';
import 'package:primo/core/network/api_error_handler.dart';
import 'package:primo/feature/home/data/models/home_data_model.dart';
import 'package:primo/feature/home/domain/repo/home_repo.dart';

class GetHomeDataUseCase {
  final HomeRepo _repo;

  GetHomeDataUseCase(this._repo);

  Future<Either<Failure, HomeDataModel>> execute({String? search}) async {
    return await _repo.getHomeData(search: search);
  }
}
