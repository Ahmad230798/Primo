import 'package:dartz/dartz.dart';
import 'package:primo/core/network/api_error_handler.dart';
import 'package:primo/feature/admin_home/data/models/admin_dashboard_model.dart';
import 'package:primo/feature/admin_home/domain/repos/admin_dashboard_repo.dart';

class GetAdminDashboardUseCase {
  final AdminDashboardRepo _repo;

  GetAdminDashboardUseCase(this._repo);

  Future<Either<Failure, AdminDashboardModel>> call() async {
    return await _repo.getDashboard();
  }
}
