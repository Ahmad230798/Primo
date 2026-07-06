import 'package:dartz/dartz.dart';
import 'package:primo/core/network/api_error_handler.dart';
import 'package:primo/feature/suggestions/domain/repos/suggestions_repo.dart';

class SendSuggestionUseCase {
  final SuggestionsRepo _repo;

  SendSuggestionUseCase(this._repo);

  Future<Either<Failure, String>> call({
    required String name,
    required String description,
  }) async {
    return await _repo.sendSuggestion(name: name, description: description);
  }
}
