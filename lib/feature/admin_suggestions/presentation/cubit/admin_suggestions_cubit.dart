import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primo/feature/admin_home/data/models/admin_dashboard_model.dart';
import '../../domain/usecases/get_admin_suggestions_usecase.dart';
import '../../domain/usecases/update_suggestion_status_usecase.dart';
import 'admin_suggestions_state.dart';

class AdminSuggestionsCubit extends Cubit<AdminSuggestionsState> {
  final GetAdminSuggestionsUseCase _getSuggestionsUseCase;
  final UpdateSuggestionStatusUseCase _updateStatusUseCase;

  AdminSuggestionsCubit(
    this._getSuggestionsUseCase,
    this._updateStatusUseCase,
  ) : super(AdminSuggestionsInitial());

  List<SuggestionModel> allSuggestions = [];
  String currentTab = 'new';

  Future<void> getSuggestions() async {
    emit(AdminSuggestionsLoading());
    final result = await _getSuggestionsUseCase();
    result.fold(
      (failure) {
        if (!isClosed) emit(AdminSuggestionsError(failure.errorMessage));
      },
      (list) {
        allSuggestions = list;
        if (!isClosed) emit(AdminSuggestionsLoaded(allSuggestions, currentTab: currentTab));
      },
    );
  }

  void filterSuggestions(String tab) {
    currentTab = tab;
    emit(AdminSuggestionsLoaded(allSuggestions, currentTab: currentTab));
  }

  Future<void> updateStatus(int id, String status) async {
    emit(AdminSuggestionUpdating(id));
    final result = await _updateStatusUseCase(id, status);
    result.fold(
      (failure) {
        if (!isClosed) {
          emit(AdminSuggestionsError(failure.errorMessage));
          emit(AdminSuggestionsLoaded(allSuggestions, currentTab: currentTab));
        }
      },
      (msg) async {
        allSuggestions.removeWhere((item) => item.id == id);
        if (!isClosed) {
          emit(AdminSuggestionStatusSuccess(msg));
          emit(AdminSuggestionsLoaded(allSuggestions, currentTab: currentTab));
          await getSuggestions();
        }
      },
    );
  }
}
