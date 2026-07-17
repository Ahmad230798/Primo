import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primo/feature/admin_home/data/models/admin_dashboard_model.dart';
import '../../domain/usecases/get_admin_suggestions_usecase.dart';
import '../../domain/usecases/update_suggestion_status_usecase.dart';
import 'admin_suggestions_state.dart';

class AdminSuggestionsCubit extends Cubit<AdminSuggestionsState> {
  final GetAdminSuggestionsUseCase _getSuggestionsUseCase;
  final UpdateSuggestionStatusUseCase _updateStatusUseCase;

  AdminSuggestionsCubit(this._getSuggestionsUseCase, this._updateStatusUseCase)
    : super(AdminSuggestionsInitial());

  List<SuggestionModel> allSuggestions = [];
  String currentTab = 'new';

  Future<void> getSuggestions() async {
    emit(AdminSuggestionsLoading());
    try {
      final result = await _getSuggestionsUseCase();
      result.fold(
        (failure) {
          if (!isClosed) emit(AdminSuggestionsError(failure.errorMessage));
        },
        (list) {
          allSuggestions = list;
          if (!isClosed) filterSuggestions(currentTab);
        },
      );
    } catch (e) {
      if (!isClosed) emit(AdminSuggestionsError(e.toString()));
    }
  }

  void filterSuggestions(String tab) {
    currentTab = tab;

    // 💡 1. إنشاء قائمة مؤقتة للفلترة
    List<SuggestionModel> filteredList = [];

    // 💡 2. منطق التصفية بناءً على الـ status القادم من السيرفر والـ key الخاص بالـ Tabs
    if (tab == 'new') {
      // التبويب "الجديدة" يطابق الحالة "pending" أو null أو empty في الـ JSON
      filteredList = allSuggestions
          .where((item) => item.status == 'pending' || item.status == null || item.status!.trim().isEmpty)
          .toList();
    } else if (tab == 'approved') {
      // التبويب "المقبولة" يطابق الحالة "approved" في الـ JSON
      filteredList = allSuggestions
          .where((item) => item.status == 'approved')
          .toList();
    } else if (tab == 'rejected') {
      // التبويب "المرفوضة" يطابق الحالة "rejected" في الـ JSON
      filteredList = allSuggestions
          .where((item) => item.status == 'rejected')
          .toList();
    } else {
      filteredList = List.from(allSuggestions);
    }

    // 💡 3. إرسال القائمة المفلترة (filteredList) بدلاً من القائمة الكاملة
    if (!isClosed) {
      emit(AdminSuggestionsLoaded(filteredList, currentTab: currentTab));
    }
  }

  Future<void> updateStatus(int id, String status) async {
    emit(AdminSuggestionUpdating(id));
    try {
      final result = await _updateStatusUseCase(id, status);

      result.fold(
        (failure) {
          if (!isClosed) {
            emit(AdminSuggestionsError(failure.errorMessage));
            filterSuggestions(currentTab);
          }
        },
        (msg) {
          final index = allSuggestions.indexWhere((item) => item.id == id);
          if (index != -1) {
            final oldItem = allSuggestions[index];
            allSuggestions[index] = SuggestionModel(
              id: oldItem.id,
              name: oldItem.name,
              description: oldItem.description,
              status: status,
              createdAt: oldItem.createdAt,
              user: oldItem.user,
            );
          }

          if (!isClosed) {
            emit(AdminSuggestionStatusSuccess(msg));
            filterSuggestions(currentTab);
          }
        },
      );
    } catch (e) {
      if (!isClosed) {
        emit(AdminSuggestionsError(e.toString()));
        filterSuggestions(currentTab);
      }
    }
  }
}
