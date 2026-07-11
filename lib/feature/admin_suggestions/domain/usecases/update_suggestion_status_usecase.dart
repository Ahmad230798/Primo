import 'package:dartz/dartz.dart';
import 'package:primo/core/network/api_error_handler.dart';
import '../repo/admin_suggestions_repo.dart';

class UpdateSuggestionStatusUseCase {
  final AdminSuggestionsRepo _repo;
  UpdateSuggestionStatusUseCase(this._repo);

  Future<Either<Failure, String>> call(int suggestionId, String status) async {
    return await _repo.updateSuggestionStatus(suggestionId, status);
  }
}
