import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primo/feature/admin_home/domain/usecases/get_admin_dashboard_usecase.dart';
import 'package:primo/feature/admin_home/presentation/cubit/admin_dashboard_state.dart';

class AdminDashboardCubit extends Cubit<AdminDashboardState> {
  final GetAdminDashboardUseCase _getDashboardUseCase;

  AdminDashboardCubit(this._getDashboardUseCase) : super(AdminDashboardInitial());

  Future<void> getDashboard() async {
    emit(AdminDashboardLoading());
    try {
      final result = await _getDashboardUseCase();
      result.fold(
        (failure) => emit(AdminDashboardError(failure.errorMessage)),
        (dashboard) => emit(AdminDashboardLoaded(dashboard)),
      );
    } catch (e) {
      if (!isClosed) emit(AdminDashboardError(e.toString()));
    }
  }
}
