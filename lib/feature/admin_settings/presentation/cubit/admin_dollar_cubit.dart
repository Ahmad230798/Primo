import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primo/feature/admin_settings/domain/repos/admin_dollar_repo.dart';
import 'admin_dollar_state.dart';

class AdminDollarCubit extends Cubit<AdminDollarState> {
  final AdminDollarRepo _repo;
  num currentDollarValue = 0;

  AdminDollarCubit(this._repo) : super(AdminDollarInitial());

  Future<void> getDollarValue() async {
    if (!isClosed) emit(AdminDollarLoading());
    try {
      final result = await _repo.getDollarValue();
      result.fold(
        (failure) {
          if (!isClosed) emit(AdminDollarError(failure.errorMessage));
        },
        (val) {
          if (val > 0) {
            currentDollarValue = val;
            if (!isClosed) emit(AdminDollarLoaded(val));
          } else {
            if (!isClosed) emit(AdminDollarError("فشل في جلب سعر الصرف"));
          }
        },
      );
    } catch (e) {
      if (!isClosed) emit(AdminDollarError(e.toString()));
    }
  }

  Future<void> updateDollarValue(num dollarValue) async {
    if (!isClosed) emit(AdminDollarUpdating());
    try {
      final result = await _repo.updateDollarValue(dollarValue);
      result.fold(
        (failure) {
          if (!isClosed) emit(AdminDollarError(failure.errorMessage));
        },
        (_) {
          if (dollarValue > 0) {
            currentDollarValue = dollarValue;
          }
          if (!isClosed) {
            emit(AdminDollarUpdateSuccess("تم تحديث سعر الصرف بنجاح", dollarValue));
            emit(AdminDollarLoaded(currentDollarValue));
          }
        },
      );
    } catch (e) {
      if (!isClosed) emit(AdminDollarError(e.toString()));
    }
  }
}
