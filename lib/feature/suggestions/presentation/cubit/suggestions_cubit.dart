import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primo/feature/suggestions/domain/usecases/send_suggestion_usecase.dart';
import 'suggestions_state.dart';

class SuggestionsCubit extends Cubit<SuggestionsState> {
  final SendSuggestionUseCase _sendSuggestionUseCase;

  SuggestionsCubit(this._sendSuggestionUseCase) : super(SuggestionsInitial());

  Future<void> sendSuggestion({
    required String name,
    required String description,
  }) async {
    if (name.trim().isEmpty) {
      emit(const SuggestionsError("يرجى كتابة اسم المنتج"));
      return;
    }
    emit(SuggestionsSubmitting());
    try {
      final result = await _sendSuggestionUseCase(
        name: name.trim(),
        description: description.trim(),
      );
      result.fold(
        (failure) {
          if (!isClosed) emit(SuggestionsError(failure.errorMessage));
        },
        (msg) {
          if (!isClosed) emit(SuggestionsSuccess(msg));
        },
      );
    } catch (e) {
      if (!isClosed) emit(SuggestionsError(e.toString()));
    }
  }
}
