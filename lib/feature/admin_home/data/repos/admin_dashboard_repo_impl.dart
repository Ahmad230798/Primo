import 'package:dartz/dartz.dart';
import 'package:primo/core/network/api_consumer.dart';
import 'package:primo/core/network/api_constant.dart';
import 'package:primo/core/network/api_error_handler.dart';
import 'package:primo/feature/admin_home/data/models/admin_dashboard_model.dart';
import 'package:primo/feature/admin_home/domain/repos/admin_dashboard_repo.dart';

class AdminDashboardRepoImpl implements AdminDashboardRepo {
  final ApiConsumer _apiConsumer;

  AdminDashboardRepoImpl(this._apiConsumer);

  @override
  Future<Either<Failure, AdminDashboardModel>> getDashboard() async {
    try {
      final response = await _apiConsumer.get(path: ApiConstant.adminHome);
      final data = response['data'] ?? response;
      if (data is Map<String, dynamic>) {
        return Right(AdminDashboardModel.fromJson(data));
      }
      return Right(AdminDashboardModel.fromJson({}));
    } on ServerFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure("حدث خطأ غير متوقع: $e"));
    }
  }
}
